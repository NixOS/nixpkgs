{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  zlib,
  freetype,
  libjpeg,
  libtiff,
  fontconfig,
  openssl,
  libpng,
  lua5,
  pkg-config,
  libidn,
}:

stdenv.mkDerivation rec {
  version = "0.9.8";
  pname = "podofo";

  src = fetchFromGitHub {
    owner = "podofo";
    repo = "podofo";
    rev = version;
    hash = "sha256-VGsACeCC8xKC1n/ackT576ZU3ZR1LAw8H0l/Q9cH27s=";
  };

  outputs = [
    "out"
    "dev"
    "lib"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    zlib
    freetype
    libjpeg
    libtiff
    fontconfig
    openssl
    libpng
    libidn
    lua5
  ];

  cmakeFlags = [
    "-DPODOFO_BUILD_SHARED=ON"
    "-DPODOFO_BUILD_STATIC=OFF"
    "-DCMAKE_BUILD_WITH_INSTALL_NAME_DIR=ON"
  ];

  postPatch = ''
    # Use GNU directories to fix multiple outputs
    failNoMatches='t yes; b no; :yes h; :no p; $ {x; /./{x;q}; q1}'
    sed -ni src/podofo/CMakeLists.txt \
        -e 's/LIBDIRNAME/CMAKE_INSTALL_LIBDIR/' -e "$failNoMatches"
    sed -ni src/podofo/libpodofo.pc.in \
        -e 's/^libdir=.*/libdir=@CMAKE_INSTALL_LIBDIR@/' -e "$failNoMatches"
  '';

  meta = {
    homepage = "https://podofo.sourceforge.net";
    description = "Library to work with the PDF file format";
    platforms = lib.platforms.all;
    license = with lib.licenses; [
      gpl2Plus
      lgpl2Plus
    ];
    maintainers = with lib.maintainers; [
      kuflierl
    ];
  };
}
