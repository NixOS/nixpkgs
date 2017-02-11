# This module defines a NixOS configuration that contains X11 and
# KDE 4.  It's used by the graphical installation CD.

{ config, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    displayManager.sddm.enable = true;
    desktopManager.kde5.enable = true;
    synaptics.enable = true; # for touchpad support on many laptops
  };

  environment.systemPackages = [ pkgs.glxinfo ];
}
