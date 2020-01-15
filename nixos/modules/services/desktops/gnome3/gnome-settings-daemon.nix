# GNOME Settings Daemon

{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.gnome3.gnome-settings-daemon;

in

{

  ###### interface

  options = {

    services.gnome3.gnome-settings-daemon = {

      enable = mkEnableOption "GNOME Settings Daemon";

      # There are many forks of gnome-settings-daemon
      package = mkOption {
        type = types.package;
        default = pkgs.gnome3.gnome-settings-daemon;
        description = "Which gnome-settings-daemon package to use.";
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    environment.systemPackages = [ cfg.package ];

    services.udev.packages = [ cfg.package ];

  };

}
