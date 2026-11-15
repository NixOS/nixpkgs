{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.turnstone;
  settingsFormat = pkgs.formats.toml { };
  jsonFormat = pkgs.formats.json { };

  stateDir = "/var/lib/turnstone";
  consoleStateDir = "/var/lib/turnstone-console";

  # systemd LoadCredential entries for secrets. systemd reads each secret as
  # root at unit start and re-exposes it read-only under $CREDENTIALS_DIRECTORY,
  # so source files do not need to be readable by the `turnstone` user and never
  # enter the Nix store.
  mkLoadCredentials =
    {
      isServer ? false,
    }:
    lib.optional (cfg.jwtSecretFile != null) "jwt-secret:${toString cfg.jwtSecretFile}"
    ++ lib.optional (
      cfg.mcpEncryptionKeyFile != null
    ) "mcp-encryption-key:${toString cfg.mcpEncryptionKeyFile}"
    ++ lib.optional (
      cfg.oidcClientSecretFile != null
    ) "oidc-client-secret:${toString cfg.oidcClientSecretFile}"
    ++ lib.optionals isServer (
      lib.optional (
        cfg.server.openrouterKeyFile != null
      ) "openrouter-key:${toString cfg.server.openrouterKeyFile}"
    );

  # Build replace-secret lines for secrets that must be substituted in config.toml
  # at runtime (such as mcp_token_encryption_key).
  mkReplaceSecretLines =
    { target }:
    lib.optionalString (cfg.mcpEncryptionKeyFile != null) ''
      ${lib.getExe pkgs.replace-secret} '@MCP_ENCRYPTION_KEY@' "$CREDENTIALS_DIRECTORY/mcp-encryption-key" ${target}
    '';

  # Compute the effective database URL for PostgreSQL
  effectivePgUrl =
    if cfg.database.url != null then
      cfg.database.url
    else if cfg.database.createLocally then
      "postgresql:///${cfg.database.name}?host=/run/postgresql"
    else
      null;

  # Shared database section for bootstrap TOML
  databaseSettings = lib.filterAttrsRecursive (_: v: v != null) {
    backend = cfg.database.backend;
    url = if cfg.database.backend == "postgresql" then effectivePgUrl else null;
    path = if cfg.database.backend == "sqlite" then cfg.database.path else null;
    pool_size = cfg.database.poolSize;
  };

  # Shared systemd hardening for server and console services.
  sharedServiceConfig = {
    Type = "simple";
    Restart = "on-failure";
    RestartSec = 5;

    NoNewPrivileges = true;
    PrivateTmp = true;
    ProtectSystem = "strict";
    ProtectHome = true;
    PrivateDevices = true;
    ProtectKernelTunables = true;
    ProtectKernelModules = true;
    ProtectKernelLogs = true;
    ProtectClock = true;
    ProtectHostname = true;
    ProtectControlGroups = true;
    RestrictNamespaces = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    LockPersonality = true;
    UMask = "0077";
    ProtectProc = "invisible";
    ProcSubset = "pid";
    PrivateUsers = true;
    RemoveIPC = true;
    # Python runtime / ctypes needs writable+executable memory mappings.
    MemoryDenyWriteExecute = false;
    SystemCallArchitectures = "native";
    SystemCallFilter = [
      "@system-service"
      "~@privileged"
      "~@resources"
      "~@mount"
    ];
    CapabilityBoundingSet = "";
    AmbientCapabilities = "";
    RestrictAddressFamilies = [
      "AF_INET"
      "AF_INET6"
      "AF_UNIX"
    ];
  };

in
{
  meta.maintainers = [ lib.maintainers.timvherpen ];
  meta.doc = ./turnstone.md;

  options.services.turnstone = {
    package = lib.mkPackageOption pkgs "turnstone" { };

    # ── Secrets (shared by server and console) ───────────────────────

    jwtSecretFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Path to a file containing the JWT secret for authentication. Loaded via
        systemd `LoadCredential`; the file need not be readable by the
        `turnstone` user. Its contents never enter the Nix store.
      '';
    };

    mcpEncryptionKeyFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Path to a file containing the MCP token encryption key. Loaded via
        systemd `LoadCredential`. Its contents never enter the Nix store.
      '';
    };

    oidcClientSecretFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Path to a file containing the OIDC client secret. Exposed to the service
        via systemd `LoadCredential`.
      '';
    };

    # ── Logging (shared defaults, per-component override) ────────────

    logLevel = lib.mkOption {
      type = lib.types.enum [
        "DEBUG"
        "INFO"
        "WARNING"
        "ERROR"
      ];
      default = "INFO";
      description = "Default log level for both server and console.";
    };

    logFormat = lib.mkOption {
      type = lib.types.enum [
        "auto"
        "json"
        "text"
      ];
      default = "auto";
      description = "Default log output format for both server and console.";
    };

    # ── Firewall ─────────────────────────────────────────────────────

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to open the firewall for the server and/or console ports.
        The services bind to `127.0.0.1` by default, so this is only useful
        when binding to a public interface; most deployments should rely on a
        reverse proxy instead.
      '';
    };

    # ── Database (Deployment-level shared storage) ───────────────────

    database = {
      backend = lib.mkOption {
        type = lib.types.enum [
          "postgresql"
          "sqlite"
        ];
        default = "postgresql";
        description = "Database backend for Turnstone persistence (shared by server and console).";
      };

      createLocally = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Automatically provision local PostgreSQL database and connect via
          the Unix socket (peer auth, no password). Ignored when the backend is
          sqlite. When disabled, the connection URL must be provided via
          `services.turnstone.database.url` or an environment variable.
        '';
      };

      name = lib.mkOption {
        type = lib.types.str;
        default = "turnstone";
        description = "PostgreSQL database name.";
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "turnstone";
        description = "PostgreSQL user name.";
      };

      url = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          PostgreSQL connection URL. Required when backend is postgresql and
          `createLocally` is false, unless supplied via an environment variable.
        '';
      };

      path = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = "${stateDir}/turnstone.db";
        description = "Path to the SQLite database file.";
      };

      poolSize = lib.mkOption {
        type = lib.types.int;
        default = 5;
        description = "Database connection pool size.";
      };
    };

    # ── Server ───────────────────────────────────────────────────────

    server = {
      enable = lib.mkEnableOption "Turnstone API server";

      host = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = "Address to bind the server to (written to config.toml).";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 8080;
        description = "Port the API server listens on (written to config.toml).";
      };

      logLevel = lib.mkOption {
        type = lib.types.enum [
          "DEBUG"
          "INFO"
          "WARNING"
          "ERROR"
        ];
        default = "INFO";
        description = "Log level for the server.";
      };

      logFormat = lib.mkOption {
        type = lib.types.enum [
          "auto"
          "json"
          "text"
        ];
        default = "auto";
        description = "Log format for the server.";
      };

      openrouterKeyFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = ''
          Path to a file containing the OpenRouter API key. Loaded via systemd
          `LoadCredential`.
        '';
      };

      environmentFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "Path to an EnvironmentFile loaded by the systemd service. Useful for providing secrets.";
      };

      mcpServers = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.submodule {
            options = {
              command = lib.mkOption {
                type = lib.types.str;
                description = "Command to launch the MCP server.";
              };
              args = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [ ];
                description = "Arguments passed to the MCP server command.";
              };
              env = lib.mkOption {
                type = lib.types.attrsOf lib.types.str;
                default = { };
                description = ''
                  Environment variables for the MCP server process. These are
                  written to `mcp.json`, which lives in the world-readable Nix
                  store, so do not place secrets here — provide them at runtime
                  via `environmentFile` instead.
                '';
              };
            };
          }
        );
        default = { };
        description = "MCP server definitions included in mcp.json.";
      };

      extraBootstrapSettings = lib.mkOption {
        type = settingsFormat.type;
        default = { };
        description = "Additional bootstrap settings written to server config.toml.";
      };
    };

    # ── Console ──────────────────────────────────────────────────────

    console = {
      enable = lib.mkEnableOption "Turnstone Console (admin dashboard)";

      host = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = "Address to bind the console to (written to console-config.toml).";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 8090;
        description = "Port the console dashboard listens on (written to console-config.toml).";
      };

      logLevel = lib.mkOption {
        type = lib.types.enum [
          "DEBUG"
          "INFO"
          "WARNING"
          "ERROR"
        ];
        default = "INFO";
        description = "Log level for the console.";
      };

      logFormat = lib.mkOption {
        type = lib.types.enum [
          "auto"
          "json"
          "text"
        ];
        default = "auto";
        description = "Log format for the console.";
      };

      environmentFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "Path to an EnvironmentFile loaded by the systemd service. Useful for providing secrets.";
      };

      extraBootstrapSettings = lib.mkOption {
        type = settingsFormat.type;
        default = { };
        description = "Additional bootstrap settings written to console-config.toml.";
      };
    };
  };

  config = lib.mkMerge [
    # ── Log level/format inheritance ─────────────────────────────────
    (lib.mkIf cfg.server.enable {
      services.turnstone.server.logLevel = lib.mkDefault cfg.logLevel;
      services.turnstone.server.logFormat = lib.mkDefault cfg.logFormat;
    })
    (lib.mkIf cfg.console.enable {
      services.turnstone.console.logLevel = lib.mkDefault cfg.logLevel;
      services.turnstone.console.logFormat = lib.mkDefault cfg.logFormat;
    })

    # ── Assertions ─────────────────────────────────────────────────
    (lib.mkIf (cfg.server.enable || cfg.console.enable) {
      assertions = [
        {
          assertion = cfg.database.backend != "sqlite" || cfg.database.path != null;
          message = "services.turnstone.database.path is required when using the SQLite backend.";
        }
        {
          assertion = !(cfg.server.enable && cfg.console.enable && cfg.server.port == cfg.console.port && cfg.server.host == cfg.console.host);
          message = "services.turnstone: server and console cannot bind to the same host and port.";
        }
      ];

      warnings =
        lib.optional
          (
            cfg.database.backend == "postgresql"
            && cfg.database.url == null
            && !cfg.database.createLocally
          )
          "services.turnstone: PostgreSQL backend is selected but no database.url is set and database.createLocally is false. Provide the connection URL via services.turnstone.database.url or an environment file."
        ++
          lib.optional
            (
              cfg.database.backend == "postgresql"
              && cfg.database.url != null
              && cfg.database.createLocally
            )
            "services.turnstone: a custom database.url is set but database.createLocally is also true. The locally provisioned database will be created but not used.";
    })

    # ── PostgreSQL auto-provisioning ───────────────────────────────
    (lib.mkIf (cfg.database.createLocally && cfg.database.backend == "postgresql" && (cfg.server.enable || cfg.console.enable)) {
      assertions = [
        {
          assertion = cfg.database.user == cfg.database.name;
          message = "services.turnstone.database.user must equal database.name when database.createLocally is true for peer authentication.";
        }
      ];
      services.postgresql = {
        enable = true;
        ensureDatabases = [ cfg.database.name ];
        ensureUsers = [
          {
            name = cfg.database.user;
            ensureDBOwnership = true;
          }
        ];
      };
    })

    # ── User / group ───────────────────────────────────────────────
    (lib.mkIf (cfg.server.enable || cfg.console.enable) {
      users.users.turnstone = {
        isSystemUser = true;
        group = "turnstone";
        home = stateDir;
      };
      users.groups.turnstone = { };
    })

    # ── Firewall ───────────────────────────────────────────────────
    (lib.mkIf cfg.openFirewall {
      networking.firewall.allowedTCPPorts =
        lib.optional cfg.server.enable cfg.server.port ++ lib.optional cfg.console.enable cfg.console.port;
    })

    # ── Server service ─────────────────────────────────────────────
    (lib.mkIf cfg.server.enable {
      systemd.services.turnstone-server =
        let
          mcpConfigFile = jsonFormat.generate "mcp.json" {
            mcpServers = lib.mapAttrs (_: srv: {
              inherit (srv) command args env;
            }) cfg.server.mcpServers;
          };

          serverSettings = lib.recursiveUpdate {
            server = {
              inherit (cfg.server) host port;
            };
            database = databaseSettings;
            security = lib.optionalAttrs (cfg.mcpEncryptionKeyFile != null) {
              mcp_token_encryption_key = "@MCP_ENCRYPTION_KEY@";
            };
          } cfg.server.extraBootstrapSettings;

          serverConfigFile = settingsFormat.generate "turnstone-server-config.toml" serverSettings;

          setupScript = pkgs.writeShellScript "turnstone-server-setup" ''
            set -euo pipefail
            install -m 0600 ${serverConfigFile} ${stateDir}/config.toml
            ${mkReplaceSecretLines { target = "${stateDir}/config.toml"; }}
          '';
        in
        {
          description = "Turnstone AI Server";
          after = [
            "network.target"
          ]
          ++ lib.optional (
            cfg.database.backend == "postgresql" && cfg.database.createLocally
          ) "postgresql.service";
          requires = lib.optional (
            cfg.database.backend == "postgresql" && cfg.database.createLocally
          ) "postgresql.service";
          wantedBy = [ "multi-user.target" ];

          serviceConfig = sharedServiceConfig // {
            User = "turnstone";
            Group = "turnstone";
            StateDirectory = "turnstone";
            WorkingDirectory = stateDir;
            LoadCredential = mkLoadCredentials { isServer = true; };
            ExecStartPre = [ "${setupScript}" ];
            EnvironmentFile = lib.optional (cfg.server.environmentFile != null) cfg.server.environmentFile;
          };

          script = ''
            set -euo pipefail
            ${lib.optionalString (cfg.jwtSecretFile != null) ''
              export TURNSTONE_JWT_SECRET="$(cat "$CREDENTIALS_DIRECTORY/jwt-secret")"
            ''}
            ${lib.optionalString (cfg.oidcClientSecretFile != null) ''
              export TURNSTONE_OIDC_CLIENT_SECRET="$(cat "$CREDENTIALS_DIRECTORY/oidc-client-secret")"
            ''}
            ${lib.optionalString (cfg.server.openrouterKeyFile != null) ''
              export OPENROUTER_API_KEY="$(cat "$CREDENTIALS_DIRECTORY/openrouter-key")"
            ''}
            exec ${lib.getExe' cfg.package "turnstone-server"} ${
              lib.escapeShellArgs (
                [
                  "--config"
                  "${stateDir}/config.toml"
                  "--log-level"
                  cfg.server.logLevel
                  "--log-format"
                  cfg.server.logFormat
                ]
                ++ lib.optionals (cfg.server.mcpServers != { }) [
                  "--mcp-config"
                  (toString mcpConfigFile)
                ]
              )
            }
          '';
        };
    })

    # ── Console service ────────────────────────────────────────────
    (lib.mkIf cfg.console.enable {
      systemd.services.turnstone-console =
        let
          consoleSettings = lib.recursiveUpdate {
            console = {
              inherit (cfg.console) host port;
            };
            database = databaseSettings;
          } cfg.console.extraBootstrapSettings;

          consoleConfigFile = settingsFormat.generate "turnstone-console-config.toml" consoleSettings;

          setupScript = pkgs.writeShellScript "turnstone-console-setup" ''
            set -euo pipefail
            install -m 0600 ${consoleConfigFile} ${consoleStateDir}/console-config.toml
          '';
        in
        {
          description = "Turnstone Console (Admin Dashboard)";
          after = [
            "network.target"
          ]
          ++ lib.optional (
            cfg.database.backend == "postgresql" && cfg.database.createLocally
          ) "postgresql.service";
          requires = lib.optional (
            cfg.database.backend == "postgresql" && cfg.database.createLocally
          ) "postgresql.service";
          wantedBy = [ "multi-user.target" ];

          serviceConfig = sharedServiceConfig // {
            User = "turnstone";
            Group = "turnstone";
            StateDirectory = "turnstone-console";
            WorkingDirectory = consoleStateDir;
            LoadCredential = mkLoadCredentials { isServer = false; };
            ExecStartPre = [ "${setupScript}" ];
            EnvironmentFile = lib.optional (cfg.console.environmentFile != null) cfg.console.environmentFile;
          };

          script = ''
            set -euo pipefail
            ${lib.optionalString (cfg.jwtSecretFile != null) ''
              export TURNSTONE_JWT_SECRET="$(cat "$CREDENTIALS_DIRECTORY/jwt-secret")"
            ''}
            ${lib.optionalString (cfg.oidcClientSecretFile != null) ''
              export TURNSTONE_OIDC_CLIENT_SECRET="$(cat "$CREDENTIALS_DIRECTORY/oidc-client-secret")"
            ''}
            exec ${lib.getExe' cfg.package "turnstone-console"} ${
              lib.escapeShellArgs [
                "--config"
                "${consoleStateDir}/console-config.toml"
                "--log-level"
                cfg.console.logLevel
                "--log-format"
                cfg.console.logFormat
              ]
            }
          '';
        };
    })
  ];
}
