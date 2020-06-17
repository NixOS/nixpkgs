# Tracker Miners daemons.

{ config, pkgs, lib, ... }:

with lib;

{

  meta = {
    maintainers = teams.gnome.members;
  };

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

    environment.systemPackages = [ pkgs.tracker-miners ];

    services.dbus.packages = [ pkgs.tracker-miners ];

    systemd.packages = [ pkgs.tracker-miners ];

  };

}
