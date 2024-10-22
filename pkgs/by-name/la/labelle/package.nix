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
  version = "1.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "labelle-org";
    repo = "labelle";
    rev = "refs/tags/v${version}";
    hash = "sha256-nGWffQAXlnKiWBUnSo/IKGdWsLdwLr9N4jAURcVGfj8=";
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
    rich
    typer
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "labelle GUI";
      exec = "labelle-gui";
      desktopName = "labelle GUI";
    })
  ];

  meta = {
    changelog = "https://github.com/labelle-org/labelle/releases/tag/${lib.removePrefix "refs/tags/" src.rev}";
    description = "Print labels with LabelManager PnP from Dymo";
    homepage = "https://github.com/labelle-org/labelle";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fabianrig ];
    mainProgram = "labelle";
  };
}
