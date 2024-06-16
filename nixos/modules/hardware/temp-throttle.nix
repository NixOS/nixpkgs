{ config, lib, pkgs, ... }:

let
  cfg = config.services.temp-throttle;
  configFile = let toString = builtins.toString; in
    "MAX_TEMP=${toString cfg.max_temp}\n" +
    lib.optionalString (cfg.interval  != null) "INTERVAL=${toString cfg.interval}\n" +
    lib.optionalString (cfg.temp_file != null) "TEMP_FILE=${cfg.temp_file}\n" +
    lib.optionalString (cfg.core      != null) "CORE=${toString cfg.core}\n" +
    lib.optionalString (cfg.log_file  != null) "LOG_FILE=${cfg.log_file}\n"
  ;
in
{
  options = 
  let
    mkOption = lib.mkOption;
    nullOr = lib.types.nullOr;
    str = lib.types.str;
    int = lib.types.int;
  in
  {
    services.temp-throttle = {
      enable = lib.mkEnableOption "Whether to enable temp-throttle service";
      package = mkOption {
        type = lib.types.package;
        default = pkgs.temp-throttle;
        defaultText = lib.literalExpression "pkgs.temp-throttle";
      };
      max_temp = mkOption {
        type = int;
        default = 80;
        description = "Maximum desired temperature in Celcius";
      };
      interval = mkOption {
        type = nullOr int;
        default = 3;
        description = "Seconds between checking temperature. Default 3";
      };
      temp_file = mkOption {
        type = nullOr str;
        default = null;
        description = "Force read CPU temperature from given file. Default auto detection";
        example = "/sys/class/hwmon/hwmon1/device/temp1_input";
      };
      core = mkOption {
        type = nullOr int;
        default = null;
        description = "Force read frequency from given CPU Core. May be needed for big.little endian. Default 0";
      };
      log_file = mkOption {
        type = nullOr str;
        default = null;
        description = "Log output to given file. Default stdout";
      };
    };
  };
  config = lib.mkIf cfg.enable {
    systemd.services.temp-throttle = {
      description = "Linux shell script for throttling system CPU frequency based on a desired maximum temperature";
      wantedBy = [ "basic.target" ];
      path = [
        pkgs.bash
      ];
      serviceConfig = with builtins; {
        ExecStart = "${cfg.package}/bin/temp-throttle -c " + 
          toFile "temp-throttle.conf" configFile;
        Type = "simple";
      };
    };
  };
}
