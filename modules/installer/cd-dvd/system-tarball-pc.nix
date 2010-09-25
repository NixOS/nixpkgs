# This module contains the basic configuration for building a NixOS
# installation CD.

{ config, pkgs, ... }:

with pkgs.lib;

let

  pkgs2storeContents = l : map (x: { object = x; symlink = "none"; }) l;

in

{
  require = [
    ./system-tarball.nix
 
   # Profiles of this basic installation.
    ../../profiles/base.nix
    ../../profiles/installation-device.nix
  ];

  # To speed up further installation of packages, include the complete stdenv
  # in the Nix store of the tarball.
  tarball.storeContents = pkgs2storeContents [ pkgs.stdenv pkgs.klibc pkgs.klibcShrunk ];
}
