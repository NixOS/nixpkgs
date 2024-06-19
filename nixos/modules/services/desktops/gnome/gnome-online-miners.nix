# GNOME Online Miners daemon.

{ config, pkgs, lib, ... }:

{

  meta = {
    maintainers = lib.teams.gnome.members;
  };

  ###### interface

  options = {

    services.gnome.gnome-online-miners = {

      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to enable GNOME Online Miners, a service that
          crawls through your online content.
        '';
      };

    };

  };


  ###### implementation

  config = lib.mkIf config.services.gnome.gnome-online-miners.enable {

    environment.systemPackages = [ pkgs.gnome.gnome-online-miners ];

    services.dbus.packages = [ pkgs.gnome.gnome-online-miners ];

  };

}
