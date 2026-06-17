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


  # Build the full merged settings attrset for a given component.
  # Secrets are injected as @PLACEHOLDER@ markers; the setup script
  # substitutes them at runtime so they never land in the Nix store.
  mkMergedSettings =
    {
      extraSettings ? { },
    }:
    let
      # Drop the auto-defaulted PostgreSQL URL for non-postgresql backends so
      # config.toml never carries a misleading connection string. Reading the
      # backend here (a plain value, not an mkIf condition on `settings`) avoids
      # the module-merge infinite recursion that gating settings.database.url would cause.
      filtered = lib.filterAttrsRecursive (_: v: v != null) cfg.settings;
      base =
        if cfg.settings.database.backend == "postgresql" then
          filtered
        else
          lib.filterAttrsRecursive (_: v: v != null) (
            lib.recursiveUpdate filtered {
              database.url = null;
            }
          );
      withExtra = lib.recursiveUpdate base extraSettings;
      withSecurity = lib.recursiveUpdate withExtra (
        lib.optionalAttrs (cfg.jwtSecretFile != null || cfg.mcpEncryptionKeyFile != null) {
          security = lib.filterAttrs (_: v: v != null) {
            jwt_secret = if cfg.jwtSecretFile != null then "@JWT_SECRET@" else null;
            mcp_token_encryption_key =
              if cfg.mcpEncryptionKeyFile != null then "@MCP_ENCRYPTION_KEY@" else null;
          };
        }
      );
    in
    withSecurity;

  # Build model entries for inclusion in the TOML config.
  # API keys use placeholders; everything else is inlined.
  modelEntries = lib.mapAttrs (
    _alias: model:
    lib.filterAttrs (_: v: v != null) {
      inherit (model) model provider enabled;
      base_url = if model.baseUrl != "" then model.baseUrl else null;
      api_key = if model.apiKeyFile != null then "@MODEL_KEY_${model.model}@" else null;
      context_window = model.contextWindow;
      capabilities = model.capabilities;
      temperature = model.temperature;
      max_tokens = model.maxTokens;
      reasoning_effort = model.reasoningEffort;
    }
  ) cfg.server.models;

  # Substitute secret placeholders in a TOML file at runtime.
  mkSecretSubstitutionScript =
    configPath:
    let
      sedCmds = lib.concatStringsSep "\n" (
        lib.optional (cfg.jwtSecretFile != null) ''
          secret=$(cat ${cfg.jwtSecretFile})
          ${pkgs.gnused}/bin/sed -i "s|@JWT_SECRET@|$secret|g" ${configPath}
        ''
        ++ lib.optional (cfg.mcpEncryptionKeyFile != null) ''
          secret=$(cat ${cfg.mcpEncryptionKeyFile})
          ${pkgs.gnused}/bin/sed -i "s|@MCP_ENCRYPTION_KEY@|$secret|g" ${configPath}
        ''
        ++ lib.concatLists (
          lib.mapAttrsToList (
            _alias: model:
            lib.optional (model.apiKeyFile != null) ''
              secret=$(cat ${model.apiKeyFile})
              ${pkgs.gnused}/bin/sed -i "s|@MODEL_KEY_${model.model}@|$secret|g" ${configPath}
            ''
          ) cfg.server.models
        )
      );
    in
    sedCmds;

  # Shared systemd hardening for both server and console services.
  sharedServiceConfig = {
    Type = "simple";
    User = "turnstone";
    Group = "turnstone";
    StateDirectory = "turnstone";
    WorkingDirectory = stateDir;
    Restart = "on-failure";
    RestartSec = 5;

    NoNewPrivileges = true;
    PrivateTmp = true;
    ProtectSystem = "strict";
    ProtectHome = true;
    PrivateDevices = true;
    ProtectKernelTunables = true;
    ProtectKernelModules = true;
    ProtectControlGroups = true;
    RestrictNamespaces = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    LockPersonality = true;
    MemoryDenyWriteExecute = false; # Python JIT needs W^X
    SystemCallArchitectures = "native";
    RestrictAddressFamilies = [
      "AF_INET"
      "AF_INET6"
      "AF_UNIX"
    ];
  };

in
{
  meta.maintainers = [ ];

  options.services.turnstone = {
    package = lib.mkPackageOption pkgs "turnstone" {
      default = [ "turnstone" ];
    };

    # ── Shared settings (config.toml) ────────────────────────────────

    settings = lib.mkOption {
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
              default = "${stateDir}/turnstone.db";
              description = "Path to the SQLite database file. Defaults to /var/lib/turnstone/turnstone.db.";
            };
            url = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = "PostgreSQL connection URL. Required when backend is postgresql.";
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
        Shared Turnstone configuration written to config.toml.
        Any key accepted by Turnstone's TOML config can be set here
        via the freeform type. Secrets should use the dedicated
        `*File` options instead.
      '';
    };

    # ── Secrets (shared by server and console) ───────────────────────

    jwtSecretFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Path to a file containing the JWT secret for authentication.
        The contents are injected at runtime and never stored in the
        Nix store.
      '';
    };

    mcpEncryptionKeyFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Path to a file containing the MCP token encryption key.
        The contents are injected at runtime and never stored in the
        Nix store.
      '';
    };

    oidcClientSecretFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Path to a file containing the OIDC client secret.
        The contents are injected via environment variables.
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
      description = "Whether to automatically open the firewall for the server and console ports.";
    };

    # ── Database provisioning ────────────────────────────────────────

    database = {
      createLocally = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Automatically provision a PostgreSQL database. Ignored when backend is sqlite.";
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
    };

    # ── Server ───────────────────────────────────────────────────────

    server = {
      enable = lib.mkEnableOption "Turnstone API server";

      host = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = "Address to bind the server to.";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 8080;
        description = "Port the API server listens on.";
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
        description = "Path to a file containing the OpenRouter API key.";
      };

      environmentFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "Path to an environment file loaded by the systemd service.";
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
                description = "Environment variables for the MCP server process.";
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
                description = "Path to a file containing the API key for this model.";
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
    };

    # ── Console ──────────────────────────────────────────────────────

    console = {
      enable = lib.mkEnableOption "Turnstone Console (admin dashboard)";

      host = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = "Address to bind the console to.";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 8090;
        description = "Port the console dashboard listens on.";
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
          assertion = cfg.settings.database.backend == "sqlite" -> cfg.settings.database.path != null;
          message = "services.turnstone.settings.database.path is required when using the SQLite backend.";
        }
        {
          assertion = cfg.settings.database.backend == "postgresql" -> cfg.settings.database.url != null;
          message = "services.turnstone.settings.database.url is required when using the PostgreSQL backend.";
        }
      ];
    })

    # ── PostgreSQL auto-provisioning ───────────────────────────────
    (lib.mkIf
      (
        (cfg.server.enable || cfg.console.enable)
        && cfg.database.createLocally
        && cfg.settings.database.backend == "postgresql"
      )
      {
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
      }
    )

    # ── PostgreSQL default URL ──────────────────────────────────────
    # Set unconditionally so the postgresql-backend assertion holds by default;
    # mkMergedSettings drops it from config.toml for non-postgresql backends
    # (gating it here with an mkIf on `settings.database.backend` would create a
    # module-merge infinite recursion, since the body writes to `settings`).
    (lib.mkIf (cfg.server.enable || cfg.console.enable) {
      services.turnstone.settings.database.url =
        lib.mkDefault "postgresql://${cfg.database.user}@localhost:5432/${cfg.database.name}";
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

          serverSettings = mkMergedSettings {
            extraSettings = {
              server = {
                host = cfg.server.host;
                port = cfg.server.port;
              };
              mcp.config_path = toString mcpConfigFile;
              models = modelEntries;
            };
          };

          serverConfigFile = settingsFormat.generate "turnstone-server-config.toml" serverSettings;

          setupScript = pkgs.writeShellScript "turnstone-server-setup" ''
            set -euo pipefail
            install -o turnstone -g turnstone -m 600 ${serverConfigFile} ${stateDir}/config.toml
            ${mkSecretSubstitutionScript "${stateDir}/config.toml"}
          '';
        in
        {
          description = "Turnstone AI Server";
          after = [
            "network.target"
          ]
          ++ lib.optional (cfg.settings.database.backend == "postgresql") "postgresql.service";
          requires = lib.optional (cfg.settings.database.backend == "postgresql") "postgresql.service";
          wantedBy = [ "multi-user.target" ];

          serviceConfig = sharedServiceConfig // {
            ExecStartPre = [ "+${setupScript}" ];
            ReadWritePaths = [ stateDir ];
            EnvironmentFile = lib.optional (cfg.server.environmentFile != null) cfg.server.environmentFile;
          };

          script = ''
            ${lib.optionalString (cfg.jwtSecretFile != null) ''
              export TURNSTONE_JWT_SECRET="$(cat ${cfg.jwtSecretFile})"
            ''}
            ${lib.optionalString (cfg.oidcClientSecretFile != null) ''
              export TURNSTONE_OIDC_CLIENT_SECRET="$(cat ${cfg.oidcClientSecretFile})"
            ''}
            ${lib.optionalString (cfg.server.openrouterKeyFile != null) ''
              export OPENROUTER_API_KEY="$(cat ${cfg.server.openrouterKeyFile})"
            ''}
            exec ${lib.getExe' cfg.package "turnstone-server"} \
              --config "${stateDir}/config.toml" \
              --host ${cfg.server.host} \
              --port ${toString cfg.server.port} \
              --log-level ${cfg.server.logLevel} \
              --log-format ${cfg.server.logFormat}
          '';
        };
    })

    # ── Console service ────────────────────────────────────────────
    (lib.mkIf cfg.console.enable {
      systemd.services.turnstone-console =
        let
          consoleSettings = mkMergedSettings {
            extraSettings = {
              console = {
                host = cfg.console.host;
                port = cfg.console.port;
              };
            };
          };

          consoleConfigFile = settingsFormat.generate "turnstone-console-config.toml" consoleSettings;

          setupScript = pkgs.writeShellScript "turnstone-console-setup" ''
            set -euo pipefail
            install -o turnstone -g turnstone -m 600 ${consoleConfigFile} ${stateDir}/console-config.toml
            ${mkSecretSubstitutionScript "${stateDir}/console-config.toml"}
          '';
        in
        {
          description = "Turnstone Console (Admin Dashboard)";
          after = [
            "network.target"
          ]
          ++ lib.optional (cfg.settings.database.backend == "postgresql") "postgresql.service";
          requires = lib.optional (cfg.settings.database.backend == "postgresql") "postgresql.service";
          wantedBy = [ "multi-user.target" ];

          serviceConfig = sharedServiceConfig // {
            ExecStartPre = [ "+${setupScript}" ];
            ReadWritePaths = [ stateDir ];
          };

          script = ''
            ${lib.optionalString (cfg.jwtSecretFile != null) ''
              export TURNSTONE_JWT_SECRET="$(cat ${cfg.jwtSecretFile})"
            ''}
            ${lib.optionalString (cfg.oidcClientSecretFile != null) ''
              export TURNSTONE_OIDC_CLIENT_SECRET="$(cat ${cfg.oidcClientSecretFile})"
            ''}
            exec ${lib.getExe' cfg.package "turnstone-console"} \
              --config "${stateDir}/console-config.toml" \
              --log-level ${cfg.console.logLevel} \
              --log-format ${cfg.console.logFormat}
          '';
        };
    })
  ];
}
