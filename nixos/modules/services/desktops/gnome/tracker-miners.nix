# Tracker Miners daemons.

{ config, pkgs, lib, ... }:

{

  meta = {
    maintainers = lib.teams.gnome.members;
  };

  ###### interface

  options = {

    services.gnome.tracker-miners = {

      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to enable Tracker miners, indexing services for Tracker
          search engine and metadata storage system.
        '';
      };

    };

  };

  ###### implementation

  config = lib.mkIf config.services.gnome.tracker-miners.enable {

    environment.systemPackages = [ pkgs.tracker-miners ];

    services.dbus.packages = [ pkgs.tracker-miners ];

    systemd.packages = [ pkgs.tracker-miners ];

  };

}
