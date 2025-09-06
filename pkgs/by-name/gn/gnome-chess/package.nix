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

stdenv.mkDerivation rec {
  pname = "gnome-chess";
  version = "49.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-chess/${lib.versions.major version}/gnome-chess-${version}.tar.xz";
    hash = "sha256-QDST8Bbpkn1/nFR3O7ydCpNB8+751DF7Re3AqwoiyI8=";
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

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/gnome-chess";
    description = "Play the classic two-player boardgame of chess";
    mainProgram = "gnome-chess";
    teams = [ teams.gnome ];
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
