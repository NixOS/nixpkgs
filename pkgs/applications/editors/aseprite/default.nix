{ stdenv, fetchFromGitHub, cmake, pkgconfig
, curl, freetype, giflib, libjpeg, libpng, libwebp, pixman, tinyxml, zlib
, libX11, libXext, libXcursor, libXxf86vm
}:

stdenv.mkDerivation rec {
  name = "aseprite-${version}";
  version = "1.1.7";

  src = fetchFromGitHub {
    owner = "aseprite";
    repo = "aseprite";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "0gd49lns2bpzbkwax5jf9x1xmg1j8ij997kcxr2596cwiswnw4di";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [
    curl freetype giflib libjpeg libpng libwebp pixman tinyxml zlib
    libX11 libXext libXcursor libXxf86vm
  ];

  cmakeFlags = ''
    -DENABLE_UPDATER=OFF
    -DUSE_SHARED_CURL=ON
    -DUSE_SHARED_FREETYPE=ON
    -DUSE_SHARED_GIFLIB=ON
    -DUSE_SHARED_JPEGLIB=ON
    -DUSE_SHARED_LIBPNG=ON
    -DUSE_SHARED_LIBWEBP=ON
    -DUSE_SHARED_PIXMAN=ON
    -DUSE_SHARED_TINYXML=ON
    -DUSE_SHARED_ZLIB=ON
    -DWITH_DESKTOP_INTEGRATION=ON
    -DWITH_WEBP_SUPPORT=ON
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://www.aseprite.org/;
    description = "Animated sprite editor & pixel art tool";
    license = licenses.gpl2;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.linux;
  };
}
