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
  version = "48.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-sudoku/${lib.versions.major version}/gnome-sudoku-${version}.tar.xz";
    hash = "sha256-mMOSADDdDCQB+JDIcdY0X6PBA/cGnY5YPaukNVi7QLY=";
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

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/gnome-sudoku";
    changelog = "https://gitlab.gnome.org/GNOME/gnome-sudoku/-/blob/${version}/NEWS?ref_type=tags";
    description = "Test your logic skills in this number grid puzzle";
    mainProgram = "gnome-sudoku";
    teams = [ teams.gnome ];
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
