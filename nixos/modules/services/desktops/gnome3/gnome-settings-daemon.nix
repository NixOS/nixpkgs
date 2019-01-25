# GNOME Settings Daemon

{ config, lib, pkgs, ... }:

with lib;

{

  ###### interface

  options = {

    services.gnome3.gnome-settings-daemon = {

      enable = mkEnableOption "GNOME Settings Daemon";

    };

  };


  ###### implementation

  config = mkIf config.services.gnome3.gnome-settings-daemon.enable {

    environment.systemPackages = [ pkgs.gnome3.gnome-settings-daemon ];

    services.udev.packages = [ pkgs.gnome3.gnome-settings-daemon ];

  };

}
