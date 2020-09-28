{ lib, pkgs }:

lib.makeScope pkgs.newScope (self: with self; {
  buildsystem    = callPackage ./buildsystem.nix { };
  libparserutils = callPackage ./libparserutils.nix { };
})
