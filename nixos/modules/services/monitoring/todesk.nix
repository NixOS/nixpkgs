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
    services.todesk.enable = lib.mkEnableOption "ToDesk daemon" // {
      description = ''
        Whether to enable the ToDesk daemon.

        This is also needed by the graphical client in `pkgs.todesk`: its
        wrapper bind-mounts `/var/lib/todesk` into the FHS environment, and
        this module is what creates that directory, through the service's
        systemd `StateDirectory`. Without it the client does not start:

        ```
        bwrap: Can't find source path /var/lib/todesk: No such file or directory
        ```
      '';
    };
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
        LogsDirectory = "todesk"; # The daemon writes its own logs to /var/log/todesk, which ProtectSystem would otherwise deny.
        ProtectSystem = "strict";
        ProtectHome = "read-only";
        RemoveIPC = "yes";
      };
    };
  };
}
