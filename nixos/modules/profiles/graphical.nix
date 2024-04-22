# This module defines a NixOS configuration with the Plasma 5 desktop.
# It's used by the graphical installation CD.

{ pkgs, ... }:

{
  services.xserver = {
    enable = true;
    desktopManager.plasma5.enable = true;
    libinput.enable = true; # for touchpad support on many laptops
  };

  services.displayManager.sddm.enable = true;

  # Enable sound in virtualbox appliances.
  hardware.pulseaudio.enable = true;

  environment.systemPackages = [ pkgs.glxinfo pkgs.firefox ];
}
