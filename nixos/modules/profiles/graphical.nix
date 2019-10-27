# This module defines a NixOS configuration with the Plasma 5 desktop.
# It's used by the graphical installation CD.

{ pkgs, ... }:

{
  services.xserver = {
    enable = true;
    displayManager.sddm.enable = true;
    desktopManager.plasma5 = {
      enable = true;
      enableQt4Support = false;
    };
    libinput.enable = true; # for touchpad support on many laptops
  };

  # Enable sound in virtualbox appliances.
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.systemWide = true; # Needed since we run plasma as root.

  environment.systemPackages = [ pkgs.glxinfo pkgs.firefox ];
}
