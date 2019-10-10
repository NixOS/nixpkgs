{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.fancontrol;
  configFile = pkgs.writeText "fancontrol" cfg.config;

in
{
  options = {
    services.fancontrol = {
      enable = mkEnableOption "<literal>fancontrol</literal> service";

      config = mkOption {
        default = "";
        type = types.str;
        description = "fancontrol configuration content. Use pwmconfig from package lm-sensors to generate it.";
        example = ''
          INTERVAL=10
          DEVPATH=hwmon3=devices/virtual/thermal/thermal_zone2 hwmon4=devices/platform/f71882fg.656
          DEVNAME=hwmon3=soc_dts1 hwmon4=f71869a
          FCTEMPS=hwmon4/device/pwm1=hwmon3/temp1_input
          FCFANS= hwmon4/device/pwm1=hwmon4/device/fan1_input
          MINTEMP=hwmon4/device/pwm1=35
          MAXTEMP=hwmon4/device/pwm1=65
          MINSTART=hwmon4/device/pwm1=150
          MINSTOP=hwmon4/device/pwm1=0
        '';
      };
    };
  };

  config = mkIf (cfg.enable && cfg.config != "") {
    systemd.services.fancontrol = {
      unitConfig.Documentation = "man:fancontrol(8)";
      description = "Automated software-based fan speed regulation";
      wantedBy = [ "multi-user.target" ];
      after = [ "lm_sensors.service" ];

      serviceConfig = {
        PIDFile = "/run/fancontrol.pid";
        ExecStart = "${pkgs.lm_sensors}/sbin/fancontrol ${configFile}";
      };
    };
  };
}
