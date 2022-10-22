# Tracker Miners daemons.

{ config, pkgs, lib, ... }:

with lib;

{

  meta = {
    maintainers = teams.gnome.members;
  };

  imports = [
    # Added 2021-05-07
    (mkRenamedOptionModule
      [ "services" "gnome3" "tracker-miners" "enable" ]
      [ "services" "gnome" "tracker-miners" "enable" ]
    )
  ];

  ###### interface

  options = {

    services.gnome.tracker-miners = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to enable Tracker miners, indexing services for Tracker
          search engine and metadata storage system.
        '';
      };

    };

  };

  ###### implementation

  config = mkIf config.services.gnome.tracker-miners.enable {

    environment.systemPackages = [ pkgs.tracker-miners ];

    services.dbus.packages = [ pkgs.tracker-miners ];

    systemd.packages = [ pkgs.tracker-miners ];

    services.gnome.tracker.subcommandPackages = [ pkgs.tracker-miners ];

  };

}
