{
  pkgs ? import ../../.. { },
}:
pkgs.callPackage ./default.nix { }
