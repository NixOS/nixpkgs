{
  config,
  lib,
  pkgs,
  utils,
  ...
}:
let
  cfg = config.services.qauld;
in
{
  options.services.qauld = {
    enable = lib.mkEnableOption "qauld, a headless qaul mesh community node";

    package = lib.mkPackageOption pkgs "qauld" { };

    openFirewall = lib.mkEnableOption "opening the configured UDP/TCP peer port in the firewall";

    port = lib.mkOption {
      type = lib.types.port;
      default = 9229;
      description = ''
        Port for peer connections (libp2p QUIC/TCP).
        Peers dial with a multiaddr such as `/ip4/<host>/udp/9229/quic-v1`.
      '';
    };

    name = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "My Community Node";
      description = ''
        Display name for the account created on first start.
        If null, qauld generates a name with a timestamp.
      '';
    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/qauld";
      description = ''
        State directory (config.yaml, database, keys, control socket).
        Used as the service working directory.
        Example control client: `qauld-ctl --dir /var/lib/qauld`.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
      allowedUDPPorts = [ cfg.port ];
    };

    systemd.services.qauld = {
      description = "qauld mesh community node";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];

      serviceConfig = {
        Type = "simple";
        ExecStart = utils.escapeSystemdExecArgs (
          [
            (lib.getExe cfg.package)
            "--port"
            (toString cfg.port)
          ]
          ++ lib.optionals (cfg.name != null) [
            "--name"
            cfg.name
          ]
        );
        WorkingDirectory = cfg.dataDir;
        StateDirectory = lib.mkIf (cfg.dataDir == "/var/lib/qauld") "qauld";
        DynamicUser = true;

        AmbientCapabilities = "";
        CapabilityBoundingSet = "";
        DeviceAllow = "";
        LockPersonality = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
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
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
          "AF_NETLINK"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "~@resources"
        ];
        UMask = "0077";
        Restart = "on-failure";
        RestartSec = "5s";
      };
    };
  };

  meta = {
    maintainers = [ lib.maintainers.lucasew ];
    teams = [ lib.teams.ngi ];
  };
}
