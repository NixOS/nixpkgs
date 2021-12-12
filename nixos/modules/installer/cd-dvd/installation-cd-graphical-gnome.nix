# This module defines a NixOS installation CD that contains GNOME.

{ ... }:

{
  imports =
    [ ./installation-cd-graphical-base.nix

      ../../profiles/graphical-gnome.nix
    ];

  isoImage.edition = "gnome";
}
