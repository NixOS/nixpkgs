{ fetchurl, stdenv, libjpeg, libpng, libtiff, perl }:

stdenv.mkDerivation rec {
  name = "libpano13-2.9.17";

  src = fetchurl {
    url = "mirror://sourceforge/panotools/libpano13/${name}/${name}.tar.gz";
    sha256 = "1zcrkw0xw11170mlhh9r8562gafwx3hd92wahl9xxaah5z4v0am2";
  };

  buildInputs = [ perl libjpeg libpng libtiff ];

  doCheck = true;

  meta = {
    homepage = http://panotools.sourceforge.net/;
    description = "Free software suite for authoring and displaying virtual reality panoramas";
    license = "GPLv2+";

    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
  };
}
