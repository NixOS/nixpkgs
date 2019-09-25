{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.hardware.fancontrol;

in {

  options.hardware.fancontrol = {
    enable = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = "Whether to enable fancontrol (requires a configuration file, see pwmconfig)";
    };

    configFile = mkOption {
      type = types.str;
      default = "/etc/fancontrol";
      example = "/home/user/.config/fancontrol";
      description = "Path to the configuration file, likely generated with pwmconfig.";
    };
  };

  config = mkIf cfg.enable {
    systemd.services.fancontrol = {
      description = "Fan speed control from lm_sensors";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        User = "root";
        ExecStart = "${pkgs.lm_sensors}/bin/fancontrol ${cfg.configFile}";
      };
    };
  };


}
