# This module defines a NixOS installation CD that contains GNOME.

{ lib, ... }:

with lib;

{
  imports = [ ./installation-cd-graphical-base.nix ];

  isoImage.edition = "gnome";

  services.xserver.desktopManager.gnome3.enable = true;

  services.xserver.displayManager.gdm = {
    enable = true;
    # autoSuspend makes the machine automatically suspend after inactivity.
    # It's possible someone could/try to ssh'd into the machine and obviously
    # have issues because it's inactive.
    # See:
    # * https://github.com/NixOS/nixpkgs/pull/63790
    # * https://gitlab.gnome.org/GNOME/gnome-control-center/issues/22
    autoSuspend = false;
    autoLogin = {
      enable = true;
      user = "nixos";
    };
  };

}
