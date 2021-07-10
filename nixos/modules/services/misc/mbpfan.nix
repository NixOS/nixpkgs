{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.mbpfan;
  verbose = if cfg.verbose then "v" else "";

in {
  options.services.mbpfan = {
    enable = mkEnableOption "mbpfan, fan controller daemon for Apple Macs and MacBooks";

    package = mkOption {
      type = types.package;
      default = pkgs.mbpfan;
      defaultText = "pkgs.mbpfan";
      description = ''
        The package used for the mbpfan daemon.
      '';
    };

    minFanSpeed = mkOption {
      type = types.int;
      default = 2000;
      description = ''
        The minimum fan speed.
      '';
    };

    maxFanSpeed = mkOption {
      type = types.int;
      default = 6199;
      description = ''
        The maximum fan speed.
      '';
    };

    lowTemp = mkOption {
      type = types.int;
      default = 55;
      description = ''
        The low temperature.
      '';
    };

    highTemp = mkOption {
      type = types.int;
      default = 58;
      description = ''
        The high temperature.
      '';
    };

    maxTemp = mkOption {
      type = types.int;
      default = 86;
      description = ''
        The maximum temperature.
      '';
    };

    pollingInterval = mkOption {
      type = types.int;
      default = 1;
      description = ''
        The polling interval.
      '';
    };

    verbose = mkOption {
      type = types.bool;
      default = false;
      description = ''
        If true, sets the log level to verbose.
      '';
    };
  };

  config = mkIf cfg.enable {
    boot.kernelModules = [ "coretemp" "applesmc" ];

    environment = {
      etc."mbpfan.conf".text = ''
        [general]
        min_fan1_speed = ${toString cfg.minFanSpeed}
        max_fan1_speed = ${toString cfg.maxFanSpeed}
        low_temp = ${toString cfg.lowTemp}
        high_temp = ${toString cfg.highTemp}
        max_temp = ${toString cfg.maxTemp}
        polling_interval = ${toString cfg.pollingInterval}
      '';
      systemPackages = [ cfg.package ];
    };

    systemd.services.mbpfan = {
      description = "A fan manager daemon for MacBook Pro";
      wantedBy = [ "sysinit.target" ];
      after = [ "syslog.target" "sysinit.target" ];
      restartTriggers = [ config.environment.etc."mbpfan.conf".source ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${cfg.package}/bin/mbpfan -f${verbose}";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        PIDFile = "/run/mbpfan.pid";
        Restart = "always";
      };
    };
  };
}
