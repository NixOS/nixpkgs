{
  lib,
  python3Packages,
  fetchFromGitHub,
  makeDesktopItem,
  copyDesktopItems,
  qt6,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "flashgbx";
  version = "5.0.1";

  src = fetchFromGitHub {
    repo = "FlashGBX";
    owner = "lesserkuma";
    tag = finalAttrs.version;
    hash = "sha256-7iDLOL0FavPd8aKQz2rwV7seuINbejssGeYm37BN9jM=";
  };

  desktopItems = [
    (makeDesktopItem {
      name = "flashgbx";
      desktopName = "FlashGBX UI";
      icon = "flashgbx";
      exec = finalAttrs.meta.mainProgram;
      comment = "UI for reading and writing Game Boy and Game Boy Advance cartridges";
      categories = [ "Utility" ];
    })
  ];

  postInstall = ''
    install -D FlashGBX/res/icon.png $out/share/icons/hicolor/256x256/apps/flashgbx.png
  '';

  pyproject = true;

  nativeBuildInputs = [
    python3Packages.setuptools
    copyDesktopItems
    qt6.wrapQtAppsHook
  ];

  propagatedBuildInputs =
    with python3Packages;
    [
      pillow
      pyserial
      pyside6
      python-dateutil
      requests
      setuptools
      qt6.qtbase
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      qt6.qtwayland
    ];

  meta = {
    description = "GUI for reading and writing GB and GBA cartridges with the GBxCart RW";
    homepage = "https://github.com/lesserkuma/FlashGBX";
    license = lib.licenses.gpl3Only;
    mainProgram = "flashgbx";
    maintainers = with lib.maintainers; [ grahamnorris ];
  };
})
