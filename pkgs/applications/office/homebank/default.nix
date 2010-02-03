{ fetchurl, stdenv, gtk, pkgconfig, libofx, intltool }:

let
   download_root = "http://homebank.free.fr/public/";
   name = "homebank-4.1";
   lastrelease = download_root + name + ".tar.gz";
   oldrelease = download_root + "old/" + name + ".tar.gz";
in

stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    urls = [ lastrelease oldrelease ];
    sha256 = "0nv69rmcvywgks58w20qgbw8v0ir57gys4zd2gcys6knj6q323b8";
  };

  buildInputs = [ pkgconfig gtk libofx intltool ];

  meta = {
    description = "Free, easy, personal accounting for everyone";
    homepage = http://homebank.free.fr/;
    license = "GPLv2+";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
