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

    systemd.globalEnvironment.TZDIR = tzdir;

    environment.etc.localtime =
      { source = "${tzdir}/${config.time.timeZone}";
        mode = "direct-symlink";
      };

    environment.etc.timezone.text = config.time.timeZone;

    environment.etc.zoneinfo.source = "${pkgs.tzdata}/share/zoneinfo";

  };

}
