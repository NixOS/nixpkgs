{
  fetchFromGitHub,
  lib,
  nix-update-script,
  python3Packages,
  qt6,
  qt6Packages,
  ...
}:
let
  aiocmd = python3Packages.buildPythonPackage rec {
    name = "aiocmd";
    version = "v0.1.5";
    src = fetchFromGitHub {
      owner = "KimiNewt";
      repo = "aiocmd";
      rev = version;
      hash = "sha256-C8dpeMTaoOMgfNP19JUYKUf+Vyw36Ry6dHkhaSm/QNk=";
    };
    format = "setuptools";
  };
in
python3Packages.buildPythonApplication rec {
  name = "open-freebuds";
  version = "0.17.1";

  src = fetchFromGitHub {
    owner = "melianmiko";
    repo = "OpenFreebuds";
    tag = "v${version}";
    hash = "sha256-y89BTKk14P/2kkYo63i9HgAdenzCVVnNArDsTmo4bPU=";
  };

  format = "pyproject";

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "psutil<7.0.0,>=6.1.0" "psutil<=7.0.0,>=6.1.0"
  '';

  nativeBuildInputs = [
    qt6Packages.wrapQtAppsHook
    qt6Packages.qttools
    python3Packages.pyqt6
  ];

  dependencies = with python3Packages; [
    aiocmd
    aiohttp
    dbus-next
    pdm-backend
    pillow
    psutil
    pynput
    pyqt6
    qasync
    qt6.qtbase
  ];

  preBuild = ''
    find openfreebuds_qt/designer -name "*.ui" | while read ui_file; do
      py_file="''${ui_file%.ui}.py"
      pyuic6 "$ui_file" -o "$py_file"
    done

    lrelease openfreebuds_qt/assets/i18n/*.ts
  '';

  postFixup = ''
    wrapQtApp $out/bin/openfreebuds_qt
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open source app for HUAWEI FreeBuds (Linux + Windows)";
    homepage = "https://github.com/melianmiko/OpenFreebuds";
    changelog = "https://github.com/melianmiko/OpenFreebuds/releases/tag/v${version}";
    maintainers = [ lib.maintainers.znaniye ];
    platforms = lib.platforms.linux;
  };
}
