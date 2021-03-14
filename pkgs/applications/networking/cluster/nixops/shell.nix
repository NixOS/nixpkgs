{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.poetry2nix.cli
    pkgs.pkgconfig
    pkgs.libvirt
    pkgs.poetry
  ];
}
