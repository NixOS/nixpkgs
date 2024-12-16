{
  lib,
  stdenv,
  fetchFromGitHub,
  bintools-unwrapped,
  callPackage,
  coreutils,
  substituteAll,
  unzip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cosmopolitan";
  version = "2.2";

  src = fetchFromGitHub {
    owner = "jart";
    repo = "cosmopolitan";
    rev = finalAttrs.version;
    hash = "sha256-DTL1dXH+LhaxWpiCrsNjV74Bw5+kPbhEAA2Z1NKiPDk=";
  };

  patches = [
    # make sure tests set PATH correctly
    (substituteAll {
      src = ./fix-paths.patch;
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
    maintainers = lib.teams.cosmopolitan.members;
    platforms = lib.platforms.x86_64;
    badPlatforms = lib.platforms.darwin;
  };
})
