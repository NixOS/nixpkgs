{ lib, stdenv, callPackage }@prev:
{ go }:
let
  # Pass go to lib so functions can implement version-specific behavior.
  lib' = import ./lib { inherit lib go; };
  inherit (lib') toGoEnv isCross;
in
lib.makeExtensible (goPlatform: {
  buildGoModule = callPackage ./module.nix { inherit go goPlatform; };
  buildGoPackage = callPackage ./package.nix { inherit go goPlatform; };

  build.env = toGoEnv stdenv.buildPlatform;
  host.env = toGoEnv stdenv.hostPlatform;
  target.env = toGoEnv stdenv.targetPlatform;

  isCross = isCross
    goPlatform.build.env
    goPlatform.host.env;
})
