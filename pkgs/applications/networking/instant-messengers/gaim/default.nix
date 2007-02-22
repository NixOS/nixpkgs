/**
 * Possible missing configuration:
 *
 * - silcclient
 * - libstartup-notification
 * - libebook-1.2
 * - libedata-book-1.2
 * - checking for XScreenSaverRegister in -lXext... no
 * - checking for XScreenSaverRegister in -lXss... no
 * - gtkspell
 * - ao
 * - audiofile-config
 * - doxygen
 */
{stdenv, fetchurl, pkgconfig, glib, gtk, perl, perlXMLParser, libxml2, openssl, nss}:

stdenv.mkDerivation {
  name = "gaim-2.0.0pre6";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://surfnet.dl.sourceforge.net/sourceforge/gaim/gaim-2.0.0beta6.tar.gz;
    md5 = "0c7520d4ce083704d196c04c63dcd16a";
  };

  inherit nss;
  buildInputs = [pkgconfig glib gtk perl perlXMLParser libxml2 openssl nss];
}
