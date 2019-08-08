# This module contains the basic configuration for building a graphical NixOS
# installation CD.

{ lib, pkgs, ... }:

with lib;

{
  imports = [ ./installation-cd-base.nix ];

  users.extraUsers.live = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "networkmanager" "video" ];
    # Allow the graphical user to login without password
    initialHashedPassword = "";
  };

  # Allow passwordless sudo from live user
  security.sudo = {
    enable = lib.mkForce true;
    wheelNeedsPassword = lib.mkForce false;
  };

  # Whitelist wheel users to do anything
  # This is useful for things like pkexec
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (subject.isInGroup("wheel")) {
        return polkit.Result.YES;
      }
    });
  '';

  services.xserver = {
    enable = true;

    # Don't start the X server by default.
    autorun = mkForce false;

    # Automatically login as root.
    displayManager.slim = {
      enable = true;
      defaultUser = "live";
      autoLogin = true;
    };

  };

  # Provide networkmanager for easy wireless configuration.
  networking.networkmanager.enable = true;
  networking.wireless.enable = mkForce false;

  # KDE complains if power management is disabled (to be precise, if
  # there is no power management backend such as upower).
  powerManagement.enable = true;

  # Enable sound in graphical iso's.
  hardware.pulseaudio.enable = true;

  environment.systemPackages = [
    # Include gparted for partitioning disks.
    pkgs.gparted

    # Include some editors.
    pkgs.vim
    pkgs.bvi # binary editor
    pkgs.joe

    # Firefox for reading the manual.
    pkgs.firefox

    pkgs.glxinfo
  ];

}
