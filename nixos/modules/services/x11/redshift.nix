{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.redshift;
  lcfg = config.location;
  isGeoclue2 = lcfg.provider == "geoclue2";
  isManual = lcfg.provider == "manual";

in {

  imports = [
    (mkChangedOptionModule [ "services" "redshift" "latitude" ] [ "location" "latitude" ]
      (config:
        let value = getAttrFromPath [ "services" "redshift" "latitude" ] config;
        in if value == null then
          throw "services.redshift.latitude is set to null, you can remove this"
          else builtins.fromJSON value))
    (mkChangedOptionModule [ "services" "redshift" "longitude" ] [ "location" "longitude" ]
      (config:
        let value = getAttrFromPath [ "services" "redshift" "longitude" ] config;
        in if value == null then
          throw "services.redshift.longitude is set to null, you can remove this"
          else builtins.fromJSON value))
    (mkRenamedOptionModule [ "services" "redshift" "provider" ] [ "location" "provider" ])
    (mkRenamedOptionModule [ "services" "redshift" "extraOptions" ] [ "services" "redshift" "extraConfig" ])
  ];

  options.services.redshift = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable Redshift to change your screen's colour temperature depending on
        the time of day.
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
        type = types.float;
        default = 1.0;
        description = ''
          Screen brightness to apply during the day,
          between <literal>0.1</literal> and <literal>1.0</literal>.
        '';
      };
      night = mkOption {
        type = types.float;
        default = 1.0;
        description = ''
          Screen brightness to apply during the night,
          between <literal>0.1</literal> and <literal>1.0</literal>.
        '';
      };
    };

    gamma = {
      day = mkOption {
        type = with types; either float str;
        default = 1.0;
        description = ''
          Screen gamma to apply during the day,
          between <literal>0.1</literal> and <literal>1.0</literal>.

          It is also possible to set screen gamma for each color channel
          individually, using <literal>"0.8:0.7:0.8"</literal>.
        '';
      };
      night = mkOption {
        type = with types; either float str;
        default = 1.0;
        description = ''
          Screen gamma to apply during the night,
          between <literal>0.1</literal> and <literal>1.0</literal>.

          It is also possible to set screen gamma for each color channel
          individually, using <literal>"0.8:0.7:0.8"</literal>.
        '';
      };
    };

    fade = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Disable the smooth fade between temperatures when Redshift starts and stops.
      '';
    };

    package = mkOption {
      type = types.package;
      default = pkgs.redshift;
      defaultText = "pkgs.redshift";
      description = ''
        redshift derivation to use.
      '';
    };

    executable = mkOption {
      type = types.str;
      default = "/bin/redshift";
      example = "/bin/redshift-gtk";
      description = ''
        Redshift executable to use within the package.
      '';
    };

    extraConfig = mkOption {
      type = with types; attrsOf (attrsOf (oneOf [float int str]));
      default = {};
      example = {
        redshift = {
          elevation-high = 3;
          elevation-low = -6;
        };
        randr = {
          screen = 0;
        };
      };
      description = ''
        Additional configuration to be appended to <literal>redshift</literal>
        config file.

        Available options described in
        <citerefentry>
          <refentrytitle>redshift</refentrytitle>
          <manvolnum>1</manvolnum>
        </citerefentry>.
      '';
    };
  };

  config = mkIf cfg.enable {
    # needed so that .desktop files are installed, which geoclue cares about
    environment.systemPackages = [ cfg.package ];

    services.geoclue2.appConfig.redshift = mkIf isGeoclue2 {
      isAllowed = true;
      isSystem = true;
    };

    systemd.user.services.redshift =
    let
      mainSection = if strings.hasInfix "gammastep" cfg.executable
        # https://gitlab.com/chinstrap/gammastep/-/commit/1608ed61154cc652b087e85c4ce6125643e76e2f
        then "general"
        else "redshift";

      locationConfig = if isManual
        then {
          manual = {
            lat = lcfg.latitude;
            lon = lcfg.longitude;
          };
        } else {};

      mainConfig = {
        ${mainSection} = {
          temp-day = cfg.temperature.day;
          temp-night = cfg.temperature.night;
          fade = if cfg.fade then "1" else "0";
          location-provider = lcfg.provider;
          brightness-day = cfg.brightness.day;
          brightness-night = cfg.brightness.night;
          gamma-day = cfg.gamma.day;
          gamma-night = cfg.gamma.night;
        };
      };

      fullConfig = mainConfig // locationConfig // cfg.extraConfig;
      iniText = generators.toINI {} fullConfig;
      configFile = pkgs.writeText "redshift.conf" iniText;
    in
    {
      description = "Redshift colour temperature adjuster";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${cfg.package}${cfg.executable} -c ${configFile}";
        RestartSec = 3;
        Restart = "on-failure";
      };
    };
  };

}
