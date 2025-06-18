{
  stdenv,
  lib,
  fetchurl,
  atk,
  cairo,
  desktop-file-utils,
  evolution-data-server-gtk4,
  evolution,
  gcr_4,
  gettext,
  glib,
  gnome,
  gpgme,
  gtk3,
  gtksourceview4,
  gtkspell3,
  libcryptui,
  libxml2,
  meson,
  ninja,
  pkg-config,
  python3,
  sqlite,
  wrapGAppsHook3,
}:

stdenv.mkDerivation rec {
  pname = "almanah";
  version = "0.12.4";

  src = fetchurl {
    url = "mirror://gnome/sources/almanah/${lib.versions.majorMinor version}/almanah-${version}.tar.xz";
    sha256 = "DywW6Gkohf0lrX3Mw/UawrS4h2JOaOfqH2SulHkxlFI=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    libxml2
    meson
    ninja
    pkg-config
    python3
    wrapGAppsHook3
  ];

  buildInputs = [
    atk
    cairo
    evolution-data-server-gtk4
    gcr_4
    glib
    evolution
    gpgme
    gtk3
    gtksourceview4
    gtkspell3
    libcryptui
    sqlite
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "almanah";
      versionPolicy = "none"; # it is quite odd
    };
  };

  meta = with lib; {
    description = "Small GTK application to allow to keep a diary of your life";
    mainProgram = "almanah";
    homepage = "https://gitlab.gnome.org/GNOME/almanah";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    teams = [ teams.gnome ];
  };
}
