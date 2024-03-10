{
  lib,
  fetchFromGitHub,
  python3Packages,
  qt6,
  makeDesktopItem,
  copyDesktopItems,
}:
python3Packages.buildPythonApplication rec {
  pname = "dymoprint";
  version = "2.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "computerlyrik";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-/nNZ/+fxoCC9EF7v7/yY2wNXbPMGZmeKgpnETNCIDvY=";
    name = "${pname}-${version}";
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
    appdirs
    pillow
    pyqrcode
    pyqt6
    python-barcode
    pyusb
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "dymoprint GUI";
      exec = "dymoprint_gui";
      desktopName = "dymoprint GUI";
    })
  ];

  meta = {
    changelog = "https://github.com/computerlyrik/dymoprint/releases/tag/v${version}";
    description = "Software to print with LabelManager PnP from Dymo";
    homepage = "https://github.com/computerlyrik/dymoprint";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fabianrig ];
  };
}
