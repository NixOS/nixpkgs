# This module defines a small NixOS installation CD.  It does not
# contain any graphical stuff.

{ lib, ... }:

{
  imports = [
    ../../profiles/minimal.nix
    ./installation-cd-base.nix
  ];

  documentation.man.enable = lib.mkOverride 500 true;

  # Although we don't really need HTML documentation in the minimal installer,
  # not including it may cause annoying cache misses in the case of the NixOS manual.
  documentation.doc.enable = lib.mkOverride 500 true;

  fonts.fontconfig.enable = lib.mkOverride 500 false;

  isoImage.edition = lib.mkOverride 500 "minimal";
}
