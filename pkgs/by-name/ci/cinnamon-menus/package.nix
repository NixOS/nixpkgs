{
  fetchFromGitHub,
  glib,
  gobject-introspection,
  meson,
  ninja,
  pkg-config,
  lib,
  stdenv,
  wrapGAppsHook3,
}:

stdenv.mkDerivation rec {
  pname = "cinnamon-menus";
  version = "6.4.0";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "cinnamon-menus";
    rev = version;
    hash = "sha256-ug1RSP2TBrypi0aGhF05k39koY3rGgJi0LuWyuuICd0=";
  };

  buildInputs = [
    glib
  ];

  nativeBuildInputs = [
    meson
    ninja
    wrapGAppsHook3
    pkg-config
    gobject-introspection
  ];

  meta = with lib; {
    homepage = "https://github.com/linuxmint/cinnamon-menus";
    description = "Menu system for the Cinnamon project";
    license = [
      licenses.gpl2
      licenses.lgpl2
    ];
    platforms = platforms.linux;
    teams = [ teams.cinnamon ];
  };
}
