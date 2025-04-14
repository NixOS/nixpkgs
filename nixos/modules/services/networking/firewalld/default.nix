{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.firewalld;
in
{
  options.services.firewalld = {
    enable = lib.mkEnableOption "FirewallD";
    package = lib.mkPackageOption pkgs "firewalld" { };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    services.dbus.packages = [ cfg.package ];
  };

  meta.maintainers = with lib.maintainers; [ prince213 ];
}
