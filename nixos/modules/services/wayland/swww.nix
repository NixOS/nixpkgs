{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.services.swww;
in
{
  options.services.swww = {
    enable = lib.mkEnableOption "wallpaper daemon";
    package = lib.mkPackageOption pkgs "swww" { };
  };

  config.systemd.user.services.swww = lib.mkIf cfg.enable {
    enable = true;
    description = "swww wallpaper daemon";
    requires = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];
    unitConfig = {
      ConditionEnvironment = "WAYLAND_DISPLAY";
    };
    script = "${lib.getExe' cfg.package "swww-daemon"}";
  };

  meta.maintainers = with lib.maintainers; [ dtomvan ];
}
