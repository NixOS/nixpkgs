{ pkgs ? import ../../../.. { } }:

# Ideally, pkgs points to default.nix file of Nixpkgs official tree
with pkgs;

mkShell {
  packages = [
    bash
    curl
    gawk
    gnugrep
    gnused
    jq
    nix
    nix-prefetch
    nix-prefetch-scripts
  ];
}
