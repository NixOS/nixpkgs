{ config, lib, pkgs, ... }:

let
  cfg = config.services.power-profiles-daemon;
  package = pkgs.power-profiles-daemon;
in

{

  ###### interface

  options = {

    services.power-profiles-daemon = {

      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to enable power-profiles-daemon, a DBus daemon that allows
          changing system behavior based upon user-selected power profiles.
        '';
      };

    };

  };


  ###### implementation

  config = lib.mkIf cfg.enable {

    assertions = [
      { assertion = !config.services.tlp.enable;
        message = ''
          You have set services.power-profiles-daemon.enable = true;
          which conflicts with services.tlp.enable = true;
        '';
      }
    ];

    environment.systemPackages = [ package ];

    services.dbus.packages = [ package ];

    services.udev.packages = [ package ];

    systemd.packages = [ package ];

  };

}
