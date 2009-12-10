{ stdenv, fetchurl, libjpeg, mesa, freeglut, zlib, cmake, libX11, libxml2, libpng,
  libXxf86vm }:

stdenv.mkDerivation {
  name = "freepv-0.3.0_beta1";

  src = fetchurl {
    url = mirror://sourceforge/freepv/freepv-0.3.0_beta1.tar.gz;
    sha256 = "084qqa361np73anvqrv78ngw8hjxglmdm3akkpszbwnzniw89qla";
  };

  buildInputs = [ libjpeg mesa freeglut zlib cmake libX11 libxml2 libpng
    libXxf86vm ];

  patchPhase = ''
    sed -i -e '/GECKO/d' CMakeLists.txt
    sed -i -e '/mozilla/d' src/CMakeLists.txt
  '';

  meta = {
    description = "Open source panorama viewer using GL";
    homepage = http://freepv.sourceforge.net/;
    license = "LGPL";
  };
}
