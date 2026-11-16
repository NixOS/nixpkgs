{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.framework-settings;
in
{
  options.programs.framework-settings = {
    enable = lib.mkEnableOption "framework-settings";
    package = lib.mkPackageOption pkgs "framework-settings" { };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    services.dbus.packages = [ cfg.package ];
    security.polkit.enable = true;
    systemd.packages = [ cfg.package ];
    # Reapply write-only hardware settings after reboot.
    systemd.services.frameworkd.wantedBy = [ "multi-user.target" ];
  };
}
