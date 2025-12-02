{
  stdenv,
  lib,
  fetchurl,
  meson,
  ninja,
  vala,
  pkg-config,
  gobject-introspection,
  gettext,
  gtk4,
  gnome,
  blueprint-compiler,
  wrapGAppsHook4,
  libadwaita,
  libgee,
  json-glib,
  qqwing,
  itstool,
  libxml2,
  desktop-file-utils,
}:

stdenv.mkDerivation rec {
  pname = "gnome-sudoku";
  version = "49.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-sudoku/${lib.versions.major version}/gnome-sudoku-${version}.tar.xz";
    hash = "sha256-ymcPrHPZ5cPngz/aNVZxC0Ig22Qz577FCnEFYNp9uEA=";
  };

  nativeBuildInputs = [
    meson
    ninja
    vala
    pkg-config
    gobject-introspection
    gettext
    itstool
    libxml2
    desktop-file-utils
    blueprint-compiler
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    libadwaita
    libgee
    json-glib
    qqwing
  ];

  passthru = {
    updateScript = gnome.updateScript { packageName = "gnome-sudoku"; };
  };

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/gnome-sudoku";
    changelog = "https://gitlab.gnome.org/GNOME/gnome-sudoku/-/blob/${version}/NEWS?ref_type=tags";
    description = "Test your logic skills in this number grid puzzle";
    mainProgram = "gnome-sudoku";
    teams = [ lib.teams.gnome ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
  };
}
