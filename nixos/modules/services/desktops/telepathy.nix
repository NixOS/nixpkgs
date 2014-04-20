# Telepathy daemon.

{ config, lib, pkgs, ... }:

with lib;

{

  ###### interface

  options = {

    services.telepathy = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable Telepathy service, a communications framework
          that enables real-time communication via pluggable protocol backends.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf config.services.telepathy.enable {

    environment.systemPackages = [ pkgs.telepathy_mission_control ];

    services.dbus.packages = [ pkgs.telepathy_mission_control ];

  };

}
