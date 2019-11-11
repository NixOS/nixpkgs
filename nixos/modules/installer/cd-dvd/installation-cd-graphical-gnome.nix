# This module defines a NixOS installation CD that contains X11 and
# GNOME 3.

{ lib, ... }:

with lib;

{
  imports = [ ./installation-cd-graphical-base.nix ];

  services.xserver.desktopManager.gnome3.enable = true;

  # Auto-login as root.
  services.xserver.displayManager.gdm.autoLogin = {
    enable = true;
    user = "root";
  };

}
