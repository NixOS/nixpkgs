{
  stdenv,
  lib,
  itstool,
  fetchurl,
  gdk-pixbuf,
  telepathy-glib,
  gjs,
  meson,
  ninja,
  gettext,
  telepathy-idle,
  libxml2,
  desktop-file-utils,
  pkg-config,
  gtk4,
  tinysparql,
  libadwaita,
  gtk3,
  glib,
  libsecret,
  libsoup_3,
  webkitgtk_4_1,
  gobject-introspection,
  gnome,
  wrapGAppsHook4,
  gspell,
  gsettings-desktop-schemas,
}:

stdenv.mkDerivation rec {
  pname = "polari";
  version = "46.0";

  src = fetchurl {
    url = "mirror://gnome/sources/polari/${lib.versions.major version}/polari-${version}.tar.xz";
    hash = "sha256-0rFwnjeRiSlPU9TvFfA/i8u76MUvD0FeYvfV8Aw2CjE=";
  };

  patches = [
    # Upstream runs the thumbnailer by passing it to gjs.
    # If we wrap it in a shell script, gjs can no longer run it.
    # Let’s change the code to run the script directly by making it executable and having gjs in shebang.
    ./make-thumbnailer-wrappable.patch
  ];

  propagatedUserEnvPkgs = [ telepathy-idle ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    itstool
    gettext
    wrapGAppsHook4
    libxml2
    desktop-file-utils
    gobject-introspection
  ];

  buildInputs = [
    gtk4
    tinysparql
    libadwaita
    gtk3 # for thumbnailer
    glib
    gsettings-desktop-schemas
    telepathy-glib
    gjs
    gspell
    gdk-pixbuf
    libsecret
    libsoup_3
    webkitgtk_4_1 # for thumbnailer
  ];

  postFixup = ''
    wrapGApp "$out/share/polari/thumbnailer.js"
  '';

  passthru = {
    updateScript = gnome.updateScript { packageName = "polari"; };
  };

  meta = with lib; {
    homepage = "https://apps.gnome.org/Polari/";
    description = "IRC chat client designed to integrate with the GNOME desktop";
    mainProgram = "polari";
    teams = [
      teams.gnome
      teams.gnome-circle
    ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
