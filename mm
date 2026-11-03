-- ==========================================
-- +1 ANIME EYES - AUTO FARM V3 (MAX SPEED)
-- ==========================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local env = (getgenv and getgenv()) or _G

if env.AnimeEyes_ProCleanup then
	pcall(env.AnimeEyes_ProCleanup)
end

local State = {
	AutoStage = false,
	AutoAttack = false,
	AutoTrain = false,
	AutoRebirth = false,
	SelectedStage = 1,
}
local connections = {}

local function track(conn)
	table.insert(connections, conn)
	return conn
end

-- ==================== GIAO DIỆN (UI PRO) ====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AnimeEyesPro_UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 9999

local success = pcall(function() ScreenGui.Parent = (gethui and gethui()) or CoreGui end)
if not success or not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local Theme = {
	Bg = Color3.fromRGB(15, 15, 20),
	Card = Color3.fromRGB(25, 25, 35),
	Accent = Color3.fromRGB(170, 80, 255),
	Text = Color3.fromRGB(240, 240, 255),
	Off = Color3.fromRGB(50, 50, 65),
	Success = Color3.fromRGB(40, 220, 110)
}

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.fromOffset(400, 320)
MainFrame.Position = UDim2.fromScale(0.5, 0.5)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Theme.Bg
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Color = Theme.Accent
Stroke.Thickness = 2
local grad = Instance.new("UIGradient", Stroke)
grad.Color = ColorSequence.new(Theme.Accent, Color3.fromRGB(0, 230, 255))

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 45)
Header.BackgroundColor3 = Theme.Card
Header.BorderSizePixel = 0
Header.Parent = MainFrame
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 10)
local FixHead = Instance.new("Frame")
FixHead.Size = UDim2.new(1, 0, 0, 10)
FixHead.Position = UDim2.new(0, 0, 1, -10)
FixHead.BackgroundColor3 = Theme.Card
FixHead.BorderSizePixel = 0
FixHead.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.fromOffset(15, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Text = "👁️ +1 ANIME EYES V3"
Title.TextColor3 = Theme.Text
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.fromOffset(26, 26)
CloseBtn.Position = UDim2.new(1, -36, 0.5, -13)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 80)
CloseBtn.Text = "✕"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Parent = Header
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

-- Kéo thả UI
local dragging, dragInput, dragStart, startPos
Header.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true; dragStart = input.Position; startPos = MainFrame.Position
	end
end)
Header.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)
track(UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end))
track(UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end))

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -20, 1, -60)
Scroll.Position = UDim2.fromOffset(10, 50)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 3
Scroll.ScrollBarImageColor3 = Theme.Accent
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.Parent = MainFrame
local layout = Instance.new("UIListLayout", Scroll)
layout.Padding = UDim.new(0, 8)
layout.SortOrder = Enum.SortOrder.LayoutOrder

local function createToggle(text, varName, callback)
	local Card = Instance.new("TextButton")
	Card.Size = UDim2.new(1, 0, 0, 44)
	Card.BackgroundColor3 = Theme.Card
	Card.Text = ""
	Card.AutoButtonColor = false
	Card.Parent = Scroll
	Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 8)

	local Lbl = Instance.new("TextLabel")
	Lbl.Size = UDim2.new(1, -70, 1, 0)
	Lbl.Position = UDim2.fromOffset(14, 0)
	Lbl.BackgroundTransparency = 1
	Lbl.Font = Enum.Font.GothamSemibold
	Lbl.Text = text
	Lbl.TextColor3 = Theme.Text
	Lbl.TextSize = 13
	Lbl.TextXAlignment = Enum.TextXAlignment.Left
	Lbl.Parent = Card

	local Switch = Instance.new("Frame")
	Switch.Size = UDim2.fromOffset(44, 22)
	Switch.Position = UDim2.new(1, -56, 0.5, -11)
	Switch.BackgroundColor3 = Theme.Off
	Switch.Parent = Card
	Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)

	local Knob = Instance.new("Frame")
	Knob.Size = UDim2.fromOffset(16, 16)
	Knob.Position = UDim2.new(0, 3, 0.5, -8)
	Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Knob.Parent = Switch
	Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

	Card.MouseButton1Click:Connect(function()
		State[varName] = not State[varName]
		local on = State[varName]
		TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = on and Theme.Success or Theme.Off}):Play()
		TweenService:Create(Knob, TweenInfo.new(0.2, Enum.EasingStyle.Back), {Position = on and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)}):Play()
		if callback then callback(on) end
	end)
end

local function createSlider(title, min, max, varName)
	local Card = Instance.new("Frame")
	Card.Size = UDim2.new(1, 0, 0, 54)
	Card.BackgroundColor3 = Theme.Card
	Card.Parent = Scroll
	Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 8)

	local Lbl = Instance.new("TextLabel")
	Lbl.Size = UDim2.new(1, -80, 0, 20)
	Lbl.Position = UDim2.fromOffset(14, 6)
	Lbl.BackgroundTransparency = 1
	Lbl.Font = Enum.Font.GothamSemibold
	Lbl.Text = title
	Lbl.TextColor3 = Theme.Text
	Lbl.TextSize = 13
	Lbl.TextXAlignment = Enum.TextXAlignment.Left
	Lbl.Parent = Card

	local ValLbl = Instance.new("TextLabel")
	ValLbl.Size = UDim2.fromOffset(50, 20)
	ValLbl.Position = UDim2.new(1, -64, 0, 6)
	ValLbl.BackgroundTransparency = 1
	ValLbl.Font = Enum.Font.GothamBold
	ValLbl.Text = tostring(State[varName])
	ValLbl.TextColor3 = Theme.Accent
	ValLbl.TextSize = 13
	ValLbl.TextXAlignment = Enum.TextXAlignment.Right
	ValLbl.Parent = Card

	local MinusBtn = Instance.new("TextButton")
	MinusBtn.Size = UDim2.fromOffset(30, 22)
	MinusBtn.Position = UDim2.new(0, 14, 0, 26)
	MinusBtn.BackgroundColor3 = Theme.Off
	MinusBtn.Font = Enum.Font.GothamBold
	MinusBtn.Text = "-"
	MinusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	MinusBtn.Parent = Card
	Instance.new("UICorner", MinusBtn).CornerRadius = UDim.new(0, 4)

	local PlusBtn = Instance.new("TextButton")
	PlusBtn.Size = UDim2.fromOffset(30, 22)
	PlusBtn.Position = UDim2.new(0, 48, 0, 26)
	PlusBtn.BackgroundColor3 = Theme.Off
	PlusBtn.Font = Enum.Font.GothamBold
	PlusBtn.Text = "+"
	PlusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	PlusBtn.Parent = Card
	Instance.new("UICorner", PlusBtn).CornerRadius = UDim.new(0, 4)

	local function updateVal(amount)
		State[varName] = math.clamp(State[varName] + amount, min, max)
		ValLbl.Text = tostring(State[varName])
	end
	MinusBtn.MouseButton1Click:Connect(function() updateVal(-1) end)
	PlusBtn.MouseButton1Click:Connect(function() updateVal(1) end)
end

-- ==================== CHỨC NĂNG (ĐÃ FIX LOGIC & MAX SPEED) ====================

createSlider("🏆 Chọn Màn (Auto Stage Limit)", 1, 15, "SelectedStage")

-- 1. Auto Stage (Fix lỗi vị trí an toàn & Lấy Win)
local gravityBackup = workspace.Gravity
createToggle("🚀 Tự Động Vượt Ải (Auto Stage)", "AutoStage", function(on)
	if on then
		workspace.Gravity = 0
		track(RunService.Stepped:Connect(function()
			if not State.AutoStage then return end
			local char = LocalPlayer.Character
			if char then
				for _, part in ipairs(char:GetDescendants()) do
					if part:IsA("BasePart") then part.CanCollide = false end
				end
			end
		end))

		task.spawn(function()
			while State.AutoStage do
				pcall(function()
					local targetLimit = State.SelectedStage
					local runCleared = LocalPlayer:GetAttribute("RunCleared") or 0
					local currentWorld = LocalPlayer:GetAttribute("RunWorld")
					local instance = nil

					for _, v in ipairs(workspace:GetChildren()) do
						if v:GetAttribute("World") == currentWorld then instance = v break end
					end

					if instance and instance:FindFirstChild("Stages") then
						if runCleared < targetLimit then
							-- Đang trong quá trình đánh quái để qua ải (Dịch ra chỗ an toàn 30,5,20)
							local stageFolder = instance.Stages:FindFirstChild("Stage" .. tostring(runCleared + 1))
							if stageFolder then
								for _, pad in ipairs(stageFolder:GetDescendants()) do
									if pad.Name == "Pad" and pad.Parent.Name == "PadGold" then
										local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
										if hrp then
											hrp.CFrame = pad.CFrame * CFrame.new(30, 5, 20)
											hrp.Velocity = Vector3.zero
										end
										break
									end
								end
							end
						else
							-- Đã clear xong ải mục tiêu -> Nhảy vào giữa bệ Vàng lấy Win (0,5,0)
							local stageFolder = instance.Stages:FindFirstChild("Stage" .. tostring(targetLimit))
							if stageFolder then
								for _, pad in ipairs(stageFolder:GetDescendants()) do
									if pad.Name == "Pad" and pad.Parent.Name == "PadGold" then
										local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
										if hrp then
											hrp.CFrame = pad.CFrame * CFrame.new(0, 5, 0)
											hrp.Velocity = Vector3.zero
										end
										break
									end
								end
							end
						end
					end
				end)
				task.wait(0.5)
			end
		end)
	else
		workspace.Gravity = gravityBackup
		local char = LocalPlayer.Character
		if char then
			for _, part in ipairs(char:GetDescendants()) do
				if part:IsA("BasePart") then part.CanCollide = true end
			end
			local hum = char:FindFirstChildOfClass("Humanoid")
			if hum then hum.Health = 0 end
		end
	end
end)

-- 2. Auto Attack
createToggle("⚔️ Tự Động Đánh (Auto Attack)", "AutoAttack", function(on)
	if on then
		task.spawn(function()
			while State.AutoAttack do
				pcall(function()
					local enemies = workspace:FindFirstChild("MyEnemies")
					if enemies then
						for _, enemy in ipairs(enemies:GetChildren()) do
							local foeId = enemy:GetAttribute("FoeId")
							local hrp = enemy:FindFirstChild("HumanoidRootPart")
							local remotes = ReplicatedStorage:FindFirstChild("Remotes")
							
							if foeId and hrp and remotes and remotes:FindFirstChild("Cast") then
								local pos = hrp.Position
								remotes.Cast:FireServer("attack", pos, foeId)
								remotes.Cast:FireServer("E", pos)
								remotes.Cast:FireServer("R", pos)
								break
							end
						end
					end
				end)
				task.wait() -- Đã xóa delay
			end
		end)
	end
end)

-- 3. Auto Train & Pops (Nâng lên Max Speed 0 Delay)
createToggle("🏋️ Tự Tập Luyện & Nhặt Bóng", "AutoTrain", function(on)
	if on then
		-- Chạy lệnh Train Max Tốc độ
		task.spawn(function()
			while State.AutoTrain do
				pcall(function()
					local remotes = ReplicatedStorage:FindFirstChild("Remotes")
					if remotes and remotes:FindFirstChild("Train") then
						remotes.Train:FireServer()
					end
				end)
				task.wait() -- Bỏ qua toàn bộ delay, spam tín hiệu mạnh nhất có thể
			end
		end)
		
		-- Chạy nhặt bóng (Bubble) song song Max tốc độ
		task.spawn(function()
			while State.AutoTrain do
				pcall(function()
					local gui = LocalPlayer:FindFirstChild("PlayerGui")
					if gui then
						local pops = gui:FindFirstChild("Pops", true)
						if pops then
							for _, bubble in ipairs(pops:GetDescendants()) do
								if bubble.Name == "Bubble" and bubble:IsA("GuiButton") then
									for _, conn in ipairs(getconnections(bubble.Activated)) do
										conn:Fire()
									end
								end
							end
						end
					end
				end)
				task.wait()
			end
		end)
	end
end)

-- 4. Auto Rebirth (Đã Vá Code Gửi Lên Server)
createToggle("♻️ Tự Động Chuyển Sinh (Rebirth)", "AutoRebirth", function(on)
	if on then
		task.spawn(function()
			while State.AutoRebirth do
				pcall(function()
					local remotes = ReplicatedStorage:FindFirstChild("Remotes")
					if remotes and remotes:FindFirstChild("Rebirth") then
						remotes.Rebirth:FireServer(1) -- Ép lệnh chuyển sinh
						remotes.Rebirth:FireServer()
					end
				end)
				task.wait(1)
			end
		end)
	end
end)

-- Mở khóa tầm nhìn Camera
LocalPlayer.CameraMinZoomDistance = 0.5
LocalPlayer.CameraMaxZoomDistance = 1000
LocalPlayer.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Invisicam

CloseBtn.MouseButton1Click:Connect(function()
	if env.AnimeEyes_ProCleanup then env.AnimeEyes_ProCleanup() end
end)

env.AnimeEyes_ProCleanup = function()
	for k, _ in pairs(State) do State[k] = false end
	for _, c in ipairs(connections) do pcall(function() c:Disconnect() end) end
	if ScreenGui then pcall(function() ScreenGui:Destroy() end) end
	workspace.Gravity = gravityBackup
	env.AnimeEyes_ProCleanup = nil
end

pcall(function()
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "+1 Anime Eyes V3",
		Text = "Tải thành công! Tốc độ Train MAX, Lỗi Stage Đã Fix.",
		Duration = 5,
	})
end)
