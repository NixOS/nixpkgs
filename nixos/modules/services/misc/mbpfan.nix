{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.mbpfan;
  verbose = lib.optionalString cfg.verbose "v";
  format = pkgs.formats.ini { };
  cfgfile = format.generate "mbpfan.ini" cfg.settings;

in
{
  options.services.mbpfan = {
    enable = lib.mkEnableOption "mbpfan, fan controller daemon for Apple Macs and MacBooks";
    package = lib.mkPackageOption pkgs "mbpfan" { };

    verbose = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "If true, sets the log level to verbose.";
    };

    aggressive = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "If true, favors higher default fan speeds.";
    };

    settings = lib.mkOption {
      default = { };
      description = "INI configuration for Mbpfan.";
      type = lib.types.submodule {
        freeformType = format.type;

        options.general.low_temp = lib.mkOption {
          type = lib.types.int;
          default = (if cfg.aggressive then 55 else 63);
          defaultText = lib.literalExpression "55";
          description = "If temperature is below this, fans will run at minimum speed.";
        };
        options.general.high_temp = lib.mkOption {
          type = lib.types.int;
          default = (if cfg.aggressive then 58 else 66);
          defaultText = lib.literalExpression "58";
          description = "If temperature is above this, fan speed will gradually increase.";
        };
        options.general.max_temp = lib.mkOption {
          type = lib.types.int;
          default = (if cfg.aggressive then 78 else 86);
          defaultText = lib.literalExpression "78";
          description = "If temperature is above this, fans will run at maximum speed.";
        };
        options.general.polling_interval = lib.mkOption {
          type = lib.types.int;
          default = 1;
          description = "The polling interval.";
        };
      };
    };
  };

  imports = [
    (lib.mkRenamedOptionModule
      [ "services" "mbpfan" "pollingInterval" ]
      [ "services" "mbpfan" "settings" "general" "polling_interval" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "mbpfan" "maxTemp" ]
      [ "services" "mbpfan" "settings" "general" "max_temp" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "mbpfan" "lowTemp" ]
      [ "services" "mbpfan" "settings" "general" "low_temp" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "mbpfan" "highTemp" ]
      [ "services" "mbpfan" "settings" "general" "high_temp" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "mbpfan" "minFanSpeed" ]
      [ "services" "mbpfan" "settings" "general" "min_fan1_speed" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "mbpfan" "maxFanSpeed" ]
      [ "services" "mbpfan" "settings" "general" "max_fan1_speed" ]
    )
  ];

  config = lib.mkIf cfg.enable {
    boot.kernelModules = [
      "coretemp"
      "applesmc"
    ];
    environment.systemPackages = [ cfg.package ];
    environment.etc."mbpfan.conf".source = cfgfile;

    systemd.services.mbpfan = {
      description = "A fan manager daemon for MacBook Pro";
      wantedBy = [ "sysinit.target" ];
      after = [ "sysinit.target" ];
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
