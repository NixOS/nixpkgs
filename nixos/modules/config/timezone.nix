{ config, lib, pkgs, ... }:

with lib;

let

  tzdir = "${pkgs.tzdata}/share/zoneinfo";

in

{
  options = {

    time = {

      timeZone = mkOption {
        default = "UTC";
        type = types.str;
        example = "America/New_York";
        description = ''
          The time zone used when displaying times and dates. See <link
          xlink:href="https://en.wikipedia.org/wiki/List_of_tz_database_time_zones"/>
          for a comprehensive list of possible values for this setting.
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

    environment.etc.localtime =
      { source = "/etc/zoneinfo/${config.time.timeZone}";
        mode = "direct-symlink";
      };

    environment.etc.zoneinfo.source = tzdir;

  };

}
