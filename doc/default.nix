{
  pkgs ? (import ../ci { }).docPkgs,
  nixpkgs ? { },
}:

pkgs.callPackage ./doc-support/package.nix { inherit nixpkgs; }
