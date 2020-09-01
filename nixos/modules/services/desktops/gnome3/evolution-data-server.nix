# Evolution Data Server daemon.

{ config, lib, pkgs, ... }:

with lib;

{

  meta = {
    maintainers = teams.gnome.members;
  };

  ###### interface

  options = {

    services.gnome3.evolution-data-server = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable Evolution Data Server, a collection of services for
          storing addressbooks and calendars.
        '';
      };

    };

  };


  ###### implementation

  config =
  let evolution-with-plugins = (import ../../../../.. {}).evolution-with-plugins; in
  mkIf config.services.gnome3.evolution-data-server.enable {
    environment.systemPackages = [ evolution-with-plugins ];

    services.dbus.packages = [ evolution-with-plugins ];

    systemd.packages = [ evolution-with-plugins ];
  };
}
