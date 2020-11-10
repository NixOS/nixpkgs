{ stdenv
, fetchurl
, atk
, cairo
, desktop-file-utils
, evolution-data-server
, gcr
, gettext
, glib
, gnome3
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
  version = "0.12.2";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "IWYOnOu0C9uQ9k1dgWkJ6Kv+o/jY+6Llfsi4PusHE24=";
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
    gnome3.evolution
    gpgme
    gtk3
    gtksourceview3
    gtkspell3
    libcryptui
    sqlite
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      versionPolicy = "none"; # it is quite odd
    };
  };

  meta = with stdenv.lib; {
    description = "Small GTK application to allow to keep a diary of your life";
    homepage = "https://wiki.gnome.org/Apps/Almanah_Diary";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = teams.gnome.members;
  };
}
