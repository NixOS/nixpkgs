{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.teamviewer;

in

{

  ###### interface

  options = {

    services.teamviewer.enable = mkEnableOption (lib.mdDoc "TeamViewer daemon");

  };

  ###### implementation

  config = mkIf (cfg.enable) {

    environment.systemPackages = [ pkgs.teamviewer ];

    services.dbus.packages = [ pkgs.teamviewer ];

    systemd.services.teamviewerd = {
      description = "TeamViewer remote control daemon";

      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" "network.target" "dbus.service" ];
      requires = [ "dbus.service" ];
      preStart = "mkdir -pv /var/lib/teamviewer /var/log/teamviewer";

      startLimitIntervalSec = 60;
      startLimitBurst = 10;
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.teamviewer}/bin/teamviewerd -f";
        PIDFile = "/run/teamviewerd.pid";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        Restart = "on-abort";
      };
    };
  };

}
