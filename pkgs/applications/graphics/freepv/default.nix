{ stdenv, fetchurl, libjpeg, libGLU_combined, freeglut, zlib, cmake, libX11, libxml2, libpng,
  libXxf86vm }:

stdenv.mkDerivation {
  name = "freepv-0.3.0";

  src = fetchurl {
    url = mirror://sourceforge/freepv/freepv-0.3.0.tar.gz;
    sha256 = "1w19abqjn64w47m35alg7bcdl1p97nf11zn64cp4p0dydihmhv56";
  };

  buildInputs = [ libjpeg libGLU_combined freeglut zlib cmake libX11 libxml2 libpng
    libXxf86vm ];

  postPatch = ''
    sed -i -e '/GECKO/d' CMakeLists.txt
    sed -i -e '/mozilla/d' src/CMakeLists.txt
    sed -i -e '1i \
      #include <cstdio>' src/libfreepv/OpenGLRenderer.cpp
    sed -i -e '1i \
      #include <cstring>' src/libfreepv/Image.cpp
    substituteInPlace src/libfreepv/Action.h \
      --replace NULL nullptr
    substituteInPlace src/libfreepv/pngReader.cpp \
      --replace png_set_gray_1_2_4_to_8 png_set_expand_gray_1_2_4_to_8
  '';

  NIX_CFLAGS_COMPILE = "-fpermissive -Wno-narrowing";

  meta = {
    description = "Open source panorama viewer using GL";
    homepage = http://freepv.sourceforge.net/;
    license = [ stdenv.lib.licenses.lgpl21 ];
  };
}
