{
  pkgs ? import ../../../. { },
}:
pkgs.callPackage ./package.nix { }
