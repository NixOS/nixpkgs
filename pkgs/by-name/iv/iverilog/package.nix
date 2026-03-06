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

    # Bypassing .github/test.sh because it does not forward command-line flags.
    # We need to pass -B and -M directly to the test drivers to ensure they find
    # local build artifacts silently without polluting stderr (which breaks gold files).
    export PATH="$(pwd)/driver:$(pwd)/vvp:$(pwd)/ivlpp:$PATH"
    export TMPDIR=$NIX_BUILD_TOP
    cd ivtest
    status=0
    perl vvp_reg.pl -B$(pwd)/.. || status=1
    perl vpi_reg.pl --with-pli1 -B$(pwd)/.. -M$(pwd)/../vpi || status=1
    unset IVL_ROOT
    unset IVERILOG_ICONFIG
    python3 vvp_reg.py || status=1

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
