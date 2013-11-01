{ config, pkgs, ... }:
with pkgs.lib;
let
  cfg = config.services.redshift;

in {
  options = {
    services.redshift.enable = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = "Enable Redshift to change your screen's colour temperature depending on the time of day";
    };

    services.redshift.latitude = mkOption {
      description = "Your current latitude";
      type = types.string;
    };

    services.redshift.longitude = mkOption {
      description = "Your current longitude";
      type = types.string;
    };

    services.redshift.temperature = {
      day = mkOption {
        description = "Colour temperature to use during day time";
        default = 5500;
        type = types.int;
      };
      night = mkOption {
        description = "Colour temperature to use during night time";
        default = 3700;
        type = types.int;
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.redshift = {
      description = "Redshift colour temperature adjuster";
      requires = [ "display-manager.service" ];
      script = ''
        ${pkgs.redshift}/bin/redshift \
          -l ${cfg.latitude}:${cfg.longitude} \
          -t ${toString cfg.temperature.day}:${toString cfg.temperature.night}
      '';
      environment = { DISPLAY = ":0"; };
    };
  };
}
