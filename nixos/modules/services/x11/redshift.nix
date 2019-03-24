{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.redshift;

in {

  options.services.redshift = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable Redshift to change your screen's colour temperature depending on
        the time of day.
      '';
    };

    latitude = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        Your current latitude, between
        <literal>-90.0</literal> and <literal>90.0</literal>. Must be provided
        along with longitude.
      '';
    };

    longitude = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        Your current longitude, between
        between <literal>-180.0</literal> and <literal>180.0</literal>. Must be
        provided along with latitude.
      '';
    };

    provider = mkOption {
      type = types.enum [ "manual" "geoclue2" ];
      default = "manual";
      description = ''
        The location provider to use for determining your location. If set to
        <literal>manual</literal> you must also provide latitude/longitude.
      '';
    };

    method = mkOption {
      type = types.nullOr (types.enum [ "drm" "randr" "vidmode" "dummy" ]);
      default = null;
      description = ''
        Method to use for making the adjustments.
      '';
    };

    methodOptions = mkOption {
      type = types.attrsOf types.str;
      default = {};
      description = ''
        Additional method specific options to pass to redshift.
      '';
      example = {
        crtc = "0";
      };
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

    fade = mkOption {
      type = types.nullOr types.bool;
      default = null;
      apply = lib.mapNullable (f: if f then 1 else 0);
      description = ''
        Enable fading between color temperatures when redshift
        starts or stops.
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

    extraConfig = mkOption {
      type = types.attrsOf types.string;
      default = {};
      description = ''
        Additional options to append to the [redshift]
        section of the configuration file (see man redshift).
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
    assertions = [ 
      {
        assertion = 
          if cfg.provider == "manual"
          then (cfg.latitude != null && cfg.longitude != null) 
          else (cfg.latitude == null && cfg.longitude == null);
        message = "Latitude and longitude must be provided together, and with provider set to null.";
      }
    ];

    # needed so that .desktop files are installed, which geoclue cares about
    environment.systemPackages = [ cfg.package ];

    services.geoclue2.enable = mkIf (cfg.provider == "geoclue2") true;

    systemd.user.services.redshift = 
    let
      allOptions = {
          redshift = {
            temp-day = cfg.temperature.day;
            temp-night = cfg.temperature.night;
            brightness-day = cfg.brightness.day;
            brightness-night = cfg.brightness.night;
            location-provider = cfg.provider;
            adjustment-method = cfg.method;
            fade = cfg.fade;
          } // cfg.extraConfig;
          manual = {
            lat = cfg.latitude;
            lon = cfg.longitude;
          };
        } // lib.optionalAttrs (!builtins.isNull cfg.method) {
          "${cfg.method}" = cfg.methodOptions;
        };
      configFile = lib.generators.toINI {}
      ( lib.filterAttrsRecursive (n: v: v != null) allOptions );
   in
    {
      description = "Redshift colour temperature adjuster";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = ''
          ${cfg.package}/bin/redshift \
          -c ${builtins.toFile "redshift-config" configFile} \
            ${lib.strings.concatStringsSep " " cfg.extraOptions}
        '';
        RestartSec = 3;
        Restart = "always";
      };
    };
  };

}
