# This module defines a netboot environment that contains GNOME.

{ ... }:

{
  imports =
    [ ./netboot-base.nix

      ../../profiles/graphical-base.nix
      ../../profiles/graphical-gnome.nix
    ];
}
