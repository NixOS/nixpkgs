{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.teamviewer;
in
{
  options = {
    services.teamviewer = {
      enable = lib.mkEnableOption "TeamViewer daemon & system package";
      package = lib.mkPackageOption pkgs "teamviewer" { };
    };
  };

  config = lib.mkIf (cfg.enable) {
    environment.systemPackages = [ cfg.package ];

    services.dbus.packages = [ cfg.package ];

    systemd.services.teamviewerd = {
      description = "TeamViewer remote control daemon";

      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [
        "network-online.target"
        "network.target"
        "dbus.service"
      ];
      requires = [ "dbus.service" ];
      preStart = "mkdir -pv /var/lib/teamviewer /var/log/teamviewer";

      startLimitIntervalSec = 60;
      startLimitBurst = 10;
      serviceConfig = {
        Type = "simple";
        ExecStart = "${cfg.package}/bin/teamviewerd -f";
        PIDFile = "/run/teamviewerd.pid";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        Restart = "on-abort";
      };
    };
  };
}
