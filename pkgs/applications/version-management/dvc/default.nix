{ pkgs ? import <nixpkgs> {} }:

with pkgs;
callPackage ./requirements.nix {}
