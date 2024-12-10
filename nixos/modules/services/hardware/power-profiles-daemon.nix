{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.power-profiles-daemon;
in

{

  ###### interface

  options = {

    services.power-profiles-daemon = {

      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to enable power-profiles-daemon, a DBus daemon that allows
          changing system behavior based upon user-selected power profiles.
        '';
      };

      package = lib.mkPackageOption pkgs "power-profiles-daemon" { };

    };

  };

  ###### implementation

  config = lib.mkIf cfg.enable {

    assertions = [
      {
        assertion = !config.services.tlp.enable;
        message = ''
          You have set services.power-profiles-daemon.enable = true;
          which conflicts with services.tlp.enable = true;
        '';
      }
    ];

    environment.systemPackages = [ cfg.package ];

    services.dbus.packages = [ cfg.package ];

    services.udev.packages = [ cfg.package ];

    systemd.packages = [ cfg.package ];

  };

}
