{
  pkgs ? (import ./.. { }),
  nixpkgs ? { },
}:

pkgs.nixpkgs-manual.override { inherit nixpkgs; }
