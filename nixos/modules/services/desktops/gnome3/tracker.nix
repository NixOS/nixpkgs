# Tracker daemon.

{ config, pkgs, lib, ... }:

with lib;

{

  ###### interface

  options = {

    services.gnome3.tracker = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable Tracker services, a search engine,
          search tool and metadata storage system.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf config.services.gnome3.tracker.enable {

    environment.systemPackages = [ pkgs.gnome3.tracker ];

    services.dbus.packages = [ pkgs.gnome3.tracker ];

    systemd.packages = [ pkgs.gnome3.tracker ];

  };

}
