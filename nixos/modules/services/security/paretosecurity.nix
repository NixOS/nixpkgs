{
  config,
  lib,
  pkgs,
  ...
}:
{

  options.services.paretosecurity = {
    enable = lib.mkEnableOption "[ParetoSecurity](https://paretosecurity.com) [agent](https://github.com/ParetoSecurity/agent) and its root helper";
    package = lib.mkPackageOption pkgs "paretosecurity" { };
  };

  config = lib.mkIf config.services.paretosecurity.enable {
    environment.systemPackages = [ config.services.paretosecurity.package ];

    systemd.sockets."paretosecurity" = {
      wantedBy = [ "sockets.target" ];
      socketConfig = {
        ListenStream = "/var/run/paretosecurity.sock";
        SocketMode = "0666";
      };
    };

    systemd.services."paretosecurity" = {
      serviceConfig = {
        ExecStart = "${config.services.paretosecurity.package}/bin/paretosecurity helper";
        User = "root";
        Group = "root";
        StandardInput = "socket";
        Type = "oneshot";
        RemainAfterExit = "no";
        StartLimitInterval = "1s";
        StartLimitBurst = 100;
        ProtectSystem = "full";
        ProtectHome = true;
        StandardOutput = "journal";
        StandardError = "journal";
      };
    };

  };
}
