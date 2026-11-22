{
  lib,
  python3Packages,
  qt6,
  fetchFromGitHub,
  copyDesktopItems,
  makeDesktopItem,
  onedrive,

  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "onedrivegui";
  version = "2.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bpozdena";
    repo = "OneDriveGUI";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lzSfWVI43JnyOvrbnFVRoeaFFe2yvWPaY7/CA8BHFp8=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  nativeBuildInputs = [
    copyDesktopItems
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtwayland
  ];

  dependencies = with python3Packages; [
    pyside6
    requests
  ];

  pythonRemoveDeps = [
    "PySide6_Essentials"
  ];

  dontWrapQtApps = true;

  doCheck = false; # No tests defined
  # pythonImportsCheck = [ "OneDriveGUI" ]; # requires a display

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [ onedrive ])
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "OneDriveGUI";
      exec = "onedrivegui";
      desktopName = "OneDriveGUI";
      comment = "OneDrive GUI Client";
      type = "Application";
      icon = "OneDriveGUI";
      terminal = false;
      categories = [ "Utility" ];
    })
  ];

  postPatch = ''
    # Patch global_config.py so DIR_PATH points to shared files location
    sed -i src/onedrive_gui/global_config.py -e "s@^DIR_PATH =.*@DIR_PATH = '$out/share/OneDriveGUI'@"
  '';

  postInstall = ''
    mkdir -p $out/share/OneDriveGUI
    # we do not need the `ui` directory - only resources
    cp -r $out/${python3Packages.python.sitePackages}/onedrive_gui/resources $out/share/OneDriveGUI
    install -Dm444 -t $out/share/icons/hicolor/48x48/apps $out/share/OneDriveGUI/resources/images/OneDriveGUI.png
  '';

  postFixup = ''
    # Rename executable
    mv $out/bin/onedrive-gui $out/bin/onedrivegui
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/bpozdena/OneDriveGUI";
    description = "Simple GUI for Linux OneDrive Client, with multi-account support";
    mainProgram = "onedrivegui";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ philipdb ];
    platforms = lib.platforms.linux;
  };
})
