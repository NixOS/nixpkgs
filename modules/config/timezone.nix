{ config, pkgs, ... }:

with pkgs.lib;

{
  options = {

    time.timeZone = mkOption {
      default = "CET";
      type = with types; uniq string;
      example = "America/New_York";
      description = "The time zone used when displaying times and dates.";
    };

  };

  config = {

    environment.shellInit =
      ''
        export TZ=${config.time.timeZone}
        export TZDIR=${pkgs.glibc}/share/zoneinfo
      '';

    environment.etc = singleton
      { source = "${pkgs.glibc}/share/zoneinfo/${config.time.timeZone}";
        target = "localtime";
      };
      
  };
  
}
