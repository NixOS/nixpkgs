{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.poetry2nix.cli
    pkgs.pkg-config
    pkgs.libvirt
    pkgs.poetry
  ];
}
