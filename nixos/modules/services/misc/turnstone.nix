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

  serverStateDir = "/var/lib/turnstone";
  consoleStateDir = "/var/lib/turnstone-console";

  # Per-model API-key entries that need runtime substitution. Each maps a
  # unique placeholder (keyed by the model alias, so duplicate `model` strings
  # can't collide) to a systemd credential id. The credential id is sanitised
  # to be a valid filename; the placeholder is matched literally by
  # `replace-secret`, so it may contain any characters.
  modelKeyEntries =
    let
      sanitizeCredId =
        s: lib.stringAsChars (c: if lib.match "[a-zA-Z0-9._-]" c != null then c else "_") s;
    in
    lib.mapAttrsToList (alias: model: {
      placeholder = "@MODEL_KEY_${alias}@";
      credId = "model-${sanitizeCredId alias}";
      file = model.apiKeyFile;
    }) (lib.filterAttrs (_: m: m.apiKeyFile != null) cfg.server.models);

  # systemd LoadCredential entries. systemd reads each secret as root at unit
  # start and re-exposes it read-only under $CREDENTIALS_DIRECTORY, so the
  # source files do not need to be readable by the `turnstone` user.
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
      ++ (map (e: "${e.credId}:${toString e.file}") modelKeyEntries)
    );

  # Build the `replace-secret` invocation lines that substitute the
  # @PLACEHOLDER@ tokens in a generated config file. `pkgs.replace-secret`
  # performs a *literal* string replacement (no regex/sed metacharacters) and
  # reads the secret from a file rather than argv, so secrets are never leaked
  # through /proc/<pid>/cmdline and secret values can't inject config.
  mkReplaceSecretLines =
    {
      isServer ? false,
      target,
    }:
    let
      common =
        lib.optional (cfg.mcpEncryptionKeyFile != null)
          "${lib.getExe pkgs.replace-secret} '@MCP_ENCRYPTION_KEY@' \"$CREDENTIALS_DIRECTORY/mcp-encryption-key\" ${target}";
      models = lib.optionals isServer (
        map (
          e:
          "${lib.getExe pkgs.replace-secret} '${e.placeholder}' \"$CREDENTIALS_DIRECTORY/${e.credId}\" ${target}"
        ) modelKeyEntries
      );
    in
    lib.concatLines (common ++ models);

  # Build the full merged settings attrset for a given component.
  # Secrets are injected as @PLACEHOLDER@ markers; the ExecStartPre script
  # substitutes them at runtime so they never land in the Nix store.
  mkMergedSettings =
    {
      settings,
      dbName,
      extraSettings ? { },
    }:
    let
      filtered = lib.filterAttrsRecursive (_: v: v != null) settings;
      # Effective PostgreSQL URL: an explicit value wins; otherwise, when
      # locally provisioning PostgreSQL, default to the Unix socket so peer
      # auth maps the `turnstone` OS user to its role without a password. For
      # non-postgresql backends the URL is dropped. Computing this here (rather
      # than via mkIf on `settings.database.url`) avoids a module-merge
      # infinite recursion, since the body writes into `settings`.
      effectiveUrl =
        if settings.database.backend != "postgresql" then
          null
        else if settings.database.url != null then
          settings.database.url
        else if cfg.database.createLocally then
          "postgresql:///${dbName}?host=/run/postgresql"
        else
          null;
      base = lib.filterAttrsRecursive (_: v: v != null) (
        lib.recursiveUpdate filtered { database.url = effectiveUrl; }
      );
      # extraSettings provides defaults (host, port, models); user `settings`
      # win because they are the second argument to recursiveUpdate.
      withExtra = lib.recursiveUpdate extraSettings base;
      # Only MCP token encryption lives in config.toml's [security] section.
      # The JWT signing secret is NOT read from config.toml — turnstone's
      # load_jwt_secret() reads TURNSTONE_JWT_SECRET (env) first, then
      # [auth] jwt_secret — so it is delivered exclusively via the env var
      # exported in the service script below.
      withSecurity = lib.recursiveUpdate withExtra (
        lib.optionalAttrs (cfg.mcpEncryptionKeyFile != null) {
          security.mcp_token_encryption_key = "@MCP_ENCRYPTION_KEY@";
        }
      );
    in
    withSecurity;

  # Model entries written to the [models] section. API keys are placeholder
  # tokens keyed by the model alias (unique), resolved at runtime.
  modelEntries = lib.mapAttrs (
    alias: model:
    lib.filterAttrs (_: v: v != null) {
      inherit (model) model provider enabled;
      base_url = if model.baseUrl != "" then model.baseUrl else null;
      api_key = if model.apiKeyFile != null then "@MODEL_KEY_${alias}@" else null;
      context_window = model.contextWindow;
      capabilities = model.capabilities;
      temperature = model.temperature;
      max_tokens = model.maxTokens;
      reasoning_effort = model.reasoningEffort;
    }
  ) cfg.server.models;

  # Shared, parameterised settings submodule so server and console stay in
  # sync. Only the default SQLite path differs between the two.
  mkSettingsOption =
    {
      defaultDbPath,
      configFileName,
    }:
    lib.mkOption {
      type = lib.types.submodule {
        freeformType = settingsFormat.type;
        options = {
          database = {
            backend = lib.mkOption {
              type = lib.types.enum [
                "sqlite"
                "postgresql"
              ];
              default = "sqlite";
              description = "Database backend to use.";
            };
            path = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = defaultDbPath;
              description = "Path to the SQLite database file.";
            };
            url = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = ''
                PostgreSQL connection URL. Required when backend is postgresql,
                unless `services.turnstone.database.createLocally` is enabled or
                the URL is supplied to the service via an environment variable.
              '';
            };
            pool_size = lib.mkOption {
              type = lib.types.int;
              default = 5;
              description = "Database connection pool size.";
            };
          };
        };
      };
      default = { };
      description = ''
        Turnstone configuration written to ${configFileName}. Any key accepted
        by Turnstone's TOML config can be set here via the freeform type.
        Secrets must use the dedicated `*File` options instead.
      '';
    };

  # Shared systemd hardening for both server and console services.
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
    # Disabled: the Python runtime needs writable+executable memory.
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

  # Heuristic check for environment-variable names that look like secrets, used
  # to warn when MCP server `env` values would leak into the world-readable store.
  looksSecretish =
    k:
    let
      lk = lib.toLower k;
    in
    lib.hasInfix "secret" lk
    || lib.hasInfix "token" lk
    || lib.hasInfix "password" lk
    || lib.hasInfix "passwd" lk
    || lib.hasInfix "apikey" lk
    || lib.hasInfix "api_key" lk
    || lib.hasSuffix "_key" lk
    || lk == "key";

  leakedMcpKeys = lib.unique (
    lib.flatten (
      lib.mapAttrsToList (
        _n: srv: lib.attrNames (lib.filterAttrs (k: _v: looksSecretish k) srv.env)
      ) cfg.server.mcpServers
    )
  );

  bothComponentsPgLocal =
    cfg.database.createLocally
    && cfg.server.enable
    && cfg.server.settings.database.backend == "postgresql"
    && cfg.console.enable
    && cfg.console.settings.database.backend == "postgresql"
    && cfg.server.database.name == cfg.console.database.name;

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

    # ── Database provisioning ────────────────────────────────────────

    database = {
      createLocally = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Automatically provision local PostgreSQL databases and connect via
          the Unix socket (peer auth, no password). Ignored when the backend is
          sqlite. When disabled, the connection URL must be provided via
          `services.turnstone.<component>.settings.database.url` or an
          environment variable.
        '';
      };
    };

    # ── Server ───────────────────────────────────────────────────────

    server = {
      enable = lib.mkEnableOption "Turnstone API server";

      database = {
        name = lib.mkOption {
          type = lib.types.str;
          default = "turnstone";
          description = "PostgreSQL database name for the server.";
        };
        user = lib.mkOption {
          type = lib.types.str;
          default = "turnstone";
          description = "PostgreSQL user name for the server.";
        };
      };

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
        description = "Path to an EnvironmentFile loaded by the systemd service. Useful for providing secrets. The file is not added to the Nix store.";
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
                  (e.g. via `services.turnstone.server.environmentFile`) instead.
                '';
              };
            };
          }
        );
        default = { };
        description = "MCP server definitions included in mcp.json.";
      };

      models = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.submodule {
            options = {
              model = lib.mkOption {
                type = lib.types.str;
                description = "Upstream model identifier (e.g. `gpt-4o`, `claude-3.5-sonnet`).";
              };
              provider = lib.mkOption {
                type = lib.types.enum [
                  "openai"
                  "anthropic"
                ];
                default = "openai";
                description = "LLM provider backend.";
              };
              baseUrl = lib.mkOption {
                type = lib.types.str;
                default = "";
                description = "Custom API base URL. Leave empty to use the provider default.";
              };
              apiKeyFile = lib.mkOption {
                type = lib.types.nullOr lib.types.path;
                default = null;
                description = ''
                  Path to a file containing the API key for this model. Loaded
                  via systemd `LoadCredential`.
                '';
              };
              contextWindow = lib.mkOption {
                type = lib.types.int;
                default = 131072;
                description = "Maximum context window size in tokens.";
              };
              capabilities = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [ "tool_call" ];
                description = "List of model capabilities (e.g. `tool_call`, `tool_search`).";
              };
              enabled = lib.mkOption {
                type = lib.types.bool;
                default = true;
                description = "Whether this model is active.";
              };
              temperature = lib.mkOption {
                type = lib.types.nullOr lib.types.float;
                default = null;
                description = "Sampling temperature override.";
              };
              maxTokens = lib.mkOption {
                type = lib.types.nullOr lib.types.int;
                default = null;
                description = "Maximum output tokens override.";
              };
              reasoningEffort = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
                description = "Reasoning effort level (provider-specific).";
              };
            };
          }
        );
        default = { };
        description = "Model definitions written to the `[models]` section of config.toml.";
      };

      settings = mkSettingsOption {
        defaultDbPath = "${serverStateDir}/turnstone.db";
        configFileName = "config.toml";
      };
    };

    # ── Console ──────────────────────────────────────────────────────

    console = {
      enable = lib.mkEnableOption "Turnstone Console (admin dashboard)";

      database = {
        name = lib.mkOption {
          type = lib.types.str;
          default = "turnstone-console";
          description = "PostgreSQL database name for the console.";
        };
        user = lib.mkOption {
          type = lib.types.str;
          default = "turnstone-console";
          description = "PostgreSQL user name for the console.";
        };
      };

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
        description = "Path to an EnvironmentFile loaded by the systemd service. Useful for providing secrets. The file is not added to the Nix store.";
      };

      settings = mkSettingsOption {
        defaultDbPath = "${consoleStateDir}/turnstone-console.db";
        configFileName = "console-config.toml";
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
    (lib.mkIf cfg.server.enable {
      assertions = [
        {
          assertion =
            cfg.server.settings.database.backend != "sqlite" || cfg.server.settings.database.path != null;
          message = "services.turnstone.server.settings.database.path is required when using the SQLite backend.";
        }
      ];
    })
    (lib.mkIf cfg.console.enable {
      assertions = [
        {
          assertion =
            cfg.console.settings.database.backend != "sqlite" || cfg.console.settings.database.path != null;
          message = "services.turnstone.console.settings.database.path is required when using the SQLite backend.";
        }
        {
          assertion =
            !(
              cfg.server.enable
              && cfg.console.enable
              && cfg.server.settings.database.backend == "sqlite"
              && cfg.console.settings.database.backend == "sqlite"
              && cfg.server.settings.database.path == cfg.console.settings.database.path
            );
          message = "services.turnstone: server and console must not share the same SQLite database path.";
        }
      ];
    })

    # ── Warnings ───────────────────────────────────────────────────
    (lib.mkIf (cfg.server.enable || cfg.console.enable) {
      warnings =
        lib.optional
          (
            cfg.server.enable
            && cfg.server.settings.database.backend == "postgresql"
            && cfg.server.settings.database.url == null
            && !cfg.database.createLocally
          )
          "services.turnstone.server: PostgreSQL backend is selected but no database.url is set and database.createLocally is false. Provide the connection URL via services.turnstone.server.settings.database.url or an environment file."
        ++
          lib.optional
            (
              cfg.console.enable
              && cfg.console.settings.database.backend == "postgresql"
              && cfg.console.settings.database.url == null
              && !cfg.database.createLocally
            )
            "services.turnstone.console: PostgreSQL backend is selected but no database.url is set and database.createLocally is false. Provide the connection URL via services.turnstone.console.settings.database.url or an environment file."
        ++ lib.optional (cfg.server.enable && leakedMcpKeys != [ ]) (
          "services.turnstone.server.mcpServers: environment keys that look like secrets ("
          + lib.concatStringsSep ", " leakedMcpKeys
          + ") are written to mcp.json in the world-readable Nix store. Provide such values at runtime instead."
        )
        ++
          lib.optional
            (
              cfg.server.enable
              && cfg.server.settings.database.backend == "postgresql"
              && cfg.server.settings.database.url != null
              && cfg.database.createLocally
            )
            "services.turnstone.server: a custom database.url is set but database.createLocally is also true. The locally provisioned database will be created but not used."
        ++
          lib.optional
            (
              cfg.console.enable
              && cfg.console.settings.database.backend == "postgresql"
              && cfg.console.settings.database.url != null
              && cfg.database.createLocally
            )
            "services.turnstone.console: a custom database.url is set but database.createLocally is also true. The locally provisioned database will be created but not used."
        ++ lib.optional bothComponentsPgLocal (
          "services.turnstone: both server and console use PostgreSQL with database.createLocally; they share a single database/user ('"
          + cfg.server.database.name
          + "'). Ensure their schemas are compatible."
        );
    })

    # ── PostgreSQL auto-provisioning ───────────────────────────────
    (lib.mkIf cfg.database.createLocally (
      lib.mkMerge [
        (lib.mkIf (cfg.server.enable && cfg.server.settings.database.backend == "postgresql") {
          assertions = [
            {
              assertion = cfg.server.database.user == cfg.server.database.name;
              message = "services.turnstone.server.database.user must equal database.name when database.createLocally is true.";
            }
          ];
          services.postgresql = {
            enable = true;
            ensureDatabases = [ cfg.server.database.name ];
            ensureUsers = [
              {
                name = cfg.server.database.user;
                ensureDBOwnership = true;
              }
            ];
          };
        })
        (lib.mkIf (cfg.console.enable && cfg.console.settings.database.backend == "postgresql") {
          assertions = [
            {
              assertion = cfg.console.database.user == cfg.console.database.name;
              message = "services.turnstone.console.database.user must equal database.name when database.createLocally is true.";
            }
          ];
          services.postgresql = {
            enable = true;
            ensureDatabases = [ cfg.console.database.name ];
            ensureUsers = [
              {
                name = cfg.console.database.user;
                ensureDBOwnership = true;
              }
            ];
          };
        })
      ]
    ))

    # ── User / group ───────────────────────────────────────────────
    (lib.mkIf cfg.server.enable {
      users.users.turnstone = {
        isSystemUser = true;
        group = "turnstone";
        home = serverStateDir;
      };
      users.groups.turnstone = { };
    })
    (lib.mkIf cfg.console.enable {
      users.users."turnstone-console" = {
        isSystemUser = true;
        group = "turnstone-console";
        home = consoleStateDir;
      };
      users.groups."turnstone-console" = { };
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

          serverSettings = mkMergedSettings {
            settings = cfg.server.settings;
            dbName = cfg.server.database.name;
            extraSettings = {
              server = {
                inherit (cfg.server) host port;
              };
              models = modelEntries;
            };
          };

          serverConfigFile = settingsFormat.generate "turnstone-server-config.toml" serverSettings;

          setupScript = pkgs.writeShellScript "turnstone-server-setup" ''
            set -euo pipefail
            install -m 0600 ${serverConfigFile} ${serverStateDir}/config.toml
            ${mkReplaceSecretLines {
              isServer = true;
              target = "${serverStateDir}/config.toml";
            }}
          '';
        in
        {
          description = "Turnstone AI Server";
          after = [
            "network.target"
          ]
          ++ lib.optional (
            cfg.server.settings.database.backend == "postgresql" && cfg.database.createLocally
          ) "postgresql.service";
          requires = lib.optional (
            cfg.server.settings.database.backend == "postgresql" && cfg.database.createLocally
          ) "postgresql.service";
          wantedBy = [ "multi-user.target" ];

          serviceConfig = sharedServiceConfig // {
            User = "turnstone";
            Group = "turnstone";
            StateDirectory = "turnstone";
            WorkingDirectory = serverStateDir;
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
                  "${serverStateDir}/config.toml"
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
          consoleSettings = mkMergedSettings {
            settings = cfg.console.settings;
            dbName = cfg.console.database.name;
            extraSettings = {
              console = {
                inherit (cfg.console) host port;
              };
            };
          };

          consoleConfigFile = settingsFormat.generate "turnstone-console-config.toml" consoleSettings;

          setupScript = pkgs.writeShellScript "turnstone-console-setup" ''
            set -euo pipefail
            install -m 0600 ${consoleConfigFile} ${consoleStateDir}/console-config.toml
            ${mkReplaceSecretLines {
              isServer = false;
              target = "${consoleStateDir}/console-config.toml";
            }}
          '';
        in
        {
          description = "Turnstone Console (Admin Dashboard)";
          after = [
            "network.target"
          ]
          ++ lib.optional (
            cfg.console.settings.database.backend == "postgresql" && cfg.database.createLocally
          ) "postgresql.service";
          requires = lib.optional (
            cfg.console.settings.database.backend == "postgresql" && cfg.database.createLocally
          ) "postgresql.service";
          wantedBy = [ "multi-user.target" ];

          serviceConfig = sharedServiceConfig // {
            User = "turnstone-console";
            Group = "turnstone-console";
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
