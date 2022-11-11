{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.redshift;
  lcfg = config.location;

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
  ];

  options.services.redshift = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Enable Redshift to change your screen's colour temperature depending on
        the time of day.
      '';
    };

    temperature = {
      day = mkOption {
        type = types.int;
        default = 5500;
        description = lib.mdDoc ''
          Colour temperature to use during the day, between
          `1000` and `25000` K.
        '';
      };
      night = mkOption {
        type = types.int;
        default = 3700;
        description = lib.mdDoc ''
          Colour temperature to use at night, between
          `1000` and `25000` K.
        '';
      };
    };

    brightness = {
      day = mkOption {
        type = types.str;
        default = "1";
        description = lib.mdDoc ''
          Screen brightness to apply during the day,
          between `0.1` and `1.0`.
        '';
      };
      night = mkOption {
        type = types.str;
        default = "1";
        description = lib.mdDoc ''
          Screen brightness to apply during the night,
          between `0.1` and `1.0`.
        '';
      };
    };

    package = mkOption {
      type = types.package;
      default = pkgs.redshift;
      defaultText = literalExpression "pkgs.redshift";
      description = lib.mdDoc ''
        redshift derivation to use.
      '';
    };

    executable = mkOption {
      type = types.str;
      default = "/bin/redshift";
      example = "/bin/redshift-gtk";
      description = lib.mdDoc ''
        Redshift executable to use within the package.
      '';
    };

    extraOptions = mkOption {
      type = types.listOf types.str;
      default = [];
      example = [ "-v" "-m randr" ];
      description = lib.mdDoc ''
        Additional command-line arguments to pass to
        {command}`redshift`.
      '';
    };
  };

  config = mkIf cfg.enable {
    # needed so that .desktop files are installed, which geoclue cares about
    environment.systemPackages = [ cfg.package ];

    services.geoclue2.appConfig.redshift = {
      isAllowed = true;
      isSystem = true;
    };

    systemd.user.services.redshift =
    let
      providerString = if lcfg.provider == "manual"
        then "${toString lcfg.latitude}:${toString lcfg.longitude}"
        else lcfg.provider;
    in
    {
      description = "Redshift colour temperature adjuster";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = ''
          ${cfg.package}${cfg.executable} \
            -l ${providerString} \
            -t ${toString cfg.temperature.day}:${toString cfg.temperature.night} \
            -b ${toString cfg.brightness.day}:${toString cfg.brightness.night} \
            ${lib.strings.concatStringsSep " " cfg.extraOptions}
        '';
        RestartSec = 3;
        Restart = "always";
      };
    };
  };

}
