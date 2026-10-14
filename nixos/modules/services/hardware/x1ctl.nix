{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.x1ctl;
in
{
  options.services.x1ctl = {
    enable = lib.mkEnableOption "x1ctl, the control daemon for the Creative Sound Blaster X1";
    package = lib.mkPackageOption pkgs "x1ctl" { };
    tray = lib.mkEnableOption "the x1ctl tray icon in graphical sessions" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    services.udev.packages = [ cfg.package ];
    services.dbus.packages = [ cfg.package ];
    systemd.packages = [ cfg.package ];
    systemd.user.services.x1d.wantedBy = [ "default.target" ];
    systemd.user.services.x1-tray.wantedBy = lib.mkIf cfg.tray [ "graphical-session.target" ];
  };

  meta.maintainers = with lib.maintainers; [ fexiven ];
}
