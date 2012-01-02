{ fetchurl, stdenv, libjpeg, libpng, libtiff, perl }:

stdenv.mkDerivation rec {
  name = "libpano13-2.9.18";

  src = fetchurl {
    url = "mirror://sourceforge/panotools/${name}.tar.gz";
    sha256 = "0wm1r9waa47n482yrl3hnphicdahr581rahgbklk0d2wy51lwpfy";
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
