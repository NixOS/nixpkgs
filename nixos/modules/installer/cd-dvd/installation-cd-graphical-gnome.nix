# This module defines a NixOS installation CD that contains X11 and
# GNOME 3.

{ config, lib, pkgs, ... }:

with lib;

{
  imports = [ ./installation-cd-graphical-base.nix ];

  services.xserver = {
    desktopManager.gnome3 = {
      enable = true;
      extraGSettingsOverrides = ''
        [org.gnome.desktop.background]
        show-desktop-icons=true

        [org.gnome.nautilus.desktop]
        trash-icon-visible=false
        volumes-visible=false
        home-icon-visible=false
        network-icon-visible=false
      '';

      extraGSettingsOverridePackages = [ pkgs.gnome3.nautilus ];
    };
  };

  # Auto-login as live.
  services.xserver.displayManager.gdm.autoLogin = {
    enable = true;
    user = "live";
  };

}
