{ config, lib, pkgs, options, ... }:

with lib;

let

  cfg = config.services.redshift;
  lcfg = config.location;
  settingsFormat = pkgs.formats.ini {};

in {

  meta.maintainers = with maintainers; [ thiagokokada ];

  imports = [
    (mkRenamedOptionModule [ "services" "redshift" "provider" ] [ "location" "provider" ])
    (mkRemovedOptionModule [ "services" "redshift" "extraOptions" ] "All Redshift configuration is now available through services.redshift.settings instead.")
  ] ++
  (map (option: mkRenamedOptionModule ([ "services" "redshift" ] ++ option.old) [ "services" "redshift" "settings" "redshift" option.new ]) [
      { old = [ "temperature" "day" ];    new = "temp-day"; }
      { old = [ "temperature" "night" ];  new = "temp-night"; }
      { old = [ "brightness" "day" ];     new = "brightness-day"; }
      { old = [ "brightness" "night" ];   new = "brightness-night"; }
    ]);

  options.services.redshift = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable Redshift to change your screen's colour temperature depending on
        the time of day.

        This module also supports Gammastep, look for
        <literal>services.redshift.package</literal> and
        <literal>services.redshift.executable</literal> options.
      '';
    };

    dawnTime = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "6:00-7:45";
      description = ''
        Set the time interval of dawn manually.

        The times must be specified as HH:MM in 24-hour format.
      '';
    };

    duskTime = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "18:35-20:15";
      description = ''
        Set the time interval of dusk manually.

        The times must be specified as HH:MM in 24-hour format.
      '';
    };

    latitude = mkOption {
      type = types.nullOr types.float;
      default = null;
      example = "0.0";
      description = ''
        Set the current location latitude.

        Keep in mind that latitudes south of Equator (e.g. Australia) are negative numbers.
      '';
    };

    longitude = mkOption {
      type = types.nullOr types.float;
      default = null;
      example = "0.0";
      description = ''
        Set the current location longitude.

        Keep in mind that longitudes west of Greenwich (e.g. the Americas) are negative numbers.
      '';
    };

    useGeoclue = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = ''
        Use Geoclue2 as a location provider for Redshift.
      '';
    };

    package = mkOption {
      type = types.package;
      default = pkgs.redshift;
      defaultText = "pkgs.redshift";
      description = ''
        Redshift derivation to use.

        To use Gammastep, pass <package>gammastep</package>.
      '';
    };

    executable = mkOption {
      type = types.str;
      default = "/bin/redshift";
      example = "/bin/redshift-gtk";
      description = ''
        Redshift executable to use within the package.

        To use Gammastep, pass either <literal>/bin/gammastep</literal>
        or <literal>/bin/gammastep-indicator</literal>.
      '';
    };

    settings = mkOption {
      type = types.submodule ({ options, ... }: {
        freeformType = settingsFormat.type;

        options.redshift = mkOption {
          type = settingsFormat.type.functor.wrapped;
          description = "Main Redshift/Gammastep configuration.";
        };

        # Copy all redshift definitions to general, such that in case of gammastep,
        # which prefers general over redshift, gets both values from general and redshift
        # While the original redshift just gets values from redshift, as it should
        # https://gitlab.com/chinstrap/gammastep/-/commit/1608ed61154cc652b087e85c4ce6125643e76e2f
        config.general = modules.mkAliasAndWrapDefsWithPriority id options.redshift;
      });

      default = {};

      example = literalExample ''
        {
          redshift = {
            temp-day = 5500;
            temp-night = 3700;
            brightness-day = 1.0;
            brightness-night = 0.8;
            fade = 1;
          };
          randr = {
            screen = 0;
          };
        };
      '';

      description = ''
        The configuration to pass to Redshift/Gammastep.

        Available options for Redshift described in
        <citerefentry>
          <refentrytitle>redshift</refentrytitle>
          <manvolnum>1</manvolnum>
        </citerefentry> and for Gammastep in
        <citerefentry>
          <refentrytitle>gammastep</refentrytitle>
          <manvolnum>1</manvolnum>
        </citerefentry>.
      '';
    };
  };

  config = let
    target = if (cfg.settings.redshift.adjustment-method or null) == "drm"
      then "basic.target"
      else "graphical-session.target";
    configFile = settingsFormat.generate "redshift.conf" cfg.settings;
  in mkIf cfg.enable {
    # needed so that .desktop files are installed, which geoclue cares about
    environment.systemPackages = [ cfg.package ];

    location.provider = mkIf cfg.useGeoclue "geoclue2";

    services.geoclue2.appConfig.redshift = mkIf cfg.useGeoclue {
      isAllowed = true;
      isSystem = true;
    };

    assertions = [
      {
        assertion = (cfg.settings ? redshift.dawn-time) == (cfg.settings ? redshift.dusk-time);
        message = "Time of dawn and time of dusk must be provided together.";
      }
      {
        assertion = (cfg.settings ? redshift.lat) == (cfg.settings ? redshift.lon);
        message = "Latitude and longitude must be provided together.";
      }
      # Only checking for dawn-time or lat because the above two assertions cover the dusk-time/lon.
      {
        assertion = (cfg.settings ? redshift.dawn-time) ||
                    (cfg.settings.redshift.location-provider or "") == "geoclue2" ||
                    ((cfg.settings.redshift.location-provider or "") == "manual" && (cfg.settings ? manual.lat));
        message = ''Either set "redshift.dawnTime" and "redshift.duskTime" OR "redshift.latitude" and "redshift.longitude" OR "redshift.useGeoclue".'' ;
      }
    ];

    services.redshift.settings = {
      redshift = {
        location-provider = if cfg.useGeoclue then "geoclue2" else "manual";
        dawn-time = mkIf (cfg.dawnTime != null) cfg.dawnTime;
        dusk-time = mkIf (cfg.duskTime != null) cfg.duskTime;
      };
      manual = {
        lat = if (lcfg.provider == "manual" && options.location.latitude.isDefined)
              then lcfg.latitude
              else mkIf (cfg.latitude != null) cfg.latitude;
        lon = if (lcfg.provider == "manual" && options.location.longitude.isDefined)
              then lcfg.longitude
              else mkIf (cfg.longitude != null) cfg.longitude;
      };
    };

    systemd.user.services.redshift = {
      description = "Redshift colour temperature adjuster";
      wantedBy = [ target ];
      partOf = [ target ];
      serviceConfig = {
        ExecStart = ''
          ${cfg.package}${cfg.executable} -c ${configFile}
        '';
        RestartSec = 3;
        Restart = "on-failure";
      };
    };
  };
}
