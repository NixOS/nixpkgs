# This module defines a NixOS installation CD that contains X11 and
# GNOME 3.

{ lib, ... }:

with lib;

{
  imports = [ ./installation-cd-graphical-base.nix ];

  services.xserver.desktopManager.gnome3.enable = true;

  services.xserver.displayManager.slim.enable = lib.mkForce false;

  # wayland can be problematic for some hardware
  services.xserver.desktopManager.default = "gnome-xorg";

  services.xserver.displayManager.gdm = {
    enable = true;
    # This might be problematic on a live system
    autoSuspend = false;
    autoLogin = {
      enable = true;
      user = "live";
    };
  };

}
