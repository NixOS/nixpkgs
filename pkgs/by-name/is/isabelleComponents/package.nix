{ lib, callPackage }:

lib.recurseIntoAttrs (callPackage ./components.nix { })
