{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lz4";
  version = "1.11.1";

  src = fetchFromGitHub {
    repo = "lz4";
    owner = "lz4";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZuizCK3zcF4BEn5g9s0XhHOUvzgEFA4h66BM+bfUDSA=";
  };

  nativeBuildInputs = [
    cmake
  ];

  strictDeps = true;

  outputs = [
    "dev"
    "lib"
    "man"
    "out"
  ];

  cmakeDir = "../build/cmake";
  cmakeBuildDir = "build-dist";

  # Tests take a very long time, and use Make, which rebuilds
  # the code which we build with CMake instead of re-using it.
  doCheck = false;

  passthru.tests = {
    version = testers.testVersion {
      package = finalAttrs.finalPackage;
      version = "v${finalAttrs.version}";
    };
    pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
      moduleNames = [ "liblz4" ];
    };
  };

  __structuredAttrs = true;

  meta = {
    description = "Extremely fast compression algorithm";
    longDescription = ''
      Very fast lossless compression algorithm, providing compression speed
      at 400 MB/s per core, with near-linear scalability for multi-threaded
      applications. It also features an extremely fast decoder, with speed in
      multiple GB/s per core, typically reaching RAM speed limits on
      multi-core systems.
    '';
    homepage = "https://lz4.github.io/lz4/";
    license = with lib.licenses; [
      bsd2
      gpl2Plus
    ];
    platforms = lib.platforms.all;
    mainProgram = "lz4";
    maintainers = [ lib.maintainers.tobim ];
    identifiers.cpeParts = lib.meta.cpeFullVersionWithVendor "lz4_project" finalAttrs.version;
  };
})
