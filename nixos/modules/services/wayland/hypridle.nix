{
  lib,
  pkgs,
  config,
  ...
}:

let
  cfg = config.services.hypridle;
in
{
  options.services.hypridle = {
    enable = lib.mkEnableOption null // {
      description = ''
        Whether to enable Hypridle, Hyprland's idle daemon.

        ::: {.note}
        For this service to work properly on Hyprland, you
        need to have `programs.hyprland.withUWSM` enabled.
        :::
      '';
    };
    package = lib.mkPackageOption pkgs "hypridle" { };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd.packages = [ cfg.package ];

    systemd.user.services.hypridle = {
      # Service should be only be started on Hyprland
      # this target is started by UWSM
      wantedBy = [ "wayland-session@Hyprland.target" ];

      # Essential package needed for the service to run properly
      path = [
        config.programs.hyprland.package
        config.programs.hyprlock.package
        pkgs.procps
      ];
    };
  };

  meta.maintainers = lib.teams.hyprland.members;
}
