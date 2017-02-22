{ config, lib, pkgs, ... }:

with lib;

let

  tzdir = "${pkgs.tzdata}/share/zoneinfo";

  timeZone = "/etc/zoneinfo/${config.time.timeZone}";

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

    environment.sessionVariables = {
      # TZ is set to prevent glibc from calling stat() every time localtime() is called,
      # which can be a significant performance problem if /etc is on an NFS filesystem.
      #
      # We point to the /etc/localtime symlink so that we don't have to re-login to pick
      # up a time zone change.
      TZ = ":/etc/localtime";
      TZDIR = "/etc/zoneinfo";
    };

    systemd.globalEnvironment = {
      # See comment above about TZ.
      # Here, we point to the actual time zone file, instead of the /etc/localtime
      # symlink, so that systemd services are restarted automatically when the time
      # zone changes.
      TZ = ":${timeZone}";

      # This way services are restarted when tzdata changes.
      TZDIR = tzdir;
    };

    environment.etc.localtime =
      { source = timeZone;
        mode = "direct-symlink";
      };

    environment.etc.zoneinfo.source = tzdir;

  };

}
