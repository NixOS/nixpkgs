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
{stdenv, fetchurl, pkgconfig, glib, gtk, perl, libxml2, openssl, nss}:

stdenv.mkDerivation {
  name = "gaim-1.5.0";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://surfnet.dl.sourceforge.net/sourceforge/gaim/gaim-1.5.0.tar.gz;
    md5 = "dd984bd3116d8146545a492d314b0dae";
  };

  inherit nss;
  buildInputs = [pkgconfig glib gtk perl libxml2 openssl nss];
}
