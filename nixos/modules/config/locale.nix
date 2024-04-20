{ config, lib, pkgs, ... }:

with lib;

let

  tzdir = "${pkgs.tzdata}/share/zoneinfo";
  nospace  = str: filter (c: c == " ") (stringToCharacters str) == [];
  timezone = types.nullOr (types.addCheck types.str nospace)
    // { description = "null or string without spaces"; };

  lcfg = config.location;

in

{
  options = {

    time = {

      timeZone = mkOption {
        default = null;
        type = timezone;
        example = "America/New_York";
        description = ''
          The time zone used when displaying times and dates. See <https://en.wikipedia.org/wiki/List_of_tz_database_time_zones>
          for a comprehensive list of possible values for this setting.

          If null, the timezone will default to UTC and can be set imperatively
          using timedatectl.
        '';
      };

      hardwareClockInLocalTime = mkOption {
        default = false;
        type = types.bool;
        description = "If set, keep the hardware clock in local time instead of UTC.";
      };

    };

    location = {

      latitude = mkOption {
        type = types.float;
        description = ''
          Your current latitude, between
          `-90.0` and `90.0`. Must be provided
          along with longitude.
        '';
      };

      longitude = mkOption {
        type = types.float;
        description = ''
          Your current longitude, between
          between `-180.0` and `180.0`. Must be
          provided along with latitude.
        '';
      };

      provider = mkOption {
        type = types.enum [ "manual" "geoclue2" ];
        default = "manual";
        description = ''
          The location provider to use for determining your location. If set to
          `manual` you must also provide latitude/longitude.
        '';
      };

    };
  };

  config = {

    environment.sessionVariables.TZDIR = "/etc/zoneinfo";

    services.geoclue2.enable = mkIf (lcfg.provider == "geoclue2") true;

    # This way services are restarted when tzdata changes.
    systemd.globalEnvironment.TZDIR = tzdir;

    systemd.services.systemd-timedated.environment = lib.optionalAttrs (config.time.timeZone != null) { NIXOS_STATIC_TIMEZONE = "1"; };

    environment.etc = {
      zoneinfo.source = tzdir;
    } // lib.optionalAttrs (config.time.timeZone != null) {
        localtime.source = "/etc/zoneinfo/${config.time.timeZone}";
        localtime.mode = "direct-symlink";
      };
  };

}
