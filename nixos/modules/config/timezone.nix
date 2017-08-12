{ config, lib, pkgs, ... }:

with lib;

let

  tzdir = "${pkgs.tzdata}/share/zoneinfo";

in

{
  options = {

    time = {

      timeZone = mkOption {
        default = null;
        type = types.nullOr types.str;
        example = "America/New_York";
        description = ''
          The time zone used when displaying times and dates. See <link
          xlink:href="https://en.wikipedia.org/wiki/List_of_tz_database_time_zones"/>
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
  };

  config = {

    environment.sessionVariables.TZDIR = "/etc/zoneinfo";

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
