# Tracker daemon.

{ config, pkgs, lib, ... }:

with lib;

{

  meta = {
    maintainers = teams.gnome.members;
  };

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

    environment.systemPackages = [ pkgs.tracker ];

    services.dbus.packages = [ pkgs.tracker ];

    systemd.packages = [ pkgs.tracker ];

  };

}
