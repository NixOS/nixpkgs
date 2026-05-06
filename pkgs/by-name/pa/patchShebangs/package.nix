{
  lib,
  stdenv,
  callPackage,
}:

stdenv.mkDerivation {
  pname = "patch-shebangs";
  version = "1.0.0";

  src = ./patch-shebangs.c;

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;
  dontPatchShebangs = true;

  installPhase = ''
    mkdir -p $out/bin
    $CC -std=c99 -O3 -Wall -o $out/bin/patch-shebangs $src
  '';

  strictDeps = true;

  passthru.tests = callPackage ./tests.nix { };

  meta = {
    description = "Rewrite script interpreter paths to Nix store paths";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.qweered ];
    platforms = lib.platforms.all;
  };
}
