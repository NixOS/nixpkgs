{
  lib,
  callPackage,
}:

let
  data = lib.importJSON ./versions.json;
in
callPackage ./generic.nix ({ version = data.latest; } // data.versions.${data.latest})
