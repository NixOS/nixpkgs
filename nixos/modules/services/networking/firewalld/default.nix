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

    systemd.packages = [ cfg.package ];
    systemd.services.firewalld = {
      aliases = [ "dbus-org.fedoraproject.FirewallD1.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig.ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
    };
  };

  meta.maintainers = with lib.maintainers; [ prince213 ];
}
