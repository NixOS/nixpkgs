{ lib, pkgs }:

lib.makeScope pkgs.newScope (self: with self; {
  buildsystem    = callPackage ./buildsystem.nix { };
  libnsbmp       = callPackage ./libnsbmp.nix { };
  libnsgif       = callPackage ./libnsgif.nix { };
  libnslog       = callPackage ./libnslog.nix { };
  libparserutils = callPackage ./libparserutils.nix { };
})
