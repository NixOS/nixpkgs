# This file is here for development. It will be removed eventually...
let
  sources = import ./npins;
  pkgs = import sources.nixpkgs { };
in
pkgs.python314Packages.callPackage ./package.nix { }
