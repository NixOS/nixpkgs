{ config, lib, pkgs, ... }:

let
  cfg = config.services.temp-throttle;
  configFile = with builtins;
    "MAX_TEMP=" + toString cfg.max_temp + "\n" +
    (if cfg.interval  != null then "INTERVAL="  + toString cfg.interval + "\n" else "") +
    (if cfg.temp_file != null then "TEMP_FILE=" + cfg.interval          + "\n" else "") +
    (if cfg.core      != null then "CORE="      + toString cfg.core     + "\n" else "") +
    (if cfg.log_file  != null then "LOG_FILE="  + cfg.interval          + "\n" else "")
  ;
in
{
  options = with lib; with lib.types; {
    services.temp-throttle = {
      enable = mkEnableOption "Whether to enable temp-throttle service";
      package = mkOption {
        type = package;
        default = pkgs.temp-throttle;
        defaultText = literalExpression "pkgs.temp-throttle";
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
