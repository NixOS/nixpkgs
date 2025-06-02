{
  stdenv,
  lib,
  asciidoc,
  brotli,
  cmake,
  fetchFromGitHub,
  giflib,
  gtest,
  lcms2,
  libjpeg,
  libhwy,
  libpng,
  ninja,
  openexr,
  pkg-config,
  python3,
  unstableGitUpdater,
}:
stdenv.mkDerivation {
  pname = "jpegli";
  version = "0-unstable-2025-02-11";

  src = fetchFromGitHub {
    owner = "google";
    repo = "jpegli";
    rev = "bc19ca2393f79bfe0a4a9518f77e4ad33ce1ab7a";
    hash = "sha256-8th+QHLOoAIbSJwFyaBxUXoCXwj7K7rgg/cCK7LgOb0=";
    fetchSubmodules = true;
  };

  outputs = [
    "out"
    "man"
  ];

  nativeBuildInputs = [
    asciidoc
    cmake
    gtest
    ninja
    pkg-config
    python3
  ];

  buildInputs = [
    brotli
    giflib
    lcms2
    libhwy
    libjpeg
    libpng
    openexr
  ];

  cmakeFlags = [
    "-DJPEGXL_ENABLE_JPEGLI_LIBJPEG=No"
    "-DJPEGXL_BUNDLE_LIBPNG=No"
    "-DJPEGXL_FORCE_SYSTEM_BROTLI=Yes"
    "-DJPEGXL_FORCE_SYSTEM_GTEST=Yes"
    "-DJPEGXL_FORCE_SYSTEM_LCMS2=Yes"
    "-DJPEGXL_FORCE_SYSTEM_HWY=Yes"
    # Enable hardware-dependent optimizations
    "-DJPEGXL_ENABLE_SIZELESS_VECTORS=Yes"
    "-DJPEGXL_ENABLE_AVX512=Yes"
    "-DJPEGXL_ENABLE_AVX512_SPR=Yes"
    "-DJPEGXL_ENABLE_AVX512_ZEN4=Yes"
  ];

  doCheck = true;

  passthru = {
    updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };
  };

  meta = {
    description = "Improved JPEG encoder and decoder implementation";
    homepage = "https://github.com/google/jpegli";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ jwillikers ];
    mainProgram = "cjpegli";
  };
}
