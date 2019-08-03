{ stdenv, fetchurl, pkgconfig, intltool
, libxml2, desktop-file-utils, wrapGAppsHook, evolution-data-server, gtkspell3, gpgme, libcryptui
, glib, gtk3, gtksourceview3, sqlite, cairo, atk, gcr, gnome3 }:

stdenv.mkDerivation rec {
  pname = "almanah";
  version = "0.11.1";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1g0fyykq8bs3x1xqc0l0bk9zazcrxja784m68myymv1zfqqnp9h0";
  };

  nativeBuildInputs = [ pkgconfig intltool libxml2 desktop-file-utils wrapGAppsHook ];

  buildInputs = [ glib gtk3 gtksourceview3 sqlite cairo atk gcr gtkspell3 evolution-data-server gnome3.evolution gpgme libcryptui ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      versionPolicy = "none"; # it is quite odd
    };
  };

  meta = with stdenv.lib; {
    description = "Small GTK application to allow to keep a diary of your life";
    homepage = https://wiki.gnome.org/Apps/Almanah_Diary;
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = gnome3.maintainers;
  };
}
