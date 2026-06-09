{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  bison,
  bzip2,
  flex,
  gperf,
  ncurses,
  perl,
  python3,
  readline,
  zlib,
  buildPackages,
  addBinToPathHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "iverilog";
  version = "13.0";

  src = fetchFromGitHub {
    owner = "steveicarus";
    repo = "iverilog";
    tag = "v${lib.replaceStrings [ "." ] [ "_" ] finalAttrs.version}";
    hash = "sha256-SfODx7K3UrDHMoKCbMFpxo4t9j9vG1oWF0RFS3dSUm4=";
  };

  nativeBuildInputs = [
    autoconf
    bison
    flex
    gperf
  ];

  env = {
    CC_FOR_BUILD = "${lib.getExe' buildPackages.stdenv.cc "cc"}";
    CXX_FOR_BUILD = "${lib.getExe' buildPackages.stdenv.cc "cc++"}";
  }
  // lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration";
  };

  buildInputs = [
    bzip2
    ncurses
    readline
    zlib
  ];

  preConfigure = "sh autoconf.sh";

  configureFlags = [ "CFLAGS=-std=gnu17" ];

  enableParallelBuilding = true;

  # NOTE(jleightcap): the `make check` target only runs a "Hello, World"-esque sanity check.
  # the tests in the doInstallCheck phase run a full regression test suite.
  # however, these tests currently fail upstream on aarch64
  # (see https://github.com/steveicarus/iverilog/issues/917)
  # so disable the full suite for now.
  doCheck = true;
  doInstallCheck = !stdenv.hostPlatform.isAarch64;

  nativeInstallCheckInputs = [
    perl
    (python3.withPackages (
      pp: with pp; [
        docopt
      ]
    ))
    addBinToPathHook
  ];

  installCheckPhase = ''
    runHook preInstallCheck

    # PLI1 is not enabled in the build (ENABLE_PLI1=no), so skip PLI1 VPI tests
    # which would fail at runtime with "Failed - running vvp".
    sh .github/test.sh no-pli1

    runHook postInstallCheck
  '';

  meta = {
    description = "Icarus Verilog compiler";
    homepage = "https://steveicarus.github.io/iverilog";
    downloadPage = "https://github.com/steveicarus/iverilog";
    license = with lib.licenses; [
      gpl2Plus
      lgpl21Plus
    ];
    maintainers = with lib.maintainers; [ thoughtpolice ];
    platforms = lib.platforms.all;
    badPlatforms = [
      # Several tests fail with:
      # ==> Failed - running iverilog.
      "x86_64-darwin"
    ];
  };
})
