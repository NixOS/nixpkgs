{
  lib,
  fetchFromGitHub,
  python3Packages,
  qt6,
  makeDesktopItem,
  copyDesktopItems,
}:
python3Packages.buildPythonApplication rec {
  pname = "labelle";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "labelle-org";
    repo = "labelle";
    rev = "v${version}";
    hash = "sha256-JnV5A3/toTCHCEb0dygouR9MZfk2kdmsKVscwYI2y/Y=";
  };

  postPatch = ''
    sed -i 's/hatch-vcs >=0.3.0,<0.4/hatch-vcs >=0.3.0/' pyproject.toml
  '';

  buildInputs = [ qt6.qtwayland ];

  nativeBuildInputs = [
    qt6.wrapQtAppsHook
    python3Packages.hatchling
    python3Packages.hatch-vcs
    copyDesktopItems
  ];

  propagatedBuildInputs = with python3Packages; [
    darkdetect
    pillow
    platformdirs
    pyqrcode
    pyqt6
    python-barcode
    pyusb
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "labelle GUI";
      exec = "labelle-gui";
      desktopName = "labelle GUI";
    })
  ];

  meta = {
    changelog = "https://github.com/labelle-org/labelle/releases/tag/${src.rev}";
    description = "Print labels with LabelManager PnP from Dymo";
    homepage = "https://github.com/labelle-org/labelle";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fabianrig ];
    mainProgram = "labelle";
  };
}
