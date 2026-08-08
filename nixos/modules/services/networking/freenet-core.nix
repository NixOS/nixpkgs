{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.freenet-core;
  stateDir = "/var/lib/freenet-core";
  configDir = "${stateDir}/config";
  cacheDir = "/var/cache/freenet-core";

  command = [
    (lib.getExe cfg.package)
    "network"
    "--disable-auto-update"
    "--config-dir=${configDir}"
    "--data-dir=${stateDir}"
    "--network-address=${cfg.networkAddress}"
    "--network-port=${toString cfg.networkPort}"
    "--ws-api-address=${cfg.websocketAddress}"
    "--ws-api-port=${toString cfg.websocketPort}"
  ]
  ++ lib.optionals cfg.gateway.enable [
    "--is-gateway"
    "--public-network-address=${cfg.gateway.publicAddress}"
    "--public-network-port=${toString cfg.gateway.publicPort}"
  ]
  ++ cfg.extraArgs;
in
{
  options.services.freenet-core = {
    enable = lib.mkEnableOption "Freenet node";

    package = lib.mkPackageOption pkgs "freenet-core" { };

    networkAddress = lib.mkOption {
      type = lib.types.str;
      default = "::";
      example = "0.0.0.0";
      description = "Address on which the Freenet peer-to-peer transport listens.";
    };

    networkPort = lib.mkOption {
      type = lib.types.port;
      default = 31337;
      example = 31338;
      description = "UDP port on which the Freenet peer-to-peer transport listens.";
    };

    gateway = {
      enable = lib.mkEnableOption "Freenet gateway mode";

      publicAddress = lib.mkOption {
        type = lib.types.str;
        example = "198.51.100.10";
        description = "Publicly reachable address advertised by this gateway.";
      };

      publicPort = lib.mkOption {
        type = lib.types.port;
        default = cfg.networkPort;
        defaultText = lib.literalExpression "config.services.freenet-core.networkPort";
        description = "Publicly reachable UDP port advertised by this gateway.";
      };
    };

    websocketAddress = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      example = "::1";
      description = "Address on which the Freenet HTTP and WebSocket API listens.";
    };

    websocketPort = lib.mkOption {
      type = lib.types.port;
      default = 7509;
      example = 7510;
      description = "TCP port on which the Freenet HTTP and WebSocket API listens.";
    };

    nice = lib.mkOption {
      type = lib.types.ints.between (-20) 19;
      default = 10;
      example = 5;
      description = "Nice level for the Freenet process.";
    };

    environment = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      example = {
        RUST_LOG = "freenet=debug";
      };
      description = "Environment variables passed to the Freenet process.";
    };

    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [
        "--telemetry-enabled"
        "--total-bandwidth-limit=10000000"
      ];
      description = "Additional command-line arguments passed to Freenet.";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
      description = "Whether to open the Freenet peer-to-peer UDP port in the firewall.";
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedUDPPorts = lib.mkIf cfg.openFirewall [ cfg.networkPort ];

    systemd.services.freenet-core = {
      description = "Freenet node";
      documentation = [ "https://freenet.org/" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = {
        FREENET_LOG_TO_STDERR = "1";
        HOME = stateDir;
        XDG_CACHE_HOME = cacheDir;
      }
      // cfg.environment;
      serviceConfig = {
        ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p ${configDir}";
        ExecStart = lib.escapeShellArgs command;
        User = "freenet-core";
        DynamicUser = true;
        StateDirectory = "freenet-core";
        StateDirectoryMode = "0700";
        CacheDirectory = "freenet-core";
        CacheDirectoryMode = "0700";
        WorkingDirectory = stateDir;
        Nice = cfg.nice;
        LimitNOFILE = 65536;
        UMask = "0077";
        Restart = "on-failure";
        # Exit 42 also signals a fatal listener failure and must remain restartable.
        RestartPreventExitStatus = [ 43 ];
        RestartSec = 10;
        TimeoutStopSec = 45;

        CapabilityBoundingSet = "";
        LockPersonality = true;
        # Freenet JIT-compiles WebAssembly contracts.
        MemoryDenyWriteExecute = false;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        PrivateUsers = true;
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
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [ "@system-service" ];
      };
    };
  };

  meta.maintainers = [ lib.maintainers.LisaScheers ];
  meta.doc = ./freenet-core.md;
}
