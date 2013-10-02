{ stdenv, fetchurl, cmake, pkgconfig
, giflib, libjpeg, zlib, libpng, tinyxml, allegro
, libX11, libXext, libXcursor, libXpm, libXxf86vm, libXxf86dga
}:

stdenv.mkDerivation rec {
  name = "aseprite-0.9.5";

  src = fetchurl {
    url = "http://aseprite.googlecode.com/files/${name}.tar.xz";
    sha256 = "0m7i6ybj2bym4w9rybacnnaaq2jjn76vlpbp932xcclakl6kdq41";
  };

  buildInputs = [
    cmake pkgconfig
    giflib libjpeg zlib libpng tinyxml allegro
    libX11 libXext libXcursor libXpm libXxf86vm libXxf86dga
  ];

  patchPhase = ''
    sed -i '/^find_unittests/d' src/CMakeLists.txt
    sed -i '/include_directories(.*third_party\/gtest.*)/d' src/CMakeLists.txt
    sed -i '/add_subdirectory(gtest)/d' third_party/CMakeLists.txt
    sed -i 's/png_\(sizeof\)/\1/g' src/file/png_format.cpp
  '';

  cmakeFlags = ''
    -DUSE_SHARED_GIFLIB=ON
    -DUSE_SHARED_JPEGLIB=ON
    -DUSE_SHARED_ZLIB=ON
    -DUSE_SHARED_LIBPNG=ON
    -DUSE_SHARED_LIBLOADPNG=ON
    -DUSE_SHARED_TINYXML=ON
    -DUSE_SHARED_GTEST=ON
    -DUSE_SHARED_ALLEGRO4=ON
    -DENABLE_UPDATER=OFF
  '';

  NIX_LDFLAGS = "-lX11";

  meta = {
    description = "Animated sprite editor & pixel art tool";
    homepage = "http://www.aseprite.org/";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [iyzsong];
  };
}
