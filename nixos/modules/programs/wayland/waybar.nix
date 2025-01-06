{
  lib,
  pkgs,
  config,
  ...
}:

let
  cfg = config.programs.waybar;
in
{
  options.programs.waybar = {
    enable = lib.mkEnableOption "waybar, a highly customizable Wayland bar for Sway and Wlroots based compositors";
    package =
      lib.mkPackageOption pkgs "waybar" { }
      // lib.mkOption {
        apply = pkg: pkg.override { systemdSupport = true; };
      };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    systemd = {
      packages = [ cfg.package ];
      user.services.waybar.wantedBy = [ "graphical-session.target" ];
    };
  };

  meta.maintainers = [ lib.maintainers.FlorianFranzen ];
}
