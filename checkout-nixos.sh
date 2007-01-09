#! /bin/sh
nix-channel --add http://nix.cs.uu.nl/dist/nix/channels-v3/nixpkgs-unstable
nix-channel --update
nix-env -i subversion
svn co https://svn.cs.uu.nl:12443/repos/trace/nixos/trunk nixos
svn co https://svn.cs.uu.nl:12443/repos/trace/nixpkgs/trunk nixpkgs
ln -s ../nixpkgs/pkgs nixos/pkgs
