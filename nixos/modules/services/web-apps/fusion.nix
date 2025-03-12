{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.fusion;
in
{
  options.services.fusion = {
    enable = lib.mkEnableOption "Fusion, a lightweight, self-hosted friendly RSS aggregator and reader";

    host = lib.mkOption {
      type = lib.types.str;
      default = "0.0.0.0";
      example = "[::1]";
      description = "The address that Fusion should listen on.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8080;
      description = "The port that Fusion should listen on.";
    };

    passwordFile = lib.mkOption {
      type = lib.types.path;
      example = "/run/keys/fusion-password";
      description = ''
        A file containing the password for the Fusion web interface.

        This should be a path pointing to a file within a secure directory and NEVER
        in the Nix store (which is world-readable)!
      '';
    };

    tls = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.submodule {
          options = {
            cert = lib.mkOption {
              type = lib.types.path;
              description = "Path to TLS certificate";
            };
            key = lib.mkOption {
              type = lib.types.path;
              description = "Path to TLS key";
            };
          };
        }
      );
      default = null;
      description = ''
        The paths to the TLS certificate and key files for Fusion.

        If these options are set, then Fusion can only be accessed through a secure
        TLS connection. If you are using a reverse proxy like Nginx to handle HTTPS,
        please leave these unset.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.fusion = {
      description = "Fusion, a lightweight, self-hosted friendly RSS aggregator and reader";

      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];

      environment = {
        HOST = cfg.host;
        PORT = toString cfg.port;
        DB = "/var/lib/fusion/sqlite.db";

        TLS_CERT = lib.mkIf (cfg.tls != null) cfg.tls.cert;
        TLS_KEY = lib.mkIf (cfg.tls != null) cfg.tls.key;
      };

      script = ''
        export PASSWORD=$(cat $CREDENTIALS_DIRECTORY/fusion)
        ${lib.getExe pkgs.fusion}
      '';

      serviceConfig = {
        DynamicUser = true;
        User = "fusion";
        LoadCredential = "fusion:${cfg.passwordFile}";
        Restart = "on-failure";
        TimeoutStopSec = 300;

        # Hardening
        WorkingDirectory = "/var/lib/fusion";
        StateDirectory = "fusion";
        RuntimeDirectory = "fusion";
        RootDirectory = "/run/fusion";
        RootDirectoryStartOnly = true;

        BindReadOnlyPaths =
          [ builtins.storeDir ]
          ++ lib.optionals (cfg.tls != null) [
            cfg.tls.cert
            cfg.tls.key
          ];

        ProtectClock = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        ProtectKernelModules = true;
        ProtectHostname = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectHome = true;
        ProcSubset = "pid";

        PrivateTmp = true;
        PrivateNetwork = false;
        PrivateUsers = cfg.port >= 1024;
        PrivateDevices = true;

        RestrictRealtime = true;
        RestrictNamespaces = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];

        MemoryDenyWriteExecute = true;
        LockPersonality = true;
        AmbientCapabilities = lib.optional (cfg.port < 1024) "CAP_NET_BIND_SERVICE";
        CapabilityBoundingSet = "";
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@resources"
          "~@privileged"
          "setrlimit"
        ];
        UMask = "0066";
      };
    };
  };
}
