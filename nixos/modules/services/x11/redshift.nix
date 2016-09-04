{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.redshift;

in {

  options.services.redshift = {
    enable = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = ''
        Enable Redshift to change your screen's colour temperature depending on
        the time of day.
      '';
    };

    latitude = mkOption {
      type = types.str;
      description = ''
        Your current latitude, between
        <literal>-90.0</literal> and <literal>90.0</literal>.
      '';
    };

    longitude = mkOption {
      type = types.str;
      description = ''
        Your current longitude, between
        between <literal>-180.0</literal> and <literal>180.0</literal>.
      '';
    };

    temperature = {
      day = mkOption {
        type = types.int;
        default = 5500;
        description = ''
          Colour temperature to use during the day, between
          <literal>1000</literal> and <literal>25000</literal> K.
        '';
      };
      night = mkOption {
        type = types.int;
        default = 3700;
        description = ''
          Colour temperature to use at night, between
          <literal>1000</literal> and <literal>25000</literal> K.
        '';
      };
    };

    brightness = {
      day = mkOption {
        type = types.str;
        default = "1";
        description = ''
          Screen brightness to apply during the day,
          between <literal>0.1</literal> and <literal>1.0</literal>.
        '';
      };
      night = mkOption {
        type = types.str;
        default = "1";
        description = ''
          Screen brightness to apply during the night,
          between <literal>0.1</literal> and <literal>1.0</literal>.
        '';
      };
    };

    package = mkOption {
      type = types.package;
      default = pkgs.redshift;
      defaultText = "pkgs.redshift";
      description = ''
        redshift derivation to use.
      '';
    };

    extraOptions = mkOption {
      type = types.listOf types.str;
      default = [];
      example = [ "-v" "-m randr" ];
      description = ''
        Additional command-line arguments to pass to
        <command>redshift</command>.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services.redshift = {
      description = "Redshift colour temperature adjuster";
      wantedBy = [ "default.target" ];
      serviceConfig = {
        ExecStart = ''
          ${cfg.package}/bin/redshift \
            -l ${cfg.latitude}:${cfg.longitude} \
            -t ${toString cfg.temperature.day}:${toString cfg.temperature.night} \
            -b ${toString cfg.brightness.day}:${toString cfg.brightness.night} \
            ${lib.strings.concatStringsSep " " cfg.extraOptions}
        '';
        RestartSec = 3;
        Restart = "always";
      };
      environment = {
        DISPLAY = ":${toString (
          let display = config.services.xserver.display;
          in if display != null then display else 0
        )}";
      };
    };
  };

}
