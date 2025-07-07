{
  callPackage,
  lib,
}:
let
  ides = lib.importJSON ./ides.json;
in
builtins.mapAttrs (
  _: info: callPackage ./build.nix (info // { mvnDeps = ./. + "/${info.mvnDeps}"; })
) ides
