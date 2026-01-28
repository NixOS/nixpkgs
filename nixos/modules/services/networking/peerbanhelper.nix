{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.peerbanhelper;
in
{
  options.services.peerbanhelper = {
    enable = lib.mkEnableOption "PeerBanHelper service";
    package = lib.mkPackageOption pkgs "peerbanhelper" { };

    address = lib.mkOption {
      type = lib.types.str;
      default = "0.0.0.0";
      description = "The address PeerBanHelper will listen on.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 9898;
      description = "The port PeerBanHelper will listen on.";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to open the firewall for the PeerBanHelper port.";
    };

    allowNetworkAdmin = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
      description = ''
        Whether to grant CAP_NET_ADMIN capability to the service.
        This is necessary for features that interact with the system firewall.
      '';
    };

    environment = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      example = {
        PBH_LOGLEVEL = "DEBUG";
        PBH_API_TOKEN = "secret";
      };
      description = ''
        Additional environment variables passed to the service.
      '';
    };

    jvmOptions = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [
        "-XX:+UseZGC"
        "-XX:MaxRAMPercentage=85.0"
      ];
      description = "Options passed to the Java Virtual Machine.";
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];

    systemd.services.peerbanhelper = {
      description = "PeerBanHelper Service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      environment = {
        PBH_DATADIR = "/var/lib/peerbanhelper";
        PBH_CONFIGDIR = "/var/lib/peerbanhelper/config";
        PBH_LOGSDIR = "/var/log/peerbanhelper";
        PBH_PORT = toString cfg.port;
        PBH_SERVERADDRESS = cfg.address;
        PBH_NOGUI = "true";
        JDK_JAVA_OPTIONS = lib.concatStringsSep " " (
          [ "-Djna.tmpdir=/run/peerbanhelper/jna" ] ++ cfg.jvmOptions
        );
      }
      // cfg.environment;

      serviceConfig =
        let
          needsPrivilegesForPort = cfg.port < 1024;

          capabilities = [
            ""
          ]
          ++ lib.optionals needsPrivilegesForPort [ "CAP_NET_BIND_SERVICE" ]
          ++ lib.optionals cfg.allowNetworkAdmin [ "CAP_NET_ADMIN" ];

          needsAnyPrivileges = needsPrivilegesForPort || cfg.allowNetworkAdmin;
        in
        {
          DynamicUser = true;
          StateDirectory = "peerbanhelper";
          LogDirectory = "peerbanhelper";
          CacheDirectory = "peerbanhelper";
          RuntimeDirectory = "peerbanhelper";
          WorkingDirectory = "/var/lib/peerbanhelper";

          ExecStart = lib.getExe cfg.package;

          CapabilityBoundingSet = capabilities;
          AmbientCapabilities = capabilities;

          SystemCallFilter = [ "@system-service" ];
          SystemCallArchitectures = "native";

          RestrictNamespaces = true;

          PrivateUsers = !needsAnyPrivileges;

          ProtectKernelLogs = true;
          UMask = "0077";
          ProcSubset = "all"; # for stat monitor in panel
          ProtectProc = "invisible";

          MemoryDenyWriteExecute = false; # JIT
          ProtectSystem = "strict";
          ProtectHome = true;
          PrivateTmp = true;
          PrivateDevices = true;
          DevicePolicy = "closed";
          ProtectKernelTunables = true;
          ProtectKernelModules = true;
          ProtectControlGroups = true;
          ProtectHostname = true;
          ProtectClock = true;
          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
            "AF_UNIX"
            "AF_NETLINK"
          ];
          RestrictRealtime = true;
          LockPersonality = true;
          RemoveIPC = true;
          RestrictSUIDSGID = true;
          NoNewPrivileges = true;
        };
    };
  };

  meta = {
    maintainers = with lib.maintainers; [ Misaka13514 ];
  };
}
