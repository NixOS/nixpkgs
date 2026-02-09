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
  };

  config = lib.mkIf cfg.enable {
    users.users.microsoft-identity-broker = {
      group = "microsoft-identity-broker";
      isSystemUser = true;
    };

    users.groups.microsoft-identity-broker = { };
    environment.systemPackages = [
      pkgs.microsoft-identity-broker
      pkgs.intune-portal
    ];
    systemd.packages = [
      pkgs.microsoft-identity-broker
      pkgs.intune-portal
    ];

    systemd.tmpfiles.packages = [ pkgs.intune-portal ];
    services.dbus.packages = [ pkgs.microsoft-identity-broker ];

    systemd.services.microsoft-identity-device-broker.wantedBy = [ "multi-user.target" ];
    systemd.sockets.intune-daemon.wantedBy = [ "sockets.target" ];
    systemd.user.services.microsoft-identity-broker.wantedBy = [ "default.target" ];
    systemd.user.services.intune-agent.wantedBy = [ "default.target" ];
  };

  meta = {
    maintainers = with lib.maintainers; [ rhysmdnz ];
  };
}
