{
  config,
  lib,
  pkgs,
}:
let
  cfg = config.services.happd;
in
{
  options.services.happd = {
    enable = lib.mkEnableOption "happd, Happ Process Control Daemon";
    package = lib.mkPackageOption pkgs "happ" { };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd.services.happd = {
      description = "Happ Control Process Daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        User = "root";
        Group = "root";
        ExecStart = "${cfg.package}/bin/happd";
        Restart = "on-failure";
        RestartSec = 5;
        NoNewPrivileges = false;
        TimeoutStopSec = 10;
        KillMode = "mixed";
        KillSignal = "SIGTERM";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ nekitdev ];
}
