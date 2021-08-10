{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.hardware.tuxedo-control-center;
in
{
  options.hardware.tuxedo-control-center = {
    enable = mkEnableOption ''
      Tuxedo Control Center, the official fan and power management UI
      for Tuxedo laptops.

      This module does not offer any hardcoded configuration. So you
      will get the default configuration until you change it in the
      Tuxedo Control Center.
    '';
  };

  config = mkIf cfg.enable {

    hardware.tuxedo-keyboard.enable = true;
    boot.kernelModules = [ "tuxedo_io" ];

    environment.systemPackages = [
      pkgs.tuxedo-control-center
    ];

    services.dbus.packages = [ pkgs.tuxedo-control-center ];

    systemd.services.tccd = {
      path = [ pkgs.tuxedo-control-center ];

      description = "Tuxedo Control Center Service";

      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.tuxedo-control-center}/bin/tccd --start";
        ExecStop = "${pkgs.tuxedo-control-center}/bin/tccd --stop";
      };
    };

    systemd.services.tccd-sleep = {
      path = [ pkgs.tuxedo-control-center ];

      description = "Tuxedo Control Center Service (sleep/resume)";

      wantedBy = [ "sleep.target" ];

      unitConfig = {
        StopWhenUnneeded = "yes";
      };

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = "yes";

        ExecStart = "systemctl stop tccd";
        ExecStop = "systemctl start tccd";
      };
    };
  };
}
