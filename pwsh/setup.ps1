#Requires -RunAsAdministrator

# script originally made by kuroji fusky

# Stuff that requires admin privilages for screwing around with the registry
Write-Output "Writing stuff to registry"

# Enable verbose log for shutdown, restart, login, etc
$RD_VerboseLogging = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
New-ItemProperty -Path $RD_VerboseLogging -Name "verbosestatus" -Value 1 -Type Dword -Force

# Show file extensions
$RD_ShowFileExt = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
New-ItemProperty -Path $RD_ShowFileExt -Name "HideFileExt" -Value 0 -Type Dword -Force


$WingetPrograms = @(
  # The good stuff
  "Git.Git",
  "Mozilla.Firefox",
  "Google.Chrome",
  "7zip.7zip",

  # programming languages
  "CoreyButler.NVMforWindows",
  "Python.Python.3.11",
  "Rustlang.Rustup",

  # Video Audio Images stuff
  "VideoLAN.VLC",
  "OBSProject.OBSStudio",
  "SartoxOnlyGNU.Audacium",
  "GIMP.GIMP",
  "OpenShot.OpenShot",
  "SharkLabs.ClownfishVoiceChanger",

  # Encryption software
  "GnuPG.GnuPG",
  "GnuPG.Gpg4win",
  "OpenVPNTechnologies.OpenVPNConnect",
  
  # Code editors/IDEs
  "Neovim.Neovim",
  "Microsoft.VisualStudioCode.Insiders",
  "JetBrains.PyCharm.Community",
  "MHNexus.HxD",

  # Productivity and management
  "Discord.Discord",
  "Google.Drive",
  "Zoom.Zoom",

  # games
  "Valve.Steam",
  "Mojang.MinecraftLauncher",

  # Miscellanous
  "Oracle.VirtualBox",
  "SoftwareFreedomConservancy.QEMU",
  "Docker.DockerDesktop",
  "RaspberryPiFoundation.RaspberryPiImager",

  # Fancy terminal stuff
  "JanDeDobbeleer.OhMyPosh",
  "Microsoft.PowerShell.Preview",
  "Microsoft.WindowsTerminal"
)

function SetupWorkspace {
  Write-Output "Installing your crap right now"
  Write-Output "Installing stuff via winget"

  foreach ($program in $WingetPrograms) {
    Write-Output "Installing $program..."
    winget install -e --id $program
  }

  # ===================================
  # Install python and node stuff globally

  # Install latest node version using nvm
  nvm install lts

  $NPM_Packages = @(
    "typescript",
    "yarn",
    "pnpm",
    "npkill"
  )

  $Python_Packages = @(
    "numpy",
    "autopep8",
    "yapf",
    "mypy",
    "requests",
    "beautifulsoup4",
    "opencv-contrib-python",

    # Data science stuff
    "pandas",
    "matplotlib",
    "ipykernel"
  )

  npm install -g $NPM_Packages
  python -m pip install -U $Python_Packages --verbose

  # ===================================
  # Setup git stuff
  Write-Output "Setup almost done!"

  $name = Read-Host "Enter username: "
  $email = Read-Host "Enter email: "

  git config --global user.name $name
  git config --global user.email $email
  git config --global core.ignorecase false
}

# Check if the winget command is available, just in case
# of a fresh install
if (Get-Command winget -ErrorAction SilentlyContinue) {
  Write-Output "winget not detected on your system, installing..."
  Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe
  SetupWorkspace
}
else {
  SetupWorkspace
}
