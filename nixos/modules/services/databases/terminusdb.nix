{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.terminusdb;
in
{
  meta.maintainers = with lib.maintainers; [ daniel-fahey ];

  options.services.terminusdb = {
    enable = lib.mkEnableOption "TerminusDB server";

    package = lib.mkPackageOption pkgs "terminusdb" { };

    host = lib.mkOption {
      type = with lib.types; nullOr str;
      default = "127.0.0.1";
      description = ''
        The IP interface to bind to.
        `null` means "all interfaces" (0.0.0.0).
      '';
      example = "0.0.0.0";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 6363;
      description = "The TCP port to accept connections.";
    };

    workers = lib.mkOption {
      type = lib.types.ints.positive;
      default = 8;
      description = "The number of worker threads to use.";
    };

    logLevel = lib.mkOption {
      type = lib.types.enum [
        "error"
        "warn"
        "info"
        "debug"
      ];
      default = "info";
      description = "Log level for TerminusDB server.";
    };

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/terminusdb";
      description = "Directory for TerminusDB data storage.";
    };

    autoInit = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Automatically initialise the TerminusDB store on startup.
        If enabled, the store will be initialised if it does not exist.
      '';
    };

    jwtEnabled = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable JWT authentication.";
    };

    adminPasswordFile = lib.mkOption {
      type = with lib.types; nullOr path;
      default = null;
      description = ''
        Path to a file containing the admin password for store initialisation.
        The password should be stored as a single line in the file.
        If null, a default password will be used.
      '';
      example = "/run/keys/terminusdb-admin-password";
    };

    extraFlags = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
      description = "Extra flags to pass to the TerminusDB server command.";
      example = [ "--interactive" ];
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Open the configured port in the firewall.";
    };

    # Additional environment variable options from TerminusDB source

    logFormat = lib.mkOption {
      type = lib.types.enum [
        "text"
        "json"
      ];
      default = "text";
      description = "Log format for TerminusDB server.";
    };

    fileStoragePath = lib.mkOption {
      type = with lib.types; nullOr path;
      default = null;
      description = "Path for file upload storage. If null, uses default location.";
      example = "/var/lib/terminusdb/files";
    };

    jwksEndpoint = lib.mkOption {
      type = with lib.types; nullOr str;
      default = null;
      description = "JWKS endpoint for JWT verification.";
      example = "https://example.com/.well-known/jwks.json";
    };

    insecureUserHeaderEnabled = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Enable insecure user header authentication.
        WARNING: This should only be used in development/trusted environments.
        The header name is specified by {option}`services.terminusdb.insecureUserHeader`.
      '';
    };

    insecureUserHeader = lib.mkOption {
      type = with lib.types; nullOr str;
      default = null;
      description = ''
        HTTP header name for insecure user authentication.
        Only used when {option}`services.terminusdb.insecureUserHeaderEnabled` is true.
        The header value will be converted to lowercase with dashes replaced by underscores.
      '';
      example = "X-User-Email";
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = lib.optional cfg.openFirewall cfg.port;

    environment.systemPackages = [ cfg.package ];

    users.users.terminusdb = {
      description = "TerminusDB server user";
      isSystemUser = true;
      group = "terminusdb";
    };
    users.groups.terminusdb = { };

    systemd.services.terminusdb = {
      description = "TerminusDB server";

      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      environment = {
        TERMINUSDB_SERVER_NAME = if (cfg.host == null) then "0.0.0.0" else cfg.host;
        TERMINUSDB_SERVER_PORT = toString cfg.port;
        TERMINUSDB_SERVER_WORKERS = toString cfg.workers;
        TERMINUSDB_SERVER_DB_PATH = cfg.dataDir;
        TERMINUSDB_LOG_LEVEL = cfg.logLevel;
        TERMINUSDB_JWT_ENABLED = lib.boolToString cfg.jwtEnabled;
        # Additional environment variables
        TERMINUSDB_LOG_FORMAT = cfg.logFormat;
        TERMINUSDB_FILE_STORAGE_PATH = lib.mkIf (cfg.fileStoragePath != null) cfg.fileStoragePath;
        TERMINUSDB_SERVER_JWKS_ENDPOINT = lib.mkIf (cfg.jwksEndpoint != null) cfg.jwksEndpoint;
        TERMINUSDB_INSECURE_USER_HEADER_ENABLED = lib.boolToString cfg.insecureUserHeaderEnabled;
        TERMINUSDB_INSECURE_USER_HEADER = lib.mkIf (cfg.insecureUserHeader != null) cfg.insecureUserHeader;
      };

      # Auto-initialise the TerminusDB store if it doesn't exist
      preStart = lib.mkIf cfg.autoInit ''
        DATA_DIR="${cfg.dataDir}"
        STORAGE_FLAG="$DATA_DIR/storage/db"

        if [ ! -d "$STORAGE_FLAG" ]; then
          echo "Initialising TerminusDB store at $DATA_DIR..."
          if [ -f "$CREDENTIALS_DIRECTORY/admin-password" ]; then
            ADMIN_PASSWORD=$(cat "$CREDENTIALS_DIRECTORY/admin-password")
            ${lib.getExe cfg.package} store init --key "$ADMIN_PASSWORD" --force
          else
            ${lib.getExe cfg.package} store init --force
          fi
          echo "TerminusDB store initialised successfully."
        else
          echo "TerminusDB store already exists at $DATA_DIR"
        fi
      '';

      serviceConfig = {
        ExecStart = lib.escapeShellArgs (
          [
            (lib.getExe cfg.package)
            "serve"
          ]
          ++ cfg.extraFlags
        );

        User = "terminusdb";
        Group = "terminusdb";

        LoadCredential = lib.optional (
          cfg.adminPasswordFile != null
        ) "admin-password:${cfg.adminPasswordFile}";
        StateDirectory = "terminusdb";
        StateDirectoryMode = "0700";
        WorkingDirectory = cfg.dataDir;

        Type = "exec";

        # Filesystem access
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        PrivateDevices = true;
        ReadWritePaths = [ cfg.dataDir ] ++ lib.optional (cfg.fileStoragePath != null) cfg.fileStoragePath;

        # Process isolation
        NoNewPrivileges = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = false; # Needed for SWI-Prolog JIT compiler

        # Kernel access
        ProtectClock = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectControlGroups = true;

        # Network
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;

        # Syscalls
        SystemCallArchitectures = "native";
        SystemCallFilter = "~@cpu-emulation @debug @keyring @mount @obsolete @privileged @resources @setuid";

        # Capabilities
        CapabilityBoundingSet = "";

        # Additional
        PrivateMounts = true;
        UMask = "0077";
        RestartSec = "5s";
        Restart = "on-failure";
      };
    };
  };
}
