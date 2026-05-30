{
  pkgs ? import ../../.. { },
}:
pkgs.python3Packages.callPackage ./default.nix { }
