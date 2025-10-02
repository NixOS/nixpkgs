{
  fetchFromGitHub,
  lib,
  nix-update-script,
  python3Packages,
  qt6,
  qt6Packages,
}:
python3Packages.buildPythonApplication rec {
  name = "openfreebuds";
  version = "0.17.1";

  src = fetchFromGitHub {
    owner = "melianmiko";
    repo = "OpenFreebuds";
    tag = "v${version}";
    hash = "sha256-y89BTKk14P/2kkYo63i9HgAdenzCVVnNArDsTmo4bPU=";
  };

  pyproject = true;

  pythonRelaxDeps = [ "psutil" ];

  build-system = with python3Packages; [
    pdm-backend
    pyqt6
  ];

  nativeBuildInputs = [
    qt6Packages.wrapQtAppsHook
    qt6Packages.qttools
  ];

  buildInputs = [ qt6.qtbase ];

  dependencies = with python3Packages; [
    aiocmd
    aiohttp
    dbus-next
    pillow
    psutil
    pynput
    pyqt6
    qasync
  ];

  preBuild = ''
    find openfreebuds_qt/designer -name "*.ui" | while read ui_file; do
      py_file="''${ui_file%.ui}.py"
      pyuic6 "$ui_file" -o "$py_file"
    done

    lrelease openfreebuds_qt/assets/i18n/*.ts
  '';

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/melianmiko/OpenFreebuds/blob/${src.rev}/CHANGELOG.md";
    description = "Open source app for HUAWEI FreeBuds (Linux + Windows)";
    homepage = "https://github.com/melianmiko/OpenFreebuds";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.znaniye ];
    platforms = lib.platforms.linux;
  };
}
