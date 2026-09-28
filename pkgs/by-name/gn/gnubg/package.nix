{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  flex,
  glib,
  python3,
  gtk3,
  readline,
  copyDesktopItems,
  makeDesktopItem,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnubg";
  version = "1.08.003";

  src = fetchurl {
    url = "mirror://gnu/gnubg/gnubg-release-${finalAttrs.version}-sources.tar.gz";
    hash = "sha256-b32WmxPP/3hvupD/jMXl1WS5f08Kppr+Tzg48YxEWXk=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    pkg-config
    python3
    flex
    glib
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    readline
  ];

  strictDeps = true;

  configureFlags = [
    "--with-gtk3"
    "--with--board3d"
  ];

  desktopItems = [
    (makeDesktopItem {
      desktopName = "GNU Backgammon";
      name = "gnubg";
      genericName = "Backgammon";
      comment = "World class backgammon application";
      exec = "gnubg";
      icon = "gnubg";
      categories = [
        "Game"
        "GTK"
        "StrategyGame"
      ];
    })
  ];

  meta = {
    description = "World class backgammon application";
    homepage = "https://www.gnu.org/software/gnubg/";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
  };
})
