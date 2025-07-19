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
  options.services.mbpfan.enable = lib.mkEnableOption "mbpfan, fan controller daemon for Apple Macs and MacBooks";
  options.services.mbpfan.verbose = lib.mkEnableOption "verbose log level";
  options.services.mbpfan.quiet = lib.mkEnableOption "less aggressive default fan speeds";
  options.services.mbpfan.package = lib.mkPackageOption pkgs "mbpfan" { };

  options.services.mbpfan.settings = lib.mkOption {
    default = { };
    description = "";
    type = lib.types.submodule {
      freeformType = format.type;

      options.general.low_temp = lib.mkOption {
        type = lib.types.int;
        default = (if cfg.quiet then 63 else 55);
        defaultText = lib.literalExpression "55";
        description = "If temperature is below this, fans will run at minimum speed.";
      };
      options.general.high_temp = lib.mkOption {
        type = lib.types.int;
        default = (if cfg.quiet then 66 else 58);
        defaultText = lib.literalExpression "58";
        description = "If temperature is above this, fan speed will gradually increase.";
      };
      options.general.max_temp = lib.mkOption {
        type = lib.types.int;
        default = (if cfg.quiet then 86 else 78);
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

  config = lib.mkIf cfg.enable {
    environment.etc."mbpfan.conf".source = cfgfile;
    boot.kernelModules = [
      "coretemp"
      "applesmc"
    ];

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
