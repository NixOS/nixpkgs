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
  python3Minimal,
  unstableGitUpdater,
}:
stdenv.mkDerivation {
  pname = "jpegli";
  version = "0-unstable-2026-03-20";

  src = fetchFromGitHub {
    owner = "google";
    repo = "jpegli";
    rev = "a069db9215c9aab9f3a685d012b55f1c3a85c164";
    hash = "sha256-YTp69ycZLdZPMZlCsqbmBcao+SX4RW+mY5lOvbogPHA=";
    fetchSubmodules = true;
  };

  outputs = [
    "out"
    "man"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    asciidoc
    cmake
    ninja
    pkg-config
    python3Minimal
  ];

  buildInputs = [
    brotli
    giflib
    gtest
    lcms2
    libhwy
    libjpeg
    libpng
    openexr
  ];

  cmakeFlags = [
    (lib.cmakeBool "JPEGXL_ENABLE_JPEGLI_LIBJPEG" false)
    (lib.cmakeBool "JPEGXL_BUNDLE_LIBPNG" false)
    (lib.cmakeBool "JPEGXL_FORCE_SYSTEM_BROTLI" true)
    (lib.cmakeBool "JPEGXL_FORCE_SYSTEM_GTEST" true)
    (lib.cmakeBool "JPEGXL_FORCE_SYSTEM_LCMS2" true)
    (lib.cmakeBool "JPEGXL_FORCE_SYSTEM_HWY" true)
    # Enable hardware-dependent optimizations
    (lib.cmakeBool "JPEGXL_ENABLE_SIZELESS_VECTORS" true)
    (lib.cmakeBool "JPEGXL_ENABLE_AVX512" true)
    (lib.cmakeBool "JPEGXL_ENABLE_AVX512_SPR" true)
    (lib.cmakeBool "JPEGXL_ENABLE_AVX512_ZEN4" true)
    (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.5")
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
    maintainers = with lib.maintainers; [
      jwillikers
      leiserfg
    ];
    mainProgram = "cjpegli";
  };
}
