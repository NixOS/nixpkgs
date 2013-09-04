# This module defines a NixOS installation CD that contains X11 and
# KDE 4.

{ config, pkgs, ... }:

with pkgs.lib;

{
  imports = [ ./installation-cd-base.nix ../../profiles/graphical.nix ];

  # Provide wicd for easy wireless configuration.
  #networking.wicd.enable = true;

  # KDE complains if power management is disabled (to be precise, if
  # there is no power management backend such as upower).
  powerManagement.enable = true;

  # Don't start the X server by default.
  services.xserver.autorun = mkForce false;

  # Auto-login as root.
  services.xserver.displayManager.kdm.extraConfig =
    ''
      [X-*-Core]
      AllowRootLogin=true
      AutoLoginEnable=true
      AutoLoginUser=root
      AutoLoginPass=""
    '';
}
