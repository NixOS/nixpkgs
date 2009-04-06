{stdenv, fetchurl, panotools, cmake, wxGTK, libtiff, libpng, openexr, boost, pkgconfig, exiv2, gettext, ilmbase }:

stdenv.mkDerivation {
  name = "hugin-0.7.0";

  src = fetchurl {
    url = mirror://sourceforge/hugin/hugin-0.7.0.tar.gz;
    sha256 = "0nbrvzz94gqgk2v1900lly101g0wjz4zksnh5718226n2g8zlccf";
  };

  NIX_CFLAGS_COMPILE = "-I${ilmbase}/include/OpenEXR";

  NIX_LDFLAGS = "-lrt";

  # I added these flags to get all the rpaths right, which I guess they are
  # taken from the qt4 sources. Not very nice.
  cmakeFlags = "-DCMAKE_SHARED_LINKER_FLAGS=\"-Wl,-rpath,$out/lib\"" +
    " -DCMAKE_EXE_LINKER_FLAGS=\"-Wl,-rpath,$out/lib\"" +
    " -DCMAKE_SKIP_BUILD_RPATH=ON" +
    " -DCMAKE_BUILD_TYPE=Release" +
    " -DCMAKE_INSTALL_PREFIX=$out";

  buildInputs = [ cmake panotools wxGTK libtiff libpng openexr boost pkgconfig exiv2 gettext ];

  meta = {
    homepage = http://hugin.sourceforge.net/;
    description = "Panoramic imaging toolchain";
    license = "GPLv2+";
  };
}
