{ fetchurl, stdenv, gtk, pkgconfig, libofx, intltool }:

let
   download_root = "http://homebank.free.fr/public/";
   name = "homebank-4.6.3";
   lastrelease = download_root + name + ".tar.gz";
   oldrelease = download_root + "old/" + name + ".tar.gz";
in

stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    urls = [ lastrelease oldrelease ];
    sha256 = "0j39788xz9m7ic277phffznbl35c1dm1g7dgq83va9nni6vipqzn";
  };

  buildInputs = [ pkgconfig gtk libofx intltool ];

  meta = {
    description = "Free, easy, personal accounting for everyone";
    homepage = http://homebank.free.fr/;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
