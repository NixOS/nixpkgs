{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  bintools-unwrapped,
  callPackage,
  coreutils,
  replaceVars,
  unzip,
}:

let
  bootstrap-version = "3.9.2";
  cosmocc-zip = fetchurl {
    url = "https://github.com/jart/cosmopolitan/releases/download/${bootstrap-version}/cosmocc-${bootstrap-version}.zip";
    sha256 = "sha256-9P8Tr2X80wnz8c/QQnWZb7f3KkiXcmYoqMnPcy6FAZM=";
  };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "cosmopolitan";
  version = "4.0.2";

  src = fetchFromGitHub {
    owner = "jart";
    repo = "cosmopolitan";
    rev = finalAttrs.version;
    hash = "sha256-NaWQK7SkqS3rrGG95dEjq8ptXogYU4bNndoXPU2rXnM=";
  };

  patches = [
    # make sure tests set PATH correctly
    (replaceVars ./fix-paths.patch {
      inherit coreutils;
    })
  ];

  nativeBuildInputs = [
    bintools-unwrapped
    unzip
  ];

  strictDeps = true;

  outputs = [
    "out"
    "dist"
  ];

  # slashes are significant because upstream uses o/$(MODE)/foo.o
  buildFlags = [
    "o/cosmopolitan.h"
    "o//cosmopolitan.a"
    "o//libc/crt/crt.o"
    "o//ape/ape.o"
    "o//ape/ape.lds"
  ];

  checkTarget = "o//test";

  enableParallelBuilding = true;

  doCheck = true;
  dontConfigure = true;
  dontFixup = true;

  preBuild = ''
    # Extract cosmocc to the expected location
    mkdir -p .cosmocc/${bootstrap-version}
    unzip -qo ${cosmocc-zip} -d .cosmocc/${bootstrap-version}
  '';

  preCheck =
    let
      failingTests = [
        # some syscall tests fail because we're in a sandbox
        "test/libc/calls/sched_setscheduler_test.c"
        "test/libc/thread/pthread_create_test.c"
        "test/libc/calls/getgroups_test.c"
        # fails
        "test/libc/stdio/posix_spawn_test.c"
      ];
    in
    lib.concatStringsSep ";\n" (map (t: "rm -v ${t}") failingTests);

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{include,lib}
    install o/cosmopolitan.h $out/include
    install o/cosmopolitan.a o/libc/crt/crt.o o/ape/ape.{o,lds} o/ape/ape-no-modify-self.o $out/lib
    cp -RT . "$dist"

    runHook postInstall
  '';

  passthru = {
    cosmocc = callPackage ./cosmocc.nix {
      cosmopolitan = finalAttrs.finalPackage;
    };
  };

  meta = {
    homepage = "https://justine.lol/cosmopolitan/";
    description = "Your build-once run-anywhere c library";
    license = lib.licenses.isc;
    teams = [ lib.teams.cosmopolitan ];
    platforms = lib.platforms.x86_64;
    badPlatforms = lib.platforms.darwin;
  };
})
