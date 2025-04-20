{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  bintools-unwrapped,
  coreutils,
  replaceVars,
  unzip,
  cosmocc,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "cosmopolitan";
  version = "4.0.2";

  src = fetchFromGitHub {
    owner = "jart";
    repo = "cosmopolitan";
    tag = finalAttrs.version;
    hash = "sha256-NaWQK7SkqS3rrGG95dEjq8ptXogYU4bNndoXPU2rXnM=";
  };

  patches = [
    # make sure tests set PATH correctly
    (replaceVars ./fix-paths.patch {
      inherit coreutils;
    })
  ];

  postPatch = ''
    sed -i '/^DOWNLOAD := $(shell build\/download-cosmocc.sh /d' Makefile
    mkdir .cosmocc
    ln -s ${cosmocc} .cosmocc/3.9.2
  '';

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
        "test/libc/calls/getprogramexecutablename_test.c"
        "test/libc/proc/posix_spawn_test.c"
        # Operation not permitted
        "test/libc/calls/cachestat_test.c"
      ];
    in
    lib.concatStringsSep ";\n" (map (t: "rm -v ${t}") failingTests);

  installPhase = ''
    runHook preInstall

    install -Dm644 o/cosmopolitan.a o/libc/crt/crt.o o/ape/ape.{o,lds} o/ape/ape-no-modify-self.o -t $out/lib
    cp -RT . "$dist"

    runHook postInstall
  '';

  meta = {
    homepage = "https://justine.lol/cosmopolitan";
    description = "Your build-once run-anywhere c library";
    license = lib.licenses.isc;
    teams = [ lib.teams.cosmopolitan ];
    platforms = lib.platforms.x86_64;
    badPlatforms = lib.platforms.darwin;
  };
})
