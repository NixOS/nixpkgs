{pkgs, config, ...}:

let

  options = {

    time.timeZone = pkgs.lib.mkOption {
      default = "CET";
      example = "America/New_York";
      description = "The time zone used when displaying times and dates.";
    };

  };

in

{
  require = [options];

  environment.shellInit =
    ''
      export TZ=${config.time.timeZone}
      export TZDIR=${pkgs.glibc}/share/zoneinfo
    '';
}
