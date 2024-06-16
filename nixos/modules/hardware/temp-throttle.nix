{ config, lib, pkgs, ... }:

let
  cfg = config.services.temp-throttle;
  configFile = pkgs.writeText "temp-throttle.conf" (''
    MAX_TEMP=${toString cfg.max_temp}
    INTERVAL=${toString cfg.interval}
  '' + lib.optionalString (cfg.temp_file != null) ''
    TEMP_FILE=${cfg.temp_file}
  '' + lib.optionalString (cfg.core != null) ''
    CORE=${toString cfg.core}
  '' + lib.optionalString (cfg.log_file != null) ''
    LOG_FILE=${cfg.log_file}
  '');
in {
  meta.maintainers = [ lib.maintainers.Sepero ];

  options.services.temp-throttle = let
    mkOption = lib.mkOption;
    nullOr = lib.types.nullOr;
    str = lib.types.str;
#    int = lib.types.int;
    uint = lib.types.ints.unsigned;
  in {
    enable = lib.mkEnableOption "Whether to enable temp-throttle service";
    package = lib.mkPackageOption pkgs "temp-throttle" { };
    max_temp = mkOption {
      type = uint;
      default = 80;
      description = "Maximum desired temperature in Celcius";
    };
    interval = mkOption {
      type = uint;
      default = 3;
      description = "Seconds between checking temperature. Default 3";
    };
    temp_file = mkOption {
      type = nullOr str;
      default = null;
      description =
        "Force read CPU temperature from given file. Default auto detection";
      example = "/sys/class/hwmon/hwmon1/device/temp1_input";
    };
    core = mkOption {
      type = uint;
#      type = nullOr int;
      default = 0;
      description =
        "Force read frequency from given CPU Core. May be needed for big.little endian. Default 0";
    };
    log_file = mkOption {
      type = nullOr str;
      default = null;
      description = "Log output to given file. Default stdout";
    };
  };
  config = lib.mkIf cfg.enable {
    systemd.services.temp-throttle = {
      description =
        "Linux shell script for throttling system CPU frequency based on a desired maximum temperature";
      wantedBy = [ "basic.target" ];
      serviceConfig.ExecStart =
        "${cfg.package}/bin/temp-throttle -c ${configFile}";
    };
  };
}
