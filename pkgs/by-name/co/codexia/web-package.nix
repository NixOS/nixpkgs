{ lib, callPackages, ... }@args:

(callPackages ./package-set.nix (
  removeAttrs args [
    "callPackages"
    "lib"
  ]
)).codexia-web
