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
