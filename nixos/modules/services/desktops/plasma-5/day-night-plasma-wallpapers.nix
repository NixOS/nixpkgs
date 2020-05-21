{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.day-night-plasma-wallpapers;
in {

  options.services.day-night-plasma-wallpapers = {
    enable = mkEnableOption "Day-Night Plasma Wallpapers, a software to update your wallpaper according to the day light";

    install = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to install a user service for Day-Night.
      '';
    };

    package = mkOption {
      type = types.package;
      default = pkgs.day-night-plasma-wallpapers;
      defaultText = "pkgs.day-night-plasma-wallpapers";
      description = "Day-night-plasma-wallpapers derivation to use.";
    };

    path = mkOption {
      type = types.listOf types.path;
      default = [];
      example = literalExample "[ pkgs.bash pkgs.day-night-plasma-wallpapers ]";
      description = "List of derivations to put in path.";
    };

    onCalendar = mkOption {
      type = types.str;
      default = "=*-*-* 16:00:00"; # Run at 4 pm everyday (16h)
      description = "When in the evening do you want your wallpaper to go to bed. Default is at 4 pm. See systemd.time(7) for more information about the format.";
    };
  };

  config = mkIf (cfg.enable || cfg.install) {
    systemd.user.services.day-night-plasma-wallpapers = {
      description = "Day-night-plasma-wallpapers: a software to update your wallpaper according to the day light";
      serviceConfig = {
        Type      = "oneshot";
        ExecStart = "${cfg.package}/bin/update-day-night-plasma-wallpapers.sh";
      };
      path = cfg.path;
    };
    environment.systemPackages = [ cfg.package ];
    systemd.user.timers.day-night-plasma-wallpapers = {
      description = "Day-night-plasma-wallpapers timer";
      timerConfig = {
        Unit = "day-night-plasma-wallpapers.service";
        OnCalendar = cfg.onCalendar;
        Persistent = "true";
      };
    };
  };
}
