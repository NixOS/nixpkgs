# This module defines a NixOS configuration with the Plasma 5 desktop.
# It's used by the graphical installation CD.

{ config, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;
    synaptics.enable = true; # for touchpad support on many laptops
  };

  environment.systemPackages = [ pkgs.glxinfo ];
}
