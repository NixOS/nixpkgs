let
  sources = import ./npins;
  pkgs = import sources.nixpkgs { };
in
pkgs.python3Packages.callPackage ./nix-vars.nix { }
