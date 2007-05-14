/**
 * Possible missing configuration:
 *
 * - silcclient
 * - libebook-1.2
 * - libedata-book-1.2
 * - checking for XScreenSaverRegister in -lXext... no
 * - checking for XScreenSaverRegister in -lXss... no
 * - ao
 * - audiofile-config
 * - doxygen
 */
{ stdenv, fetchurl, pkgconfig, gtk, gtkspell, aspell,
  GStreamer, startupnotification, gettext,
  perl, perlXMLParser, libxml2, openssl, nss,
  libXScrnSaver
} :

stdenv.mkDerivation {
  name = "pidgin-2.0.0";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://kent.dl.sourceforge.net/sourceforge/pidgin/pidgin-2.0.0.tar.bz2;
    md5 = "132355d7e236d9c2820a2668621eef43";
  };

  inherit nss;
  buildInputs = [
    pkgconfig gtk gtkspell aspell
    GStreamer startupnotification gettext
    perl perlXMLParser libxml2 openssl nss
    libXScrnSaver
  ];
}
