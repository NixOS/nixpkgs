{ fetchurl, stdenv, libjpeg, libpng, libtiff, perl }:

stdenv.mkDerivation rec {
  pname = "libpano13";
  version = "2.9.20";

  src = fetchurl {
    url = "mirror://sourceforge/panotools/${pname}-${version}.tar.gz";
    sha256 = "12cv4886l1czfjwy7k6ipgf3zjksgwhdjzr2s9fdg33vqcv2hlrv";
  };

  buildInputs = [ perl libjpeg libpng libtiff ];

  # one of the tests succeeds on my machine but fails on Hydra (no idea why)
  #doCheck = true;

  meta = {
    homepage = "http://panotools.sourceforge.net/";
    description = "Free software suite for authoring and displaying virtual reality panoramas";
    license = stdenv.lib.licenses.gpl2Plus;

    platforms = stdenv.lib.platforms.gnu ++ stdenv.lib.platforms.linux;  # arbitrary choice
  };
}
