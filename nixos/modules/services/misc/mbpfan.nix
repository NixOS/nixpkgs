{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.services.mbpfan;
  verbose = optionalString cfg.verbose "v";
  settingsFormat = pkgs.formats.ini {};
  settingsFile = settingsFormat.generate "mbpfan.ini" cfg.settings;

in {
  options.services.mbpfan = {
    enable = mkEnableOption (lib.mdDoc "mbpfan, fan controller daemon for Apple Macs and MacBooks");

    package = mkOption {
      type = types.package;
      default = pkgs.mbpfan;
      defaultText = literalExpression "pkgs.mbpfan";
      description = lib.mdDoc "The package used for the mbpfan daemon.";
    };

    verbose = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc "If true, sets the log level to verbose.";
    };

    aggressive = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc "If true, favors higher default fan speeds.";
    };

    settings = mkOption {
      default = {};
      description = lib.mdDoc "INI configuration for Mbpfan.";
      type = types.submodule {
        freeformType = settingsFormat.type;

        options.general.low_temp = mkOption {
          type = types.int;
          default = 63;
          description = lib.mdDoc "If temperature is below this, fans will run at minimum speed.";
        };
        options.general.high_temp = mkOption {
          type = types.int;
          default = 66;
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
    services.mbpfan.settings = mkIf cfg.aggressive {
      general.min_fan1_speed = mkDefault 2000;
      general.low_temp = mkDefault 55;
      general.high_temp = mkDefault 58;
      general.max_temp = mkDefault 70;
    };

    boot.kernelModules = [ "coretemp" "applesmc" ];
    environment.systemPackages = [ cfg.package ];
    environment.etc."mbpfan.conf".source = settingsFile;

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
