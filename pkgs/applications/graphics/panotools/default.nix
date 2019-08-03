{ fetchurl, stdenv, libjpeg, libpng, libtiff, perl }:

stdenv.mkDerivation rec {
  name = "libpano13-2.9.19";

  src = fetchurl {
    url = "mirror://sourceforge/panotools/${name}.tar.gz";
    sha256 = "1a4m3plmfcrrplqs9zfzhc5apibn10m5sajpizm1sd3q74w5fwq3";
  };

  buildInputs = [ perl libjpeg libpng libtiff ];

  # one of the tests succeeds on my machine but fails on Hydra (no idea why)
  #doCheck = true;

  meta = {
    homepage = http://panotools.sourceforge.net/;
    description = "Free software suite for authoring and displaying virtual reality panoramas";
    license = stdenv.lib.licenses.gpl2Plus;

    platforms = stdenv.lib.platforms.gnu ++ stdenv.lib.platforms.linux;  # arbitrary choice
  };
}
