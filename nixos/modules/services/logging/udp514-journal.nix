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
      enable = lib.mkEnableOption "the udp514-journal systemd socket/service";

      openFirewall = lib.mkEnableOption "" // {
        description = "Whether to open the port in the firewall.";
      };

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
      serviceConfig = {
        Type = "notify";
        Restart = "always";
        ExecStart = "${cfg.package}/bin/udp514-journal";
        DynamicUser = "on";
        CapabilityBoundingSet = "";
        AmbientCapabilities = "";
        ProtectSystem = "strict";
        ProtectHome = "on";
        PrivateDevices = "on";
        PrivateTmp = true;
        PrivateUsers = "self";
        PrivateNetwork = "on";
        RestrictAddressFamilies = [ "AF_UNIX" ];
        RestrictNamespaces = true;
        RestrictSUIDSGID = true;
        RestrictRealtime = true;
        LockPersonality = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "~@resources"
        ];
        ProtectClock = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = "on";
        ProtectControlGroups = "strict";
        ProtectProc = "noaccess";
        ProcSubset = "pid";
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        MemoryMax = "5M";
        UMask = "0077";
      };
      confinement = {
        enable = true;
        binSh = null;
      };
    };

    networking.firewall.allowedUDPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];
  };

  meta.maintainers = with lib.maintainers; [ usovalx ];
}
