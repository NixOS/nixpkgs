{
  lib,
  stdenv,
  fetchFromGitHub,
  qt6,
  gtk3,
  gsettings-desktop-schemas,
  adwaita-icon-theme,
  hicolor-icon-theme,
  openssl,
  imagemagick,
  copyDesktopItems,
  makeDesktopItem,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "porymap";
  version = "6.3.1";

  src = fetchFromGitHub {
    owner = "huderlem";
    repo = "porymap";
    rev = finalAttrs.version;
    hash = "sha256-EG09aOgJrIe5X+e/SKcZn+mxkZ2N4mBmRxlEV3LYvgo=";
  };

  nativeBuildInputs = [
    qt6.qmake
    qt6.wrapQtAppsHook
    wrapGAppsHook3
    imagemagick
    copyDesktopItems
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtcharts
    qt6.qtdeclarative
    qt6.qtwayland
    gtk3
    gsettings-desktop-schemas
    adwaita-icon-theme
    hicolor-icon-theme
    openssl
  ];

  strictDeps = true;
  __structuredAttrs = true;

  desktopItems = [
    (makeDesktopItem {
      name = "porymap";
      exec = "porymap";
      icon = "porymap";
      desktopName = "Porymap";
      genericName = "Pokémon Map Editor";
      categories = [ "Development" ];
    })
  ];

  # This app doesn't have an install target in its qmake file
  installPhase = ''
    runHook preInstall
    install -Dm755 porymap $out/bin/porymap
    runHook postInstall
  '';

  postInstall = ''
    magick resources/icons/porymap-icon-2.ico porymap.png
    icon_file=$(ls porymap-*.png | sort -V | tail -n 1)
    install -Dm644 "''${icon_file:-porymap.png}" $out/share/icons/hicolor/256x256/apps/porymap.png
  '';

  meta = {
    description = "A map editor for the Pokémon generation 3 decompilation projects";
    homepage = "https://github.com/huderlem/porymap";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ beauremus ];
    platforms = lib.platforms.linux;
    mainProgram = "porymap";
  };
})
