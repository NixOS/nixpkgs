{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.udp514-journal;
  description = "Forward syslog from network (udp/514) to journal";
in
{
  options = {
    services.udp514-journal = {
      enable = lib.mkEnableOption "udp514-journal systemd socket/service";

      openFirewall = lib.mkEnableOption "Open firewall port";

      port = lib.mkOption {
        type = lib.types.port;
        default = 514;
        description = "Port to listen on";
      };

      package = lib.mkPackageOption pkgs "udp514-journal" { };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.sockets.udp514-journal = {
      enable = true;
      name = "udp514-journal.socket";
      inherit description;
      listenDatagrams = [ (builtins.toString cfg.port) ];
      wantedBy = [ "sockets.target" ];
    };

    systemd.services.udp514-journal = {
      enable = true;
      name = "udp514-journal.service";
      inherit description;
      requires = [
        "systemd-journald.socket"
        "udp514-journal.socket"
      ];
      after = [ "network.target" ];
      serviceConfig = {
        Type = "notify";
        Restart = "always";
        ExecStart = "${cfg.package}/bin/udp514-journal";
        DynamicUser = "on";
        ProtectSystem = "strict";
        ProtectHome = "on";
        PrivateDevices = "on";
        PrivateUsers = "self";
        ProtectKernelTunables = "on";
        ProtectControlGroups = "strict";
        ProtectProc = "noaccess";
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        MemoryMax = "5M";
      };
      wantedBy = [ "multi-user.target" ];
    };

    networking.firewall.allowedUDPPorts = if cfg.openFirewall then [ cfg.port ] else [ ];
  };

  meta.maintainers = with lib.maintainers; [ usovalx ];
}
