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
    package = lib.mkPackageOption pkgs "waybar" { };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    systemd.user.services.waybar = {
      description = "Waybar as systemd service";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      script = "${cfg.package}/bin/waybar";
    };
  };

  meta.maintainers = [ lib.maintainers.FlorianFranzen ];
}
