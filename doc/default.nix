{
  pkgs ? (import ../ci { }).pkgs,
  nixpkgs ? { },
}:

pkgs.callPackage ./doc-support/package.nix { inherit nixpkgs; }
