{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.mbpfan;
  verbose = if cfg.verbose then "v" else "";
  settingsFormat = pkgs.formats.ini {};
  settingsFile = settingsFormat.generate "mbpfan.ini" cfg.settings;

in {
  options.services.mbpfan = {
    enable = mkEnableOption "mbpfan, fan controller daemon for Apple Macs and MacBooks";

    package = mkOption {
      type = types.package;
      default = pkgs.mbpfan;
      defaultText = literalExpression "pkgs.mbpfan";
      description = lib.mdDoc ''
        The package used for the mbpfan daemon.
      '';
    };

    verbose = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        If true, sets the log level to verbose.
      '';
    };

    settings = mkOption {
      default = {};
      description = lib.mdDoc "INI configuration for Mbpfan.";
      type = types.submodule {
        freeformType = settingsFormat.type;

        options.general.min_fan1_speed = mkOption {
          type = types.nullOr types.int;
          default = 2000;
          description = ''
            You can check minimum and maximum fan limits with
            "cat /sys/devices/platform/applesmc.768/fan*_min" and
            "cat /sys/devices/platform/applesmc.768/fan*_max" respectively.
            Setting to null implies using default value from applesmc.
          '';
        };
        options.general.low_temp = mkOption {
          type = types.int;
          default = 55;
          description = lib.mdDoc "If temperature is below this, fans will run at minimum speed.";
        };
        options.general.high_temp = mkOption {
          type = types.int;
          default = 58;
          description = lib.mdDoc "If temperature is above this, fan speed will gradually increase.";
        };
        options.general.max_temp = mkOption {
          type = types.int;
          default = 86;
          description = lib.mdDoc "If temperature is above this, fans will run at maximum speed.";
        };
        options.general.polling_interval = mkOption {
          type = types.int;
          default = 1;
          description = lib.mdDoc "The polling interval.";
        };
      };
    };
  };

  imports = [
    (mkRenamedOptionModule [ "services" "mbpfan" "pollingInterval" ] [ "services" "mbpfan" "settings" "general" "polling_interval" ])
    (mkRenamedOptionModule [ "services" "mbpfan" "maxTemp" ] [ "services" "mbpfan" "settings" "general" "max_temp" ])
    (mkRenamedOptionModule [ "services" "mbpfan" "lowTemp" ] [ "services" "mbpfan" "settings" "general" "low_temp" ])
    (mkRenamedOptionModule [ "services" "mbpfan" "highTemp" ] [ "services" "mbpfan" "settings" "general" "high_temp" ])
    (mkRenamedOptionModule [ "services" "mbpfan" "minFanSpeed" ] [ "services" "mbpfan" "settings" "general" "min_fan1_speed" ])
    (mkRenamedOptionModule [ "services" "mbpfan" "maxFanSpeed" ] [ "services" "mbpfan" "settings" "general" "max_fan1_speed" ])
  ];

  config = mkIf cfg.enable {
    boot.kernelModules = [ "coretemp" "applesmc" ];

    environment.etc."mbpfan.conf".source = settingsFile;
    environment.systemPackages = [ cfg.package ];

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
