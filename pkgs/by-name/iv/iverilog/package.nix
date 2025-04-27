{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
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
}:

stdenv.mkDerivation rec {
  pname = "iverilog";
  version = "12.0";

  src = fetchFromGitHub {
    owner = "steveicarus";
    repo = "iverilog";
    rev = "v${lib.replaceStrings [ "." ] [ "_" ] version}";
    hash = "sha256-J9hedSmC6mFVcoDnXBtaTXigxrSCFa2AhhFd77ueo7I=";
  };

  nativeBuildInputs = [
    autoconf
    bison
    flex
    gperf
  ];

  CC_FOR_BUILD = "${buildPackages.stdenv.cc}/bin/cc";
  CXX_FOR_BUILD = "${buildPackages.stdenv.cc}/bin/c++";

  patches = [
    # NOTE(jleightcap): `-Werror=format-security` warning patched shortly after release, backport the upstream fix
    (fetchpatch {
      name = "format-security";
      url = "https://github.com/steveicarus/iverilog/commit/23e51ef7a8e8e4ba42208936e0a6a25901f58c65.patch";
      hash = "sha256-fMWfBsCl2fuXe+6AR10ytb8QpC84bXlP5RSdrqsWzEk=";
    })
  ];

  buildInputs = [
    bzip2
    ncurses
    readline
    zlib
  ];

  preConfigure = "sh autoconf.sh";

  enableParallelBuilding = true;

  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration";
  };

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
  ];

  installCheckPhase = ''
    runHook preInstallCheck
    export PATH="$PATH:$out/bin"
    sh .github/test.sh
    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "Icarus Verilog compiler";
    homepage = "https://steveicarus.github.io/iverilog";
    license = with licenses; [
      gpl2Plus
      lgpl21Plus
    ];
    maintainers = with maintainers; [ thoughtpolice ];
    platforms = platforms.all;
  };
}
