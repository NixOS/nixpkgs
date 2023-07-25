# binfmt preserve-argv[0] wrapper
#
# More details in binfmt-p-wrapper.c
#
# The wrapper has to be static so LD_* environment variables
# cannot affect the execution of the wrapper itself.

{ lib, stdenv, pkgsStatic, enableDebug ? false }:

name: emulator:

pkgsStatic.stdenv.mkDerivation {
  inherit name;

  src = ./binfmt-p-wrapper.c;

  dontUnpack = true;
  dontInstall = true;

  buildPhase = ''
    runHook preBuild

    mkdir -p $out/bin
    $CC -o $out/bin/${name} -static -std=c99 -O2 \
        -DTARGET_QEMU=\"${emulator}\" \
        ${lib.optionalString enableDebug "-DDEBUG"} \
        $src

    runHook postBuild
  '';
}
