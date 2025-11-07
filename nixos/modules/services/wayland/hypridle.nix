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
    enable = lib.mkEnableOption "hypridle, Hyprland's idle daemon";
    package = lib.mkPackageOption pkgs "hypridle" { };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd = {
      packages = [ cfg.package ];
      user.services.hypridle.wantedBy = [ "graphical-session.target" ];
      user.services.hypridle.path = [
        config.programs.hyprland.package
        config.programs.hyprlock.package
        pkgs.procps
      ];
    };
  };

  meta.maintainers = lib.teams.hyprland.members;
}
