{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  fontconfig,
  freetype,
  libjpeg,
  libpng,
  libtiff,
  libxml2,
  openssl,
  pkg-config,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "podofo";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "podofo";
    repo = "podofo";
    rev = finalAttrs.version;
    hash = "sha256-AiuWSIVTeq6O13yDC4mRIK5LNOKSfMG8AGE9wdMA9PE=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    fontconfig
    freetype
    libjpeg
    libpng
    libtiff
    libxml2
    openssl
    zlib
  ];

  cmakeFlags = [
    "-DPODOFO_BUILD_STATIC=${if stdenv.hostPlatform.isStatic then "ON" else "OFF"}"
    "-DCMAKE_BUILD_WITH_INSTALL_NAME_DIR=ON"
  ];

  meta = {
    homepage = "https://github.com/podofo/podofo";
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
})
