{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.dux-calendar;
in
{
  options.programs.dux-calendar = {
    enable = lib.mkEnableOption "Dux Calendar, a standalone calendar application";

    package = lib.mkPackageOption pkgs "dux-calendar" { };

    quickshell.package = lib.mkPackageOption pkgs "quickshell" {
      extraDescription = "The Quickshell package used to run the calendar interface.";
    };

    systemd = {
      enable = lib.mkEnableOption "starting Dux Calendar with the graphical session";

      target = lib.mkOption {
        type = lib.types.str;
        default = "graphical-session.target";
        example = "wayland-session.target";
        description = "The systemd user target that starts Dux Calendar.";
      };

      restartIfChanged = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to restart the Dux Calendar user service when its package or configuration changes.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      cfg.package
      cfg.quickshell.package
    ];

    systemd.packages = lib.mkIf cfg.systemd.enable [ cfg.package ];
    systemd.user.services.dcal = lib.mkIf cfg.systemd.enable {
      wantedBy = [ cfg.systemd.target ];
      restartIfChanged = cfg.systemd.restartIfChanged;
      path = [ cfg.quickshell.package ];
    };
  };

  meta.teams = [ lib.teams.duxlabs ];
}
