{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.rosec;
in
{
  options.services.rosec = {
    enable = lib.mkEnableOption "rosec, a secrets daemon implementing the freedesktop.org Secret Service API";

    package = lib.mkPackageOption pkgs "rosec" { };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    services.dbus.packages = [ cfg.package ];

    systemd.packages = [ cfg.package ];

    xdg.portal.extraPortals = [ cfg.package ];
  };

  meta.maintainers = with lib.maintainers; [ mikilio ];
}
