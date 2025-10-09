{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.services.overseerr;
in
{
  meta.maintainers = [ lib.maintainers.jf-uu ];

  options.services.overseerr = {
    enable = lib.mkEnableOption "Overseerr, a request management and media discovery tool for the Plex ecosystem";

    package = lib.mkPackageOption pkgs "overseerr" { };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Open a port in the firewall for the Overseerr web interface.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 5055;
      description = "The port which the Overseerr web UI should listen on.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.overseerr = {
      description = "Request management and media discovery tool for the Plex ecosystem";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = {
        CONFIG_DIRECTORY = "/var/lib/overseerr";
        PORT = toString cfg.port;
      };
      serviceConfig = {
        CapabilityBoundingSet = "";
        DynamicUser = true;
        ExecStart = lib.getExe cfg.package;
        LockPersonality = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateIPC = true;
        PrivateMounts = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RemoveIPC = true;
        Restart = "on-failure";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        StateDirectory = "overseerr";
        StateDirectoryMode = "0700";
        SystemCallArchitectures = "native";
        SystemCallErrorNumber = "EPERM";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "~@resources"
        ];
        Type = "exec";
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };
  };
}
