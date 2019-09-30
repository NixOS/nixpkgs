{ config, lib, pkgs, options, ... }:

with lib;

let

  cfg = config.services.redshift;
  lcfg = config.location;

  target = if (cfg.settings.redshift.adjustment-method or null) == "drm" then "basic.target" else "graphical-session.target";

  generatedConfig = pkgs.writeText "redshift-generated.conf" (generators.toINI {} cfg.settings);

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
      '';
    };

    settings = mkOption {
      type = with types; attrsOf (attrsOf (nullOr (oneOf [ str float bool int ])));
      default = {};
      description = ''
        The configuration to pass to redshift.
        See <command>man redshift</command> under the section
        CONFIGURATION FILE for options.
      '';
      example = literalExample ''{
        redshift = {
          dawn-time = "05:00-06:00";
          dusk-time = "22:00-23:00";
          temp-night = 3000;
        };
      };'';
      apply = c:
        if !(c ? redshift.dawn-time || c ? redshift.dusk-time) && !(c ? redshift.location-provider) && options.locations.provider.isDefined then
          c // {
            redshift.location-provider = lcfg.provider;
          }
        else
          c;
    };

    configFile = mkOption {
      type = types.path;
      example = "~/.config/redshift/redshift.conf";
      description = ''
        Configuration file for redshift. It is recommended to use the
        <option>settings</option> option instead.
        </para>
        <para>
        Setting this option will override any configuration file auto-generated
        through the <option>settings</option> option.
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

  };

  config = mkIf cfg.enable {
    services.redshift.configFile = mkDefault generatedConfig;

    assertions = mkIf (cfg.configFile == generatedConfig) [ {
        assertion = (cfg.settings ? redshift.dawn-time) == (cfg.settings ? redshift.dusk-time);
        message = "Time of dawn and time of dusk must be provided together.";
    } ];

    services.redshift.settings.manual = {
      lat = mkIf options.location.latitude.isDefined lcfg.latitude;
      lon = mkIf options.location.longitude.isDefined lcfg.longitude;
    };

    # needed so that .desktop files are installed, which geoclue cares about
    environment.systemPackages = [ cfg.package ];

    services.geoclue2.appConfig.redshift = {
      isAllowed = true;
      isSystem = true;
    };

    systemd.user.services.redshift = {
      description = "Redshift colour temperature adjuster";
      wantedBy = [ target ];
      partOf = [ target ];
      serviceConfig = {
        ExecStart = ''
          ${cfg.package}/bin/redshift \
            -c ${cfg.configFile}
        '';
        RestartSec = 3;
        Restart = "always";
      };
    };
  };

}
