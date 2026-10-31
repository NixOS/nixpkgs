{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib)
    mkOption
    types
    mkIf
    mkEnableOption
    mkPackageOption
    ;
  cfg = config.services.korrosync;
in
{
  options = {
    services.korrosync = {
      enable = mkEnableOption "KOReader sync server for e-reader synchronisation";

      package = mkPackageOption pkgs "korrosync" { };

      address = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = "Address the server binds to.";
      };

      port = mkOption {
        type = types.port;
        default = 3000;
        description = "Port the server listens on.";
      };

      tls = {
        enable = mkEnableOption "built-in TLS/HTTPS via rustls";

        certPath = mkOption {
          type = types.path;
          default = "/etc/korrosync/tls/cert.pem";
          description = "Path to the TLS certificate file (PEM format).";
        };

        keyPath = mkOption {
          type = types.path;
          default = "/etc/korrosync/tls/key.pem";
          description = "Path to the TLS private key file (PEM format).";
        };
      };

      rateLimit = {
        perSecond = mkOption {
          type = types.ints.positive;
          default = 2;
          description = "Rate limit replenishment rate per second.";
        };

        burstSize = mkOption {
          type = types.ints.positive;
          default = 5;
          description = "Maximum burst size before rate limiting kicks in.";
        };
      };

      extraEnvironment = mkOption {
        type = types.attrsOf types.str;
        default = { };
        description = "Extra environment variables passed to the service verbatim.";
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to open the configured port in the firewall.";
      };
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.port ];

    systemd.services.korrosync = {
      description = "Korrosync - KOReader Sync Server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      environment = {
        KORROSYNC_DB_PATH = "/var/lib/private/korrosync/data.redb";
        KORROSYNC_SERVER_ADDRESS = "${cfg.address}:${toString cfg.port}";
        KORROSYNC_RATE_LIMIT_PER_SECOND = toString cfg.rateLimit.perSecond;
        KORROSYNC_RATE_LIMIT_BURST_SIZE = toString cfg.rateLimit.burstSize;
      }
      // lib.optionalAttrs cfg.tls.enable {
        KORROSYNC_USE_TLS = "true";
        KORROSYNC_CERT_PATH = toString cfg.tls.certPath;
        KORROSYNC_KEY_PATH = toString cfg.tls.keyPath;
      }
      // cfg.extraEnvironment;

      serviceConfig = {
        Type = "simple";
        ExecStart = "${lib.getExe cfg.package} serve";
        DynamicUser = true;
        Restart = "on-failure";
        RestartSec = "5s";

        StateDirectory = "korrosync";

        # Filesystem
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        PrivateMounts = true;
        UMask = "0077";

        # Kernel
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        ProtectHostname = true;
        ProtectClock = true;
        ProtectProc = "invisible";
        ProcSubset = "pid";

        # Privileges
        NoNewPrivileges = true;
        CapabilityBoundingSet = if cfg.port < 1024 then "CAP_NET_BIND_SERVICE" else "";
        RestrictSUIDSGID = true;
        LockPersonality = true;
        RemoveIPC = true;
        KeyringMode = "private";

        # Devices
        PrivateDevices = true;
        DevicePolicy = "closed";

        # Network
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        SocketBindAllow = "tcp:${toString cfg.port}";

        # Syscalls
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "~@resources"
        ];
        SystemCallArchitectures = "native";

        # Other hardening
        MemoryDenyWriteExecute = true;
        RestrictNamespaces = true;
        RestrictRealtime = true;
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ shymega ];
}
