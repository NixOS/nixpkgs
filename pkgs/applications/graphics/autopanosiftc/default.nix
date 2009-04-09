{stdenv, fetchurl, cmake, libpng, libtiff, libjpeg, panotools, libxml2 }:

stdenv.mkDerivation {
  name = "autopano-sift-C-2.5.0";

  src = fetchurl {
    url = mirror://sourceforge/hugin/autopano-sift-C-2.5.0.tar.gz;
    sha256 = "0pvkapjg7qdkjg151wjc7islly9ag8fg6bj0g5nbllv981ixjql3";
  };

  buildInputs = [ cmake libpng libtiff libjpeg panotools libxml2 ];

  # I added these flags to get all the rpaths right, which I guess they are
  # taken from the qt4 sources. Not very nice.
  cmakeFlags = "-DCMAKE_SHARED_LINKER_FLAGS=\"-Wl,-rpath,$out/lib\"" +
    " -DCMAKE_EXE_LINKER_FLAGS=\"-Wl,-rpath,$out/lib" +
    " -lpng12 -lpano13 -ljpeg -ltiff -lz -lxml2 \"" +
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
    homepage = http://hugin.sourceforge.net/;
    description = "Implementation in C of the autopano-sift algorithm for automatically stitching panoramas";
    license = "GPLv2";
  };
}
