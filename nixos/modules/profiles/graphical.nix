# This module defines a NixOS configuration with the Plasma 5 desktop.
# It's used by the graphical installation CD.

{ config, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    displayManager.select = "sddm";
    desktopManager.select = [ "plasma5" ];
    synaptics.enable = true; # for touchpad support on many laptops
  };

  environment.systemPackages = [ pkgs.glxinfo ];
}
