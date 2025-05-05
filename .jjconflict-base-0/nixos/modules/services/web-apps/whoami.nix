{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.whoami;
in

{
  meta.maintainers = with lib.maintainers; [ defelo ];

  options.services.whoami = {
    enable = lib.mkEnableOption "whoami";

    package = lib.mkPackageOption pkgs "whoami" { };

    port = lib.mkOption {
      type = lib.types.port;
      description = "The port whoami should listen on.";
      default = 8000;
    };

    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "Extra command line arguments to pass to whoami. See <https://github.com/traefik/whoami#flags> for details.";
      default = [ ];
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.whoami = {
      wantedBy = [ "multi-user.target" ];

      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];

      serviceConfig = {
        User = "whoami";
        Group = "whoami";
        DynamicUser = true;
        ExecStart = lib.escapeShellArgs (
          [
            (lib.getExe cfg.package)
            "-port"
            cfg.port
          ]
          ++ cfg.extraArgs
        );

        # Hardening
        AmbientCapabilities = "";
        CapabilityBoundingSet = [ "" ];
        DevicePolicy = "closed";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
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
        RestrictAddressFamilies = [ "AF_INET AF_INET6" ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SocketBindAllow = "tcp:${toString cfg.port}";
        SocketBindDeny = "any";
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "~@resources"
        ];
        UMask = "0077";
      };
    };
  };
}
