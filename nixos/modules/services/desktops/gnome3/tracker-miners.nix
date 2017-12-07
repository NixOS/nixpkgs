# Tracker Miners daemons.

{ config, pkgs, lib, ... }:

with lib;

{

  ###### interface

  options = {

    services.gnome3.tracker-miners = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable Tracker miners, indexing services for Tracker
          search engine and metadata storage system.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf config.services.gnome3.tracker-miners.enable {

    environment.systemPackages = [ pkgs.gnome3.tracker-miners ];

    services.dbus.packages = [ pkgs.gnome3.tracker-miners ];

    systemd.packages = [ pkgs.gnome3.tracker-miners ];

  };

}
