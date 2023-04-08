{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  packages = [
    pkgs.python310
    pkgs.poetry2nix.cli
    pkgs.pkg-config
    pkgs.libvirt
    pkgs.poetry
  ];
}
