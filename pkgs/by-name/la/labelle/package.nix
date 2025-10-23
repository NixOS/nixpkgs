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
  version = "1.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "labelle-org";
    repo = "labelle";
    tag = "v${version}";
    hash = "sha256-p+V6ihFDxhG7t4LiwTJVfJTk6rxJxGHqxTdplbLZR2Q=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml --replace-fail "hatch-vcs >=0.3.0,<0.4" "hatch-vcs >=0.3.0"
    substituteInPlace pyproject.toml --replace-fail "Pillow>=8.1.2,<11" "Pillow>=8.1.2"
  '';

  buildInputs = [ qt6.qtwayland ];

  nativeBuildInputs = [
    qt6.wrapQtAppsHook
    python3Packages.hatchling
    python3Packages.hatch-fancy-pypi-readme
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
    changelog = "https://github.com/labelle-org/labelle/releases/tag/${src.tag}";
    description = "Print labels with LabelManager PnP from Dymo";
    homepage = "https://github.com/labelle-org/labelle";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fabianrig ];
    mainProgram = "labelle";
  };
}
