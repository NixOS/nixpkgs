{
  pkgs ? (import ./.. { }),
  nixpkgs ? { },
}:

pkgs.callPackage ./doc-support/package.nix { inherit nixpkgs; }
