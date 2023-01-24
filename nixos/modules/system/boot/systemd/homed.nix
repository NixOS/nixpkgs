{ config, lib, pkgs, ... }:

let
  cfg = config.services.homed;
in
{
  options.services.homed.enable = lib.mkEnableOption (lib.mdDoc ''
    Enable systemd home area/user account manager
  '');

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.services.nscd.enable;
        message = "systemd-homed requires the use of systemd nss module. services.nscd.enable must be set to true,";
      }
    ];

    systemd.additionalUpstreamSystemUnits = [
      "systemd-homed.service"
      "systemd-homed-activate.service"
    ];

    # This is mentioned in homed's [Install] section.
    #
    # While homed appears to work without it, it's probably better
    # to follow upstream recommendations.
    services.userdbd.enable = lib.mkDefault true;

    systemd.services = {
      systemd-homed = {
        # These packages are required to manage encrypted volumes
        path = config.system.fsPackages;
        aliases = [ "dbus-org.freedesktop.home1.service" ];
        wantedBy = [ "multi-user.target" ];
      };

      systemd-homed-activate = {
        wantedBy = [ "systemd-homed.service" ];
      };
    };
  };
}
