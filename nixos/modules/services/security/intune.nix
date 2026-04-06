{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.intune;
in
{
  options.services.intune = {
    enable = lib.mkEnableOption "Microsoft Intune";
    intune-portal.package = lib.mkPackageOption pkgs "intune-portal" { };
    microsoft-identity-broker.package = lib.mkPackageOption pkgs "microsoft-identity-broker" { };
  };

  config = lib.mkIf cfg.enable {
    users.users.microsoft-identity-broker = {
      group = "microsoft-identity-broker";
      isSystemUser = true;
    };

    users.groups.microsoft-identity-broker = { };
    environment.systemPackages = [
      cfg.intune-portal.package
      cfg.microsoft-identity-broker.package
    ];
    systemd.packages = [
      cfg.microsoft-identity-broker.package
      cfg.intune-portal.package
    ];

    systemd.tmpfiles.packages = [ cfg.intune-portal.package ];
    services.dbus.packages = [ cfg.microsoft-identity-broker.package ];
  };

  meta = {
    maintainers = with lib.maintainers; [ rhysmdnz ];
  };
}
