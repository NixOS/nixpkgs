{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  pkg-config,
  ninja,
  glib,
  gtk3,
  cjs,
  gtksourceview4,
  gobject-introspection,
  libmusicbrainz,
  webkitgtk_4_1,
  clutter-gtk,
  clutter-gst,
  wrapGAppsHook3,
  nemo,
  xreader,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nemo-preview";
  version = "6.8.1";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "nemo-extensions";
    tag = finalAttrs.version;
    hash = "sha256-IDhgOwO4gCC/Wfi++qac7XDFW1qFdHvhOIWXraGojWg=";
  };

  sourceRoot = "${finalAttrs.src.name}/nemo-preview";

  nativeBuildInputs = [
    wrapGAppsHook3
    gobject-introspection
    meson
    pkg-config
    glib
    ninja
  ];

  buildInputs = [
    gtk3
    cjs
    gtksourceview4
    libmusicbrainz
    webkitgtk_4_1
    clutter-gtk
    clutter-gst
    nemo
    xreader
  ];

  meta = {
    homepage = "https://github.com/linuxmint/nemo-extensions/tree/master/nemo-preview";
    description = "Quick previewer for Nemo, the Cinnamon desktop file manager";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.cinnamon ];
  };
})
