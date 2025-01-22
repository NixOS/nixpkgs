{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  valgrind,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lz4";
  version = "1.10.0";

  src = fetchFromGitHub {
    repo = "lz4";
    owner = "lz4";
    rev = "v${finalAttrs.version}";
    hash = "sha256-/dG1n59SKBaEBg72pAWltAtVmJ2cXxlFFhP+klrkTos=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = lib.optionals finalAttrs.finalPackage.doCheck [
    valgrind
  ];

  outputs = [
    "dev"
    "lib"
    "man"
    "out"
  ];

  cmakeDir = "../build/cmake";
  cmakeBuildDir = "build-dist";

  doCheck = false; # tests take a very long time
  checkTarget = "test";

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

  meta = with lib; {
    description = "Extremely fast compression algorithm";
    longDescription = ''
      Very fast lossless compression algorithm, providing compression speed
      at 400 MB/s per core, with near-linear scalability for multi-threaded
      applications. It also features an extremely fast decoder, with speed in
      multiple GB/s per core, typically reaching RAM speed limits on
      multi-core systems.
    '';
    homepage = "https://lz4.github.io/lz4/";
    license = with licenses; [
      bsd2
      gpl2Plus
    ];
    platforms = platforms.all;
    mainProgram = "lz4";
    maintainers = [ maintainers.tobim ];
  };
})
