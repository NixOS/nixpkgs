# This file is here for development. It will be removed eventually...
let
  pkgs = import ../../../.. { };
in
pkgs.python314Packages.callPackage ./package.nix { }
