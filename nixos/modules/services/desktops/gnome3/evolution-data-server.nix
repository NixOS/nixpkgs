# Evolution Data Server daemon.

{ config, lib, pkgs, ... }:

with lib;

let
  gnome3 = config.environment.gnome3.packageSet;
in
{

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

  config = mkIf config.services.gnome3.evolution-data-server.enable {

    environment.systemPackages = [ gnome3.evolution_data_server ];

    services.dbus.packages = [ gnome3.evolution_data_server ];

  };

}
