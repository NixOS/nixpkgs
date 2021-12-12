# This module defines a netboot environment that contains Plasma 5.

{ ... }:

{
  imports =
    [ ./netboot-base.nix

      ../../profiles/graphical-base.nix
      ../../profiles/graphical-plasma5.nix
    ];
}
