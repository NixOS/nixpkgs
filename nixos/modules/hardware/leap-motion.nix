{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.hardware.leap-motion;
in {
  options.hardware.leap-motion = {
    enable = mkEnableOption "Core software for the Leap Motion as well as udev rules for the device";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.leap-motion ];
    services.udev.packages = [ pkgs.leap-motion ];

    systemd.services.leapd = {
      description = "Leap Motion Daemon";
      after = [ "systemd-udev-settle.service" ];
      wantedBy = [ "default.target" ];

      serviceConfig = {
        Type = "simple";
        Restart = "always";
        ExecStart = "${pkgs.leap-motion}/bin/leapd";
        KillSignal = "SIGKILL";
      };
    };
  };
}

