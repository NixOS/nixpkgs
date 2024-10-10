{
  lib,
  stdenv,
  fetchFromGitHub,
  callPackage,
  cmake,
  pkg-config,
  bzip2,
  curl,
  ghc_filesystem,
  libcpr,
  lzma,
  spdlog,
  zlib,
  libarchive,
  fp16-luxonis,
  libnop,
  nlohmann_json,
  xlink-luxonis,
  opencv,
  pcl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "depthai-core";
  version = "2.28.0";

  src = fetchFromGitHub {
    owner = "luxonis";
    repo = "depthai-core";
    rev = "refs/tags/v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-aJ68oOlwU+7LwXdANOdZ/rczVZVggGAUNj5vzhtro1Q=";
  };

  # Adapted from https://github.com/tmayoff/nix-depthai-core/tree/03a1f7fc92375b0653c8ad7707d97081c8ca7792/patches/ and https://github.com/luxonis/depthai-core/issues/447#issuecomment-1164015416
  patches = [
    ./deps.patch
    ./0001-maincmake.patch
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    bzip2
    ghc_filesystem
    curl
    libcpr
    lzma
    libnop
    nlohmann_json
    spdlog
    zlib
    libarchive
    fp16-luxonis
    xlink-luxonis
    opencv
    pcl
  ];

  cmakeFlags = [
    (lib.cmakeBool "HUNTER_ENABLED" false)
    (lib.cmakeBool "DEPTHAI_ENABLE_BACKWARD" false)
    (lib.cmakeFeature "DEPTHAI_BOOTLOADER_FWP" (builtins.toString (callPackage ./bootloader.nix {})))
    (lib.cmakeFeature "DEPTHAI_DEVICE_FWP" (builtins.toString (callPackage ./firmware.nix {})))
  ];

  meta = {
    description = "DepthAI Core library";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ pandapip1 tmayoff ];
  };
})
