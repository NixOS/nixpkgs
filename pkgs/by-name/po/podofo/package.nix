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
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "podofo";
    repo = "podofo";
    rev = finalAttrs.version;
    hash = "sha256-gzkIMyGV3nmOrGX2PDLrA9NHbtAwk74vcyrQ+yc5TOw=";
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
    (lib.cmakeBool "PODOFO_BUILD_STATIC" stdenv.hostPlatform.isStatic)
    (lib.cmakeBool "CMAKE_BUILD_WITH_INSTALL_NAME_DIR" true)
  ];

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    homepage = "https://github.com/podofo/podofo";
    description = "Library to work with the PDF file format";
    changelog = "https://github.com/podofo/podofo/blob/${finalAttrs.version}/CHANGELOG.md";
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
