# GNOME Online Miners daemon.

{ config, pkgs, lib, ... }:

with lib;

{

  meta = {
    maintainers = teams.gnome.members;
  };

  ###### interface

  options = {

    services.gnome.gnome-online-miners = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable GNOME Online Miners, a service that
          crawls through your online content.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf config.services.gnome.gnome-online-miners.enable {

    environment.systemPackages = [ pkgs.gnome.gnome-online-miners ];

    services.dbus.packages = [ pkgs.gnome.gnome-online-miners ];

  };

}
