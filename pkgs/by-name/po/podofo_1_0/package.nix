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
<<<<<<< HEAD
  version = "1.0.3";
=======
  version = "1.0.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "podofo";
    repo = "podofo";
    rev = finalAttrs.version;
<<<<<<< HEAD
    hash = "sha256-BJSQkcaE3oKq7ojJgfPyvOphw7pq+ilEIVIxaoIcdXw=";
=======
    hash = "sha256-mWomK+efiq2oLnYdLSWpqwtSd0WNVU1DsYmDHierQ64=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
