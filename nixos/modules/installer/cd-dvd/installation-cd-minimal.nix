# This module defines a small NixOS installation CD.  It does not
# contain any graphical stuff.

{ lib, ... }:

{
  imports = [
    ../../profiles/minimal.nix
    ./installation-cd-base.nix
  ];

  documentation.man.enable = lib.mkOverride 500 true;

  fonts.fontconfig.enable = false;

  isoImage.edition = "minimal";
}
