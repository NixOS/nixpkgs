{
  config,
  lib,
  pkgs,
  ...
}:
let

  cfg = config.services.redshift;
  lcfg = config.location;

in
{

  imports = [
    (lib.mkChangedOptionModule [ "services" "redshift" "latitude" ] [ "location" "latitude" ] (
      config:
      let
        value = lib.getAttrFromPath [ "services" "redshift" "latitude" ] config;
      in
      if value == null then
        throw "services.redshift.latitude is set to null, you can remove this"
      else
        builtins.fromJSON value
    ))
    (lib.mkChangedOptionModule [ "services" "redshift" "longitude" ] [ "location" "longitude" ] (
      config:
      let
        value = lib.getAttrFromPath [ "services" "redshift" "longitude" ] config;
      in
      if value == null then
        throw "services.redshift.longitude is set to null, you can remove this"
      else
        builtins.fromJSON value
    ))
    (lib.mkRenamedOptionModule [ "services" "redshift" "provider" ] [ "location" "provider" ])
  ];

  options.services.redshift = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Enable Redshift to change your screen's colour temperature depending on
        the time of day.
      '';
    };

    temperature = {
      day = lib.mkOption {
        type = lib.types.int;
        default = 5500;
        description = ''
          Colour temperature to use during the day, between
          `1000` and `25000` K.
        '';
      };
      night = lib.mkOption {
        type = lib.types.int;
        default = 3700;
        description = ''
          Colour temperature to use at night, between
          `1000` and `25000` K.
        '';
      };
    };

    brightness = {
      day = lib.mkOption {
        type = lib.types.str;
        default = "1";
        description = ''
          Screen brightness to apply during the day,
          between `0.1` and `1.0`.
        '';
      };
      night = lib.mkOption {
        type = lib.types.str;
        default = "1";
        description = ''
          Screen brightness to apply during the night,
          between `0.1` and `1.0`.
        '';
      };
    };

    package = lib.mkPackageOption pkgs "redshift" { };

    executable = lib.mkOption {
      type = lib.types.str;
      default = "/bin/redshift";
      example = "/bin/redshift-gtk";
      description = ''
        Redshift executable to use within the package.
      '';
    };

    extraOptions = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [
        "-v"
        "-m randr"
      ];
      description = ''
        Additional command-line arguments to pass to
        {command}`redshift`.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    # needed so that .desktop files are installed, which geoclue cares about
    environment.systemPackages = [ cfg.package ];

    services.geoclue2.appConfig.redshift = {
      isAllowed = true;
      isSystem = true;
    };

    systemd.user.services.redshift =
      let
        providerString =
          if lcfg.provider == "manual" then
            "${toString lcfg.latitude}:${toString lcfg.longitude}"
          else
            lcfg.provider;
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
