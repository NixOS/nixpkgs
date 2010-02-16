{ fetchurl, stdenv, gtk, pkgconfig, libofx, intltool }:

let
   download_root = "http://homebank.free.fr/public/";
   name = "homebank-4.2.1";
   lastrelease = download_root + name + ".tar.gz";
   oldrelease = download_root + "old/" + name + ".tar.gz";
in

stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    urls = [ lastrelease oldrelease ];
    sha256 = "13xz9k55mw14fnp8cf3ypnl6im5dyfbial75wr6i7ikxxpahd00g";
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
