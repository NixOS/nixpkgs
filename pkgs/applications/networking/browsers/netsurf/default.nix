{ lib, pkgs }:

lib.makeScope pkgs.newScope (self: with self; {
  buildsystem    = callPackage ./buildsystem.nix { };
  libcss         = callPackage ./libcss.nix { };
  libdom         = callPackage ./libdom.nix { };
  libhubbub      = callPackage ./libhubbub.nix { };
  libnsbmp       = callPackage ./libnsbmp.nix { };
  libnsgif       = callPackage ./libnsgif.nix { };
  libnslog       = callPackage ./libnslog.nix { };
  libnspsl       = callPackage ./libnspsl.nix { };
  libnsutils     = callPackage ./libnsutils.nix { };
  libparserutils = callPackage ./libparserutils.nix { };
  libsvgtiny     = callPackage ./libsvgtiny.nix { };
  libutf8proc    = callPackage ./libutf8proc.nix { };
  libwapcaplet   = callPackage ./libwapcaplet.nix { };
  nsgenbind      = callPackage ./nsgenbind.nix { };
})
