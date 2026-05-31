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

stdenv.mkDerivation (finalAttrs: {
  pname = "cinnamon-menus";
  version = "6.6.0";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "cinnamon-menus";
    tag = finalAttrs.version;
    hash = "sha256-vjgWPFNmRkJWynimvBuxCxLK5C7tQxqJ5Y4dkZXSDSA=";
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

  meta = {
    homepage = "https://github.com/linuxmint/cinnamon-menus";
    description = "Menu system for the Cinnamon project";
    license = [
      lib.licenses.gpl2
      lib.licenses.lgpl2
    ];
    platforms = lib.platforms.linux;
    teams = [ lib.teams.cinnamon ];
  };
})
