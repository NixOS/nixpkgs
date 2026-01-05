{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
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

  patches = [
    (fetchpatch {
      name = "CVE-2025-62813.patch";
      url = "https://github.com/lz4/lz4/commit/f64efec011c058bd70348576438abac222fe6c82.patch";
      hash = "sha256-qOvK0A3MGX14WdhThV7m4G6s+ZMP6eA/07A2BY5nesY=";
    })
  ];

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
