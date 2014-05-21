{ config, lib, pkgs, ... }:

with lib;

let

  tzdir = "${pkgs.tzdata}/share/zoneinfo";

in

{
  options = {

    time = {

      timeZone = mkOption {
        default = "CET";
        type = types.str;
        example = "America/New_York";
        description = "The time zone used when displaying times and dates.";
      };

      hardwareClockInLocalTime = mkOption {
        default = false;
        description = "If set, keep the hardware clock in local time instead of UTC.";
      };

    };
  };

  config = {

    environment.variables.TZDIR = "/etc/zoneinfo";

    systemd.globalEnvironment.TZDIR = tzdir;

    environment.etc.localtime =
      { source = "${tzdir}/${config.time.timeZone}";
        mode = "direct-symlink";
      };

    environment.etc.zoneinfo.source = "${pkgs.tzdata}/share/zoneinfo";

  };

}
