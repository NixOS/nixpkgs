{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.todesk;
in
{
  options = {
    services.todesk.enable = lib.mkEnableOption "ToDesk daemon";
    services.todesk.package = lib.mkPackageOption pkgs "todesk" { };
  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = [ cfg.package ];

    systemd.services.todeskd = {
      description = "ToDesk Daemon Service";

      wantedBy = [ "multi-user.target" ];
      wants = [
        "network-online.target"
        "display-manager.service"
        "nss-lookup.target"
      ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${cfg.package}/bin/todesk service";
        ExecReload = "${pkgs.coreutils}/bin/kill -SIGINT $MAINPID";
        Restart = "on-failure";
        WorkingDirectory = "/var/lib/todesk";
        PrivateTmp = true;
        StateDirectory = "todesk";
        StateDirectoryMode = "0777"; # Desktop application read and write /opt/todesk/config/config.ini. Such a pain!
        ProtectSystem = "strict";
        ProtectHome = "read-only";
        RemoveIPC = "yes";
      };
    };
  };
}
