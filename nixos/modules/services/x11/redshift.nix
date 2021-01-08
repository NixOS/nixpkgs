{ config, lib, pkgs, options, ... }:

with lib;

let

  cfg = config.services.redshift;
  lcfg = config.location;
  settingsFormat = pkgs.formats.ini {};
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

    services.geoclue2.appConfig.redshift = mkIf isGeoclue2 {
      isAllowed = true;
      isSystem = true;
    };

    assertions = [
      {
        assertion = (cfg.settings ? redshift.dawn-time) == (cfg.settings ? redshift.dusk-time);
        message = "Time of dawn and time of dusk must be provided together.";
      }
    ];

    services.redshift.settings = {
      redshift.location-provider = lcfg.provider;
      manual = mkIf isManual {
        lat = lcfg.latitude;
        lon = lcfg.longitude;
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
