-- Dex Hub Script para Roblox
-- Sistema completo com ESP, Teleporte, Voo e mais

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Variáveis de controle
local DexHub = {
    Enabled = false,
    ESP = {
        Enabled = false,
        ShowName = true,
        ShowDistance = true,
        ShowHealth = true,
        RedESP = false,
        GreenESP = false,
        Boxes = {}
    },
    Teleport = {
        Enabled = false,
        ClickTeleport = false
    },
    Flight = {
        Enabled = false,
        Speed = 50,
        Flying = false
    }
}

-- Criar ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DexHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Proteção contra detecção
if gethui then
    ScreenGui.Parent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = game.CoreGui
else
    ScreenGui.Parent = game.CoreGui
end

-- Botão de Toggle (Ícone)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Position = UDim2.new(0, 10, 0.5, -25)
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
ToggleButton.BorderSizePixel = 0
ToggleButton.Text = "🎮"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 28
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Parent = ScreenGui

-- Arredondar cantos do botão
local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 10)
ToggleCorner.Parent = ToggleButton

-- Frame Principal
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 550, 0, 350)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Barra de Título
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -10, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "🎮 Dex Hub"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 16
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

-- Sidebar (Amarela)
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 140, 1, -35)
Sidebar.Position = UDim2.new(0, 0, 0, 35)
Sidebar.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

-- Content Area (Maior)
local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(1, -140, 1, -35)
ContentArea.Position = UDim2.new(0, 140, 0, 35)
ContentArea.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
ContentArea.BorderSizePixel = 0
ContentArea.Parent = MainFrame

-- Função para criar botões da sidebar
local function CreateSidebarButton(text, position, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -10, 0, 35)
    button.Position = UDim2.new(0, 5, 0, position)
    button.BackgroundColor3 = Color3.fromRGB(240, 190, 40)
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = Color3.fromRGB(0, 0, 0)
    button.TextSize = 14
    button.Font = Enum.Font.GothamBold
    button.Parent = Sidebar
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button
    
    button.MouseButton1Click:Connect(callback)
    return button
end

-- Função para criar switches
local function CreateSwitch(parent, text, yPosition, callback)
    local switchFrame = Instance.new("Frame")
    switchFrame.Size = UDim2.new(1, -20, 0, 30)
    switchFrame.Position = UDim2.new(0, 10, 0, yPosition)
    switchFrame.BackgroundTransparency = 1
    switchFrame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = switchFrame
    
    local switch = Instance.new("TextButton")
    switch.Size = UDim2.new(0, 45, 0, 22)
    switch.Position = UDim2.new(1, -50, 0.5, -11)
    switch.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    switch.BorderSizePixel = 0
    switch.Text = ""
    switch.Parent = switchFrame
    
    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(1, 0)
    switchCorner.Parent = switch
    
    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 16, 0, 16)
    indicator.Position = UDim2.new(0, 3, 0.5, -8)
    indicator.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    indicator.BorderSizePixel = 0
    indicator.Parent = switch
    
    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(1, 0)
    indicatorCorner.Parent = indicator
    
    local enabled = false
    switch.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            switch.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
            indicator.Position = UDim2.new(1, -19, 0.5, -8)
        else
            switch.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            indicator.Position = UDim2.new(0, 3, 0.5, -8)
        end
        callback(enabled)
    end)
    
    return switchFrame
end

-- Páginas de conteúdo
local ESPPage = Instance.new("ScrollingFrame")
ESPPage.Name = "ESPPage"
ESPPage.Size = UDim2.new(1, 0, 1, 0)
ESPPage.BackgroundTransparency = 1
ESPPage.BorderSizePixel = 0
ESPPage.ScrollBarThickness = 6
ESPPage.Visible = true
ESPPage.Parent = ContentArea

local TeleportPage = Instance.new("ScrollingFrame")
TeleportPage.Name = "TeleportPage"
TeleportPage.Size = UDim2.new(1, 0, 1, 0)
TeleportPage.BackgroundTransparency = 1
TeleportPage.BorderSizePixel = 0
TeleportPage.ScrollBarThickness = 6
TeleportPage.Visible = false
TeleportPage.Parent = ContentArea

local FlightPage = Instance.new("ScrollingFrame")
FlightPage.Name = "FlightPage"
FlightPage.Size = UDim2.new(1, 0, 1, 0)
FlightPage.BackgroundTransparency = 1
FlightPage.BorderSizePixel = 0
FlightPage.ScrollBarThickness = 6
FlightPage.Visible = false
FlightPage.Parent = ContentArea

local InfoPage = Instance.new("ScrollingFrame")
InfoPage.Name = "InfoPage"
InfoPage.Size = UDim2.new(1, 0, 1, 0)
InfoPage.BackgroundTransparency = 1
InfoPage.BorderSizePixel = 0
InfoPage.ScrollBarThickness = 6
InfoPage.Visible = false
InfoPage.Parent = ContentArea

-- Título das páginas
local function CreatePageTitle(page, text)
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 30)
    title.Position = UDim2.new(0, 10, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = text
    title.TextColor3 = Color3.fromRGB(255, 200, 50)
    title.TextSize = 18
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = page
end

CreatePageTitle(ESPPage, "🎯 ESP Settings")
CreatePageTitle(TeleportPage, "🚀 Teleporte")
CreatePageTitle(FlightPage, "✈️ Voo")
CreatePageTitle(InfoPage, "ℹ️ Informações")

-- ESP Switches
CreateSwitch(ESPPage, "Ativar ESP", 50, function(enabled)
    DexHub.ESP.Enabled = enabled
end)

CreateSwitch(ESPPage, "ESP Vermelho", 90, function(enabled)
    DexHub.ESP.RedESP = enabled
    if enabled then DexHub.ESP.GreenESP = false end
end)

CreateSwitch(ESPPage, "ESP Verde", 130, function(enabled)
    DexHub.ESP.GreenESP = enabled
    if enabled then DexHub.ESP.RedESP = false end
end)

CreateSwitch(ESPPage, "Mostrar Nome", 170, function(enabled)
    DexHub.ESP.ShowName = enabled
end)

CreateSwitch(ESPPage, "Mostrar Distância", 210, function(enabled)
    DexHub.ESP.ShowDistance = enabled
end)

CreateSwitch(ESPPage, "Mostrar Vida", 250, function(enabled)
    DexHub.ESP.ShowHealth = enabled
end)

-- Teleport Switches
CreateSwitch(TeleportPage, "Teleporte ao Clicar", 50, function(enabled)
    DexHub.Teleport.ClickTeleport = enabled
end)

-- Flight Switches
CreateSwitch(FlightPage, "Ativar Voo", 50, function(enabled)
    DexHub.Flight.Enabled = enabled
end)

-- Info Page
local infoText = Instance.new("TextLabel")
infoText.Size = UDim2.new(1, -20, 0, 200)
infoText.Position = UDim2.new(0, 10, 0, 50)
infoText.BackgroundTransparency = 1
infoText.Text = [[
🎮 Dex Hub v1.0

Desenvolvido para Roblox

Recursos:
• ESP customizável
• Teleporte por clique
• Sistema de voo
• Interface arrastável

Controles de Voo:
• E - Subir
• Q - Descer
• WASD - Movimento

Aproveite!]]
infoText.TextColor3 = Color3.fromRGB(200, 200, 200)
infoText.TextSize = 13
infoText.Font = Enum.Font.Gotham
infoText.TextWrapped = true
infoText.TextYAlignment = Enum.TextYAlignment.Top
infoText.TextXAlignment = Enum.TextXAlignment.Left
infoText.Parent = InfoPage

-- Botões da Sidebar
CreateSidebarButton("ESP", 10, function()
    ESPPage.Visible = true
    TeleportPage.Visible = false
    FlightPage.Visible = false
    InfoPage.Visible = false
end)

CreateSidebarButton("Teleporte", 55, function()
    ESPPage.Visible = false
    TeleportPage.Visible = true
    FlightPage.Visible = false
    InfoPage.Visible = false
end)

CreateSidebarButton("Voo", 100, function()
    ESPPage.Visible = false
    TeleportPage.Visible = false
    FlightPage.Visible = true
    InfoPage.Visible = false
end)

CreateSidebarButton("Info", 145, function()
    ESPPage.Visible = false
    TeleportPage.Visible = false
    FlightPage.Visible = false
    InfoPage.Visible = true
end)

-- Toggle GUI
ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Arrastar GUI
local dragging, dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Sistema de ESP
local function CreateESP(player)
    if player == LocalPlayer then return end
    
    local espBox = Instance.new("BillboardGui")
    espBox.Name = "ESP_" .. player.Name
    espBox.Adornee = nil
    espBox.AlwaysOnTop = true
    espBox.Size = UDim2.new(0, 200, 0, 50)
    espBox.StudsOffset = Vector3.new(0, 3, 0)
    espBox.Parent = ScreenGui
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0.4, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextSize = 14
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextStrokeTransparency = 0.5
    nameLabel.Parent = espBox
    
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(1, 0, 0.6, 0)
    infoLabel.Position = UDim2.new(0, 0, 0.4, 0)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Text = ""
    infoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    infoLabel.TextSize = 12
    infoLabel.Font = Enum.Font.Gotham
    infoLabel.TextStrokeTransparency = 0.5
    infoLabel.Parent = espBox
    
    DexHub.ESP.Boxes[player.Name] = espBox
    
    local function UpdateESP()
        if not DexHub.ESP.Enabled then
            espBox.Enabled = false
            return
        end
        
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            espBox.Adornee = character.HumanoidRootPart
            espBox.Enabled = true
            
            local humanoid = character:FindFirstChild("Humanoid")
            local distance = (LocalPlayer.Character.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude
            
            -- Cores do ESP
            local espColor = Color3.fromRGB(255, 255, 255)
            if DexHub.ESP.RedESP then
                espColor = Color3.fromRGB(255, 50, 50)
            elseif DexHub.ESP.GreenESP then
                espColor = Color3.fromRGB(50, 255, 50)
            end
            
            nameLabel.TextColor3 = espColor
            infoLabel.TextColor3 = espColor
            nameLabel.Visible = DexHub.ESP.ShowName
            
            local infoText = ""
            if DexHub.ESP.ShowDistance then
                infoText = infoText .. string.format("%.0f studs", distance)
            end
            if DexHub.ESP.ShowHealth and humanoid then
                if infoText ~= "" then infoText = infoText .. " | " end
                infoText = infoText .. string.format("HP: %.0f/%.0f", humanoid.Health, humanoid.MaxHealth)
            end
            infoLabel.Text = infoText
        else
            espBox.Enabled = false
        end
    end
    
    RunService.RenderStepped:Connect(UpdateESP)
end

-- Adicionar ESP para todos os jogadores
for _, player in pairs(Players:GetPlayers()) do
    CreateESP(player)
end

Players.PlayerAdded:Connect(CreateESP)

Players.PlayerRemoving:Connect(function(player)
    if DexHub.ESP.Boxes[player.Name] then
        DexHub.ESP.Boxes[player.Name]:Destroy()
        DexHub.ESP.Boxes[player.Name] = nil
    end
end)

-- Sistema de Teleporte
Mouse.Button1Down:Connect(function()
    if DexHub.Teleport.ClickTeleport and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local target = Mouse.Hit.Position
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(target + Vector3.new(0, 3, 0))
    end
end)

-- Sistema de Voo
local flyConnection
local function StartFlying()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = LocalPlayer.Character.HumanoidRootPart
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bodyVelocity.Parent = hrp
    
    local bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.CFrame = hrp.CFrame
    bodyGyro.Parent = hrp
    
    flyConnection = RunService.RenderStepped:Connect(function()
        if not DexHub.Flight.Enabled then
            bodyVelocity:Destroy()
            bodyGyro:Destroy()
            if flyConnection then flyConnection:Disconnect() end
            return
        end
        
        local camera = workspace.CurrentCamera
        local moveDir = Vector3.new(0, 0, 0)
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDir = moveDir + camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDir = moveDir - camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDir = moveDir - camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDir = moveDir + camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.E) then
            moveDir = moveDir + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Q) then
            moveDir = moveDir - Vector3.new(0, 1, 0)
        end
        
        bodyVelocity.Velocity = moveDir * DexHub.Flight.Speed
        bodyGyro.CFrame = camera.CFrame
    end)
end

-- Monitorar ativação do voo
local lastFlightState = false
RunService.RenderStepped:Connect(function()
    if DexHub.Flight.Enabled and not lastFlightState then
        StartFlying()
        lastFlightState = true
    elseif not DexHub.Flight.Enabled and lastFlightState then
        lastFlightState = false
    end
end)

print("✅ Dex Hub carregado com sucesso!")
print("🎮 Clique no ícone no canto esquerdo para abrir o menu")
