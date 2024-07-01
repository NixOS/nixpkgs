#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash
set -eux

nix-build -A "librandombytes"
nix-build -I nixpkgs=$PWD -E 'with import <nixpkgs> {}; librandombytes.override({stdenv = clangStdenv;})'
nix-build -A "pkgsCross.aarch64-multiplatform.librandombytes"
nix-build -I nixpkgs=$PWD -E 'with import <nixpkgs> {}; pkgsCross.aarch64-multiplatform.librandombytes.override({stdenv = clangStdenv;})'
