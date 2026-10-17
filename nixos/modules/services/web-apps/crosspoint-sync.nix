{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.crosspoint-sync;

  stateDir = "/var/lib/crosspoint-sync";
  databaseDir = builtins.dirOf cfg.settings.DATABASE_PATH;

  environment = lib.mapAttrs (
    _: value: if lib.isBool value then lib.boolToString value else toString value
  ) (lib.filterAttrs (_: value: value != null) cfg.settings);
in

{
  meta.maintainers = with lib.maintainers; [ notthebee ];

  options.services.crosspoint-sync = {
    enable = lib.mkEnableOption "crosspoint-sync, a KOSync-compatible sync server for CrossPoint and KOReader e-readers";

    package = lib.mkPackageOption pkgs "crosspoint-sync" { };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to open the firewall for [](#opt-services.crosspoint-sync.settings.PORT).";
    };

    settings = lib.mkOption {
      description = ''
        Environment variables used to configure crosspoint-sync.
        See <https://github.com/crosspoint-reader/crosspoint-sync#configuration> for the full list.

        Secrets such as `TOKEN_ENC_KEY` do not belong here, as they would end up
        world-readable in the Nix store; use
        [](#opt-services.crosspoint-sync.environmentFiles) instead.
      '';
      example = {
        REGISTRATION_DISABLED = true;
        CORS_ORIGINS = "https://reader.example.com";
      };

      type = lib.types.submodule {
        freeformType =
          with lib.types;
          attrsOf (
            nullOr (oneOf [
              str
              int
              bool
            ])
          );

        options = {
          PORT = lib.mkOption {
            type = lib.types.port;
            default = 8080;
            description = "Port to listen on.";
          };

          DATABASE_PATH = lib.mkOption {
            type = lib.types.path;
            default = "${stateDir}/crosspoint.db";
            description = ''
              Path of the SQLite database. Missing parent directories are
              created on startup. When pointing this outside of
              `${stateDir}`, the directory is made writable for the service
              automatically.
            '';
          };

          REGISTRATION_DISABLED = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = ''
              Whether to refuse new account registrations. Enable this on a
              private instance once your accounts exist.
            '';
          };

          AUTH_RATE_LIMIT_PER_MINUTE = lib.mkOption {
            type = lib.types.ints.unsigned;
            default = 30;
            description = "Per-IP registration attempts allowed per minute. Set to `0` to disable rate limiting.";
          };

          TRUST_PROXY = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = ''
              Whether to trust the `X-Forwarded-Proto` header of an incoming
              request. Only enable this when direct access to the service is
              blocked and a reverse proxy in front of it overwrites any
              client-supplied value of that header.
            '';
          };

          CORS_ORIGINS = lib.mkOption {
            type = lib.types.nullOr lib.types.commas;
            default = null;
            example = "https://reader.example.com,https://notes.example.com";
            description = ''
              Comma-separated list of origins allowed to call the sync API from
              a browser. `null` allows any origin, which is safe because the
              API authenticates with headers rather than cookies.
            '';
          };
        };
      };
    };

    environmentFiles = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [ ];
      example = [ "/run/secrets/crosspoint-sync.env" ];
      description = ''
        Files to load environment variables from, in addition to
        [](#opt-services.crosspoint-sync.settings). Use this to keep secrets
        out of the Nix store, most notably `TOKEN_ENC_KEY`, which enables the
        external service connectors and encrypts the stored connector
        credentials at rest.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.crosspoint-sync = {
      description = "KOSync-compatible sync server for CrossPoint and KOReader e-readers";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];

      inherit environment;

      serviceConfig = {
        ExecStart = lib.getExe cfg.package;
        Restart = "on-failure";

        DynamicUser = true;
        StateDirectory = "crosspoint-sync";
        WorkingDirectory = stateDir;
        EnvironmentFile = cfg.environmentFiles;
        ReadWritePaths = lib.optional (!lib.hasPrefix stateDir databaseDir) databaseDir;

        # hardening
        AmbientCapabilities = "";
        CapabilityBoundingSet = [ "" ];
        DevicePolicy = "closed";
        LockPersonality = true;
        # V8 needs to write to executable memory pages for its JIT.
        MemoryDenyWriteExecute = false;
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
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SocketBindAllow = "tcp:${toString cfg.settings.PORT}";
        SocketBindDeny = "any";
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service @pkey"
          "~@privileged @resources"
        ];
        UMask = "0077";
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.settings.PORT ];
    };
  };
}
