{ lib, stdenv
, fetchurl
, atk
, cairo
, desktop-file-utils
, evolution-data-server
, evolution
, gcr
, gettext
, glib
, gnome
, gpgme
, gtk3
, gtksourceview3
, gtkspell3
, libcryptui
, libxml2
, meson
, ninja
, pkg-config
, python3
, sqlite
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "almanah";
  version = "0.12.3";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "lMpDQOxlGljP66APR49aPbTZnfrGakbQ2ZcFvmiPMFo=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    libxml2
    meson
    ninja
    pkg-config
    python3
    wrapGAppsHook
  ];

  buildInputs = [
    atk
    cairo
    evolution-data-server
    gcr
    glib
    evolution
    gpgme
    gtk3
    gtksourceview3
    gtkspell3
    libcryptui
    sqlite
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "none"; # it is quite odd
    };
  };

  meta = with lib; {
    description = "Small GTK application to allow to keep a diary of your life";
    homepage = "https://wiki.gnome.org/Apps/Almanah_Diary";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = teams.gnome.members;
  };
}
