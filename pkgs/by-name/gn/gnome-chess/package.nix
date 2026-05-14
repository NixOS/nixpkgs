{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  vala,
  pkg-config,
  desktop-file-utils,
  wrapGAppsHook4,
  gobject-introspection,
  gettext,
  itstool,
  libxml2,
  gnome,
  glib,
  gtk4,
  libadwaita,
  librsvg,
  pango,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-chess";
  version = "49.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-chess/${lib.versions.major finalAttrs.version}/gnome-chess-${finalAttrs.version}.tar.xz";
    hash = "sha256-xAoABKRz/nSawvpPrZjbZBGNGPn9msAu7Po2TwPb6bA=";
  };

  nativeBuildInputs = [
    meson
    ninja
    vala
    pkg-config
    gettext
    itstool
    libxml2
    desktop-file-utils
    wrapGAppsHook4
    gobject-introspection
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    librsvg
    pango
  ];

  passthru = {
    updateScript = gnome.updateScript { packageName = "gnome-chess"; };
  };

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/gnome-chess";
    description = "Play the classic two-player boardgame of chess";
    mainProgram = "gnome-chess";
    teams = [ lib.teams.gnome ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
  };
})
