{
  lib,
  python3Packages,
  fetchFromGitHub,
  copyDesktopItems,
  makeDesktopItem,
  wrapGAppsHook3,
}:
let
  libretiny = fetchFromGitHub {
    name = "libretiny";
    owner = "libretiny-eu";
    repo = "libretiny";
    rev = "c6b06d4be6f4b8b8069e7b7551fc96f957ccc99c";
    hash = "sha256-JHcS3/G8NSE6pj2yadnfVplzYJEHrFE4PBh0vaBZVOE=";
  };
in
python3Packages.buildPythonApplication rec {
  pname = "ltchiptool";
  version = "4.12.2";
  pyproject = true;

  src = fetchFromGitHub {
    name = "ltchiptool";
    owner = "libretiny-eu";
    repo = "ltchiptool";
    tag = "v${version}";
    hash = "sha256-PTb7HL+tU7jQq42aK9+AjeqFp9Vx6LsDW8zfdX/yA64=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    wrapGAppsHook3
  ];

  preBuild = ''
    # Copy required data
    install -Dm444 ${libretiny}/{platform,families}.json -t ltchiptool
    install -Dm444 ${libretiny}/boards/*.json -t ltchiptool/boards
    cp -r ${libretiny}/boards/_base/ ltchiptool/boards/
  '';

  build-system = with python3Packages; [ poetry-core ];

  pythonRelaxDeps = [ "py-datastruct" ];

  dependencies = with python3Packages; [
    bitstruct
    bk7231tools
    click
    colorama
    hexdump
    importlib-metadata
    prettytable
    pyaes
    py-datastruct
    requests
    semantic-version
    wxpython
    xmodem
    ymodem
    zeroconf
  ];

  # Application has no tests
  doCheck = false;

  pythonImportsCheck = [ "ltchiptool" ];

  desktopItems = [
    (makeDesktopItem rec {
      name = "ltchiptool";
      desktopName = name;
      genericName = "Flashing & dumping tool";
      comment = meta.description;
      icon = "ltchiptool";
      exec = "ltchiptool gui";
      categories = [ "Utility" ];
      keywords = [
        "dump"
        "esphome"
        "firmware"
        "flash"
        "libretiny"
      ];
      singleMainWindow = true;
      terminal = false;
    })
  ];

  postInstall = ''
    install -Dm444 ltchiptool/gui/ltchiptool-192x192.png $out/share/icons/hicolor/192x192/apps/ltchiptool.png
  '';

  meta = {
    description = "Flashing/dumping tool for BK7231, RTL8710B and RTL8720C";
    homepage = "https://github.com/libretiny-eu/ltchiptool";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ungeskriptet ];
    mainProgram = "ltchiptool";
  };
}
