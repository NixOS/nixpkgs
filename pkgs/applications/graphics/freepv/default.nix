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

  # I added these flags to get all the rpaths right, which I guess they are
  # taken from the qt4 sources. Not very nice.
  cmakeFlags = " -DCMAKE_EXE_LINKER_FLAGS=\"" +
    " -lpng12 -lXxf86vm -ljpeg -lz -lglut -lGLU -lxml2 -lX11\"" +
    " -DCMAKE_SKIP_BUILD_RPATH=ON" +
    " -DCMAKE_BUILD_TYPE=Release" +
    " -DCMAKE_INSTALL_PREFIX=$out";

  dontUseCmakeConfigure = true;

  # I rewrote the configure phase to get the $out references evaluated in
  # cmakeFlags
  configurePhase = ''
    set -x
    mkdir -p build;
    cd build
    eval -- "cmake .. $cmakeFlags"
    set +x
    '';

  meta = {
    description = "Open source panorama viewer using GL";
    homepage = http://freepv.sourceforge.net/;
    license = "LGPL";
  };
}
