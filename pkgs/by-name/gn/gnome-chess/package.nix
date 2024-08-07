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
  version = "47.beta";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-chess/${lib.versions.major version}/gnome-chess-${version}.tar.xz";
    hash = "sha256-JIUP7lWMGLYm/iFYfgKTlfvYu3+pzpktMQ5kSJI1r6Y=";
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
    maintainers = teams.gnome.members;
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
