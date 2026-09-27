{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.happier-server;
  inherit (lib)
    getExe
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    optional
    optionalString
    types
    ;

  envFormat = pkgs.formats.keyValue { };
  dataDir = "/var/lib/${cfg.stateDirectory}";
  filesDir = "${dataDir}/files";
  dbDir = "${dataDir}/db";
  migrationsDir = "${cfg.package}/lib/happier-server/prisma/sqlite/migrations";
  nodeModulesDir = "${cfg.package}/lib/happier-server/node_modules";
  prismaEngine = "${cfg.package}/lib/happier-server/generated/sqlite-client/${
    if pkgs.stdenv.hostPlatform.isAarch64 then
      "libquery_engine-linux-arm64-openssl-3.0.x.so.node"
    else
      "libquery_engine-debian-openssl-3.0.x.so.node"
  }";
  settingsFile = envFormat.generate "happier-server-env" (
    {
      PORT = toString cfg.port;
      HAPPIER_SERVER_HOST = cfg.host;
      METRICS_ENABLED = false;
      HAPPIER_DB_PROVIDER = "sqlite";
      DATABASE_URL = "file:${dbDir}/happier-server-light.sqlite";
      HAPPIER_FILES_BACKEND = "local";
      NODE_PATH = nodeModulesDir;
      PRISMA_CLIENT_ENGINE_TYPE = "library";
      PRISMA_QUERY_ENGINE_LIBRARY = prismaEngine;
      HAPPIER_SQLITE_AUTO_MIGRATE = true;
      HAPPIER_SQLITE_MIGRATIONS_DIR = migrationsDir;
      HAPPIER_SERVER_LIGHT_DATA_DIR = dataDir;
      HAPPIER_SERVER_LIGHT_FILES_DIR = filesDir;
      HAPPIER_SERVER_LIGHT_DB_DIR = dbDir;
    }
    // cfg.environment
  );
in
{
  meta.maintainers = with lib.maintainers; [ imalison ];

  options.services.happier-server = {
    enable = mkEnableOption "Happier relay server";

    package = mkPackageOption pkgs "happier-server" { };

    host = mkOption {
      type = types.str;
      default = "0.0.0.0";
      description = "Address the Happier relay server listens on.";
    };

    port = mkOption {
      type = types.port;
      default = 3000;
      description = "Port the Happier relay server listens on.";
    };

    stateDirectory = mkOption {
      type = types.str;
      default = "happier-server";
      description = ''
        State directory managed by systemd under `/var/lib`.
      '';
    };

    masterSecretFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/run/secrets/happier-server/master-secret";
      description = ''
        File containing `HANDY_MASTER_SECRET`. The service loads this through systemd credentials.
      '';
    };

    environment = mkOption {
      type = types.attrsOf (
        types.oneOf [
          types.str
          types.int
          types.bool
        ]
      );
      default = { };
      example = {
        HAPPIER_PUBLIC_SERVER_URL = "https://happier.example.com";
      };
      description = ''
        Environment variables passed to the Happier relay server.
        This is written to the Nix store, so secrets should go in
        `environmentFile` or `masterSecretFile`.
      '';
    };

    environmentFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/run/secrets/happier-server/env";
      description = ''
        Environment file loaded by systemd. Use this for secrets and deployment-specific settings.
      '';
    };

    extraArgs = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Additional command-line arguments passed to `happier-server`.";
    };
  };

  config = mkIf cfg.enable {
    warnings = optional (cfg.masterSecretFile == null) ''
      `services.happier-server.masterSecretFile` is not set. Upstream self-hosting examples require `HANDY_MASTER_SECRET`; set it with `masterSecretFile` or provide it through `environmentFile`.
    '';

    systemd.services.happier-server = {
      description = "Happier relay server";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      restartTriggers = [
        cfg.package
        settingsFile
      ];

      preStart = ''
        mkdir -p "$HAPPIER_SERVER_LIGHT_FILES_DIR" "$HAPPIER_SERVER_LIGHT_DB_DIR"
      '';

      script = ''
        ${optionalString (cfg.masterSecretFile != null) ''
          export HANDY_MASTER_SECRET="$(${pkgs.systemd}/bin/systemd-creds cat HANDY_MASTER_SECRET)"
        ''}
        exec ${getExe cfg.package} ${lib.escapeShellArgs cfg.extraArgs}
      '';

      serviceConfig = {
        DynamicUser = true;
        EnvironmentFile = [ settingsFile ] ++ optional (cfg.environmentFile != null) cfg.environmentFile;
        LoadCredential = optional (
          cfg.masterSecretFile != null
        ) "HANDY_MASTER_SECRET:${cfg.masterSecretFile}";
        StateDirectory = cfg.stateDirectory;
        StateDirectoryMode = "0700";
        WorkingDirectory = dataDir;
        Restart = "on-failure";

        CapabilityBoundingSet = "";
        LockPersonality = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
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
        SystemCallArchitectures = "native";
        SystemCallFilter = "~@clock @cpu-emulation @debug @module @mount @obsolete @privileged @raw-io @reboot @resources @swap";
        UMask = "0077";
      };
    };
  };
}
