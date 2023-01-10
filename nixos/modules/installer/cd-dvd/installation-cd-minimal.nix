# This module defines a small NixOS installation CD.  It does not
# contain any graphical stuff.

{ lib, ... }:

{
  imports = [
    ../../profiles/minimal.nix
    ./installation-cd-base.nix
  ];

  # Causes a lot of uncached builds for a negligible decrease in size.
  environment.noXlibs = lib.mkOverride 500 false;

  documentation.man.enable = lib.mkOverride 500 true;

  fonts.fontconfig.enable = lib.mkForce false;

  isoImage.edition = lib.mkForce "minimal";
}
