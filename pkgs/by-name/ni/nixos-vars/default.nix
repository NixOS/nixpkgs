let
  sources = import ./npins;
  pkgs = import sources.nixpkgs { };
in
pkgs.python314Packages.callPackage ./nix-vars.nix { }
