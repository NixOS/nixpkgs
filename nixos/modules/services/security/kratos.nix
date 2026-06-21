{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (builtins) head;
  inherit (lib)
    attrByPath
    concatLists
    escapeShellArg
    getExe
    hasSuffix
    hasAttrByPath
    imap0
    maintainers
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    mkPackageOption
    optional
    optionals
    types
    ;

  cfg = config.services.kratos;

  settingsFormat = pkgs.formats.yaml { };
  settingsFile = settingsFormat.generate "kratos.yml" cfg.settings;

  configPaths = [ settingsFile ] ++ cfg.settingsFiles;
  configArgs = lib.concatMap (path: [
    "-c"
    path
  ]) configPaths;

  serviceName = "kratos";
  migrateServiceName = "${serviceName}-migrate";
  postgresqlInitServiceName = "${serviceName}-postgresql-init";

  withTrailingSlash = url: if hasSuffix "/" url then url else "${url}/";
  withoutTrailingSlash = lib.removeSuffix "/";

  urlsEnabled = cfg.urls.selfService != null;
  selfServiceBaseUrl =
    if cfg.urls.selfService != null then withoutTrailingSlash cfg.urls.selfService else null;
  selfServiceBaseUrlWithSlash =
    if cfg.urls.selfService != null then withTrailingSlash cfg.urls.selfService else null;
  defaultReturnTo =
    if cfg.urls.defaultReturnTo != null then
      cfg.urls.defaultReturnTo
    else if cfg.urls.selfService != null then
      selfServiceBaseUrlWithSlash
    else
      null;

  localPostgreSQLDSN = "postgres:///${cfg.database.name}?host=/run/postgresql";

  secretLists = {
    default = cfg.secretFiles.default;
    cookie = cfg.secretFiles.cookie;
    cipher = cfg.secretFiles.cipher;
  };
  secretIndices = lib.mapAttrs (_: files: imap0 (i: _: i) files) secretLists;
  secretFilesEnabled =
    lib.any (files: files != [ ]) (builtins.attrValues secretLists)
    || cfg.secretFiles.courierSmtpConnectionURI != null;

  secretFileCredentials =
    (imap0 (i: path: "secret-default-${toString i}:${path}") cfg.secretFiles.default)
    ++ (imap0 (i: path: "secret-cookie-${toString i}:${path}") cfg.secretFiles.cookie)
    ++ (imap0 (i: path: "secret-cipher-${toString i}:${path}") cfg.secretFiles.cipher)
    ++ optional (
      cfg.secretFiles.courierSmtpConnectionURI != null
    ) "secret-courier-smtp-connection-uri:${cfg.secretFiles.courierSmtpConnectionURI}";

  loadDSNScript =
    if cfg.dsnFile != null then
      ''
        export DSN="$(<"$CREDENTIALS_DIRECTORY/dsn")"
      ''
    else
      ''
        export DSN=${escapeShellArg cfg.dsn}
      '';

  renderStructuredSecretsScript =
    let
      mkArgs =
        prefix: indices:
        lib.concatMapStringsSep " " (
          i: ''--rawfile ${prefix}${toString i} "$CREDENTIALS_DIRECTORY/${prefix}-${toString i}"''
        ) indices;
      defaultArgs = mkArgs "secret-default" secretIndices.default;
      cookieArgs = mkArgs "secret-cookie" secretIndices.cookie;
      cipherArgs = mkArgs "secret-cipher" secretIndices.cipher;
      smtpArg = lib.optionalString (cfg.secretFiles.courierSmtpConnectionURI != null) ''
        --rawfile secretCourierSmtpConnectionUri "$CREDENTIALS_DIRECTORY/secret-courier-smtp-connection-uri"
      '';
      jqArray = name: indices: "[ ${lib.concatMapStringsSep ", " (i: "$${name}${toString i}") indices} ]";
      jqSecrets =
        lib.optionalString
          (secretLists.default != [ ] || secretLists.cookie != [ ] || secretLists.cipher != [ ])
          ''
            + {
              secrets:
                {}
                ${lib.optionalString (
                  secretLists.default != [ ]
                ) "+ { default: ${jqArray "secretDefault" secretIndices.default} }"}
                ${lib.optionalString (
                  secretLists.cookie != [ ]
                ) "+ { cookie: ${jqArray "secretCookie" secretIndices.cookie} }"}
                ${lib.optionalString (
                  secretLists.cipher != [ ]
                ) "+ { cipher: ${jqArray "secretCipher" secretIndices.cipher} }"}
            }
          '';
      jqCourier = lib.optionalString (cfg.secretFiles.courierSmtpConnectionURI != null) ''
        + { courier: { smtp: { connection_uri: $secretCourierSmtpConnectionUri } } }
      '';
    in
    ''
      structured_secret_config="$(mktemp -t kratos-secrets.XXXXXX.json)"
      trap 'rm -f "$structured_secret_config"' EXIT

      ${getExe pkgs.jq} -n \
        ${defaultArgs} \
        ${cookieArgs} \
        ${cipherArgs} \
        ${smtpArg} \
        '
          {}
          ${jqSecrets}
          ${jqCourier}
        ' > "$structured_secret_config"

      extraConfigArgs=(-c "$structured_secret_config")
    '';

  mkKratosExecStart =
    name: args:
    pkgs.writeShellScript name ''
      set -euo pipefail

      ${loadDSNScript}

      extraConfigArgs=()
      ${lib.optionalString secretFilesEnabled renderStructuredSecretsScript}

      exec ${getExe cfg.package} ${lib.escapeShellArgs args} "''${extraConfigArgs[@]}"
    '';

  commonRestartTriggers = [
    cfg.package
    settingsFile
  ]
  ++ cfg.settingsFiles
  ++ cfg.environmentFiles
  ++ optional (cfg.dsnFile != null) cfg.dsnFile
  ++ concatLists (builtins.attrValues secretLists)
  ++ optional (
    cfg.secretFiles.courierSmtpConnectionURI != null
  ) cfg.secretFiles.courierSmtpConnectionURI;

  commonLoadCredential = optional (cfg.dsnFile != null) "dsn:${cfg.dsnFile}" ++ secretFileCredentials;

  commonServiceConfig = {
    User = cfg.user;
    Group = cfg.group;
    WorkingDirectory = cfg.dataDir;
    EnvironmentFile = cfg.environmentFiles;
    LoadCredential = commonLoadCredential;
    UMask = "0077";

    CapabilityBoundingSet = "";
    DeviceAllow = "";
    LockPersonality = true;
    MemoryDenyWriteExecute = true;
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
    ReadWritePaths = [ cfg.dataDir ];
    RestrictAddressFamilies = [
      "AF_INET"
      "AF_INET6"
      "AF_UNIX"
    ];
    RestrictNamespaces = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    SystemCallArchitectures = "native";
    SystemCallFilter = [
      "@system-service"
      "~@privileged @setuid @keyring"
    ];
  };

  publicPort = attrByPath [ "serve" "public" "port" ] 4433 cfg.settings;
in
{
  options.services.kratos = {
    enable = mkEnableOption "Ory Kratos identity and user management";

    package = mkPackageOption pkgs "kratos" { };

    user = mkOption {
      type = types.str;
      default = "kratos";
      description = "The user to run Kratos under.";
    };

    group = mkOption {
      type = types.str;
      default = "kratos";
      description = "The group to run Kratos under.";
    };

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/kratos";
      description = ''
        Data directory used by Kratos. This is used by default for the SQLite
        database.
      '';
    };

    dsn = mkOption {
      type = types.str;
      default = "sqlite:///var/lib/kratos/db.sqlite?_fk=true&mode=rwc";
      example = "postgres://kratos:secret@db.internal:5432/kratos?sslmode=disable&max_conns=20&max_idle_conns=4";
      description = ''
        Database connection string passed to Kratos through the `DSN`
        environment variable.

        If this contains credentials, prefer [](#opt-services.kratos.dsnFile)
        to avoid storing them in the world-readable Nix store.
      '';
    };

    dsnFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/run/secrets/kratos-dsn";
      description = ''
        Path to a file containing the database connection string. This file is
        loaded at runtime using systemd credentials.
      '';
    };

    database = {
      createLocally = mkEnableOption ''
        automatic PostgreSQL database setup.

        This enables `services.postgresql`, creates a local PostgreSQL role and
        database for Kratos, and adjusts the default DSN to connect over the
        local Unix socket.
      '';

      name = mkOption {
        type = types.str;
        default = "kratos";
        description = "Local PostgreSQL database name to use when `createLocally` is enabled.";
      };

      user = mkOption {
        type = types.str;
        default = cfg.user;
        defaultText = lib.literalExpression "config.services.kratos.user";
        description = ''
          Local PostgreSQL role name to use when `createLocally` is enabled.

          This must match the Unix user running Kratos so peer authentication
          over the PostgreSQL Unix socket works correctly.
        '';
      };
    };

    urls = {
      public = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "https://id.example.com/";
        description = ''
          External public base URL for Kratos. When set, this becomes
          `serve.public.base_url`.
        '';
      };

      admin = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "http://kratos.internal:4434/";
        description = ''
          External admin base URL for Kratos. When set, this becomes
          `serve.admin.base_url`.
        '';
      };

      selfService = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "https://id.example.com";
        description = ''
          Base URL for the self-service UI.

          When set, the module derives the common
          `selfservice.default_browser_return_url`,
          `selfservice.allowed_return_urls`, and
          `selfservice.flows.*.ui_url` values.
        '';
      };

      defaultReturnTo = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "https://app.example.com/";
        description = ''
          Default browser return URL for self-service flows. If unset and
          `selfService` is set, defaults to the self-service base URL with a
          trailing slash.
        '';
      };

      allowedReturnUrls = mkOption {
        type = types.listOf types.str;
        default = [ ];
        example = [
          "https://app.example.com/"
          "https://id.example.com/"
        ];
        description = ''
          Additional allowed return URLs. If `selfService` is set and this list
          is empty, the self-service base URL is used by default.
        '';
      };
    };

    secretFiles = {
      default = mkOption {
        type = types.listOf types.path;
        default = [ ];
        example = [ "/run/secrets/kratos-default-secret" ];
        description = ''
          Files containing values for `secrets.default`, in order from newest to
          oldest for rotation.
        '';
      };

      cookie = mkOption {
        type = types.listOf types.path;
        default = [ ];
        example = [ "/run/secrets/kratos-cookie-secret" ];
        description = ''
          Files containing values for `secrets.cookie`, in order from newest to
          oldest for rotation.
        '';
      };

      cipher = mkOption {
        type = types.listOf types.path;
        default = [ ];
        example = [ "/run/secrets/kratos-cipher-secret" ];
        description = ''
          Files containing values for `secrets.cipher`, in order from newest to
          oldest for rotation.
        '';
      };

      courierSmtpConnectionURI = mkOption {
        type = types.nullOr types.path;
        default = null;
        example = "/run/secrets/kratos-smtp-connection-uri";
        description = ''
          File containing `courier.smtp.connection_uri`.
        '';
      };
    };

    environmentFiles = mkOption {
      type = types.listOf types.path;
      default = [ ];
      example = [ "/run/secrets/kratos-env" ];
      description = ''
        Environment files loaded for both the migration and main Kratos
        services.

        Kratos also supports loading configuration values from environment
        variables, so this can be used for additional runtime-only overrides.
      '';
    };

    settings = mkOption {
      type = types.submodule {
        freeformType = settingsFormat.type;
      };
      default = { };
      example = lib.literalExpression ''
        {
          selfservice = {
            default_browser_return_url = "https://id.example.com/";
            allowed_return_urls = [ "https://id.example.com/" ];
            methods.password.enabled = true;
            flows = {
              error.ui_url = "https://id.example.com/error";
              login.ui_url = "https://id.example.com/login";
              registration.ui_url = "https://id.example.com/registration";
              settings.ui_url = "https://id.example.com/settings";
              recovery = {
                enabled = true;
                ui_url = "https://id.example.com/recovery";
              };
              verification = {
                enabled = true;
                ui_url = "https://id.example.com/verification";
              };
            };
          };

          secrets = {
            cookie = [ "replace-me-with-a-long-random-secret" ];
            cipher = [ "0123456789abcdef0123456789abcdef" ];
            default = [ "replace-me-with-a-long-random-secret" ];
          };
        }
      '';
      description = ''
        Kratos configuration written to a generated YAML file.

        See [the configuration reference](https://www.ory.sh/docs/kratos/reference/configuration)
        and [the deployment configuration guide](https://mintlify.wiki/ory/kratos/deployment/configuration)
        for the available settings.

        The `dsn` setting is managed separately by the NixOS module through
        [](#opt-services.kratos.dsn) and [](#opt-services.kratos.dsnFile).
      '';
    };

    settingsFiles = mkOption {
      type = types.listOf types.path;
      default = [ ];
      example = [ "/run/secrets/kratos-secrets.yaml" ];
      description = ''
        Additional config files to load after the generated base config.

        Kratos supports loading multiple config files, with later files
        overriding earlier ones. This is useful for keeping secrets such as
        `secrets.default`, `secrets.cookie`, `secrets.cipher`, or SMTP
        credentials out of the Nix store.
      '';
    };

    identitySchemas = mkOption {
      type = types.listOf (
        types.submodule {
          options = {
            id = mkOption {
              type = types.str;
              example = "default";
              description = "Identity schema ID.";
            };

            path = mkOption {
              type = types.path;
              example = "/etc/kratos/identity.schema.json";
              description = "Path to the JSON schema file.";
            };

            selfserviceSelectable = mkOption {
              type = types.bool;
              default = false;
              description = ''
                Whether the schema is selectable in self-service flows using the
                `identity_schema` query parameter.
              '';
            };
          };
        }
      );
      default = [ ];
      description = ''
        Convenience option for configuring `identity.schemas` using local files.

        Each entry is translated to a Kratos `file://` schema URL. Leave this
        empty if you prefer to define `identity.schemas` directly in
        [](#opt-services.kratos.settings) or one of
        [](#opt-services.kratos.settingsFiles).
      '';
    };

    watchCourier = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Run the Kratos courier in the main process using `--watch-courier`.

        This matches the upstream quickstart and is a good default for a single
        NixOS instance.
      '';
    };

    dev = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Run Kratos with `--dev`, which disables important security features and
        should only be used for local development.
      '';
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to open the configured public port in the firewall.
      '';
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = !hasAttrByPath [ "dsn" ] cfg.settings;
        message = ''
          `services.kratos.settings.dsn` is managed by the NixOS module.
          Use `services.kratos.dsn` or `services.kratos.dsnFile` instead.
        '';
      }
      {
        assertion =
          cfg.identitySchemas != [ ]
          || hasAttrByPath [ "identity" "schemas" ] cfg.settings
          || lib.any (path: true) cfg.settingsFiles;
        message = ''
          Kratos requires at least one identity schema. Set
          `services.kratos.identitySchemas`, or define `identity.schemas` in
          `services.kratos.settings` / `services.kratos.settingsFiles`.
        '';
      }
      {
        assertion = hasAttrByPath [ "selfservice" ] cfg.settings || cfg.settingsFiles != [ ] || urlsEnabled;
        message = ''
          Kratos requires `selfservice` configuration. Define it in
          `services.kratos.settings` or provide it through
          `services.kratos.settingsFiles`.
        '';
      }
      {
        assertion = !cfg.database.createLocally || cfg.database.user == cfg.user;
        message = ''
          `services.kratos.database.user` must match `services.kratos.user`
          when `services.kratos.database.createLocally` is enabled, so local
          PostgreSQL peer authentication works correctly.
        '';
      }
    ];

    warnings =
      optionals
        (
          cfg.dsnFile == null
          && !cfg.database.createLocally
          && cfg.dsn != "sqlite:///var/lib/kratos/db.sqlite?_fk=true&mode=rwc"
        )
        [
          ''
            `services.kratos.dsn` will be stored in the Nix store if it contains
            credentials. Prefer `services.kratos.dsnFile` for production
            deployments.
          ''
        ];

    services.kratos.settings = mkMerge [
      {
        version = lib.mkDefault "v${cfg.package.version}";
        log = {
          level = lib.mkDefault "info";
          format = lib.mkDefault "json";
        };
        serve = {
          public = {
            host = lib.mkDefault "127.0.0.1";
            port = lib.mkDefault 4433;
          }
          // lib.optionalAttrs (cfg.urls.public == null) {
            base_url = lib.mkDefault "http://127.0.0.1:4433/";
          };
          admin = {
            host = lib.mkDefault "127.0.0.1";
            port = lib.mkDefault 4434;
          }
          // lib.optionalAttrs (cfg.urls.admin == null) {
            base_url = lib.mkDefault "http://127.0.0.1:4434/";
          };
        };
      }
      (mkIf (cfg.urls.public != null) {
        serve.public.base_url = lib.mkDefault (withTrailingSlash cfg.urls.public);
      })
      (mkIf (cfg.urls.admin != null) {
        serve.admin.base_url = lib.mkDefault (withTrailingSlash cfg.urls.admin);
      })
      (mkIf urlsEnabled {
        selfservice = {
          default_browser_return_url = lib.mkDefault defaultReturnTo;
          allowed_return_urls = lib.mkDefault (
            if cfg.urls.allowedReturnUrls != [ ] then
              cfg.urls.allowedReturnUrls
            else
              [ selfServiceBaseUrlWithSlash ]
          );
          flows = {
            error.ui_url = lib.mkDefault "${selfServiceBaseUrl}/error";
            settings.ui_url = lib.mkDefault "${selfServiceBaseUrl}/settings";
            recovery.ui_url = lib.mkDefault "${selfServiceBaseUrl}/recovery";
            verification = {
              ui_url = lib.mkDefault "${selfServiceBaseUrl}/verification";
              after.default_browser_return_url = lib.mkDefault defaultReturnTo;
            };
            logout.after.default_browser_return_url = lib.mkDefault "${selfServiceBaseUrl}/login";
            login.ui_url = lib.mkDefault "${selfServiceBaseUrl}/login";
            registration.ui_url = lib.mkDefault "${selfServiceBaseUrl}/registration";
          };
        };
      })
      (mkIf (cfg.identitySchemas != [ ]) {
        identity = {
          default_schema_id = lib.mkDefault (head cfg.identitySchemas).id;
          schemas = map (schema: {
            inherit (schema) id;
            url = "file://${toString schema.path}";
            selfservice_selectable = schema.selfserviceSelectable;
          }) cfg.identitySchemas;
        };
      })
    ];

    services.kratos.dsn = mkIf cfg.database.createLocally (lib.mkDefault localPostgreSQLDSN);

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ publicPort ];

    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir} 0750 ${cfg.user} ${cfg.group} - -"
    ];

    systemd.services.${postgresqlInitServiceName} = mkIf cfg.database.createLocally {
      description = "Ory Kratos PostgreSQL setup";
      after = [ "postgresql.target" ];
      before = [ "${migrateServiceName}.service" ];
      bindsTo = [ "postgresql.target" ];
      path = [ config.services.postgresql.package ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        User = "postgres";
        Group = "postgres";
      };
      script = ''
        set -o errexit -o pipefail -o nounset -o errtrace
        shopt -s inherit_errexit

        psql -tAc "SELECT 1 FROM pg_roles WHERE rolname='${cfg.database.user}'" | grep -q 1 \
          || psql -tAc 'CREATE ROLE "${cfg.database.user}" WITH LOGIN'
        psql -tAc "SELECT 1 FROM pg_database WHERE datname='${cfg.database.name}'" | grep -q 1 \
          || psql -tAc 'CREATE DATABASE "${cfg.database.name}" OWNER "${cfg.database.user}"'
      '';
      enableStrictShellChecks = true;
    };

    systemd.services.${migrateServiceName} = {
      description = "Ory Kratos database migration";
      wantedBy = [ "multi-user.target" ];
      before = [ "${serviceName}.service" ];
      wants = [ "network-online.target" ];
      requires = optionals cfg.database.createLocally [ "${postgresqlInitServiceName}.service" ];
      after = [
        "network-online.target"
      ]
      ++ optionals cfg.database.createLocally [
        "postgresql.target"
        "${postgresqlInitServiceName}.service"
      ];
      restartTriggers = commonRestartTriggers;
      serviceConfig = commonServiceConfig // {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = mkKratosExecStart "kratos-migrate" (
          [
            "migrate"
            "sql"
          ]
          ++ configArgs
          ++ [
            "-e"
            "--yes"
          ]
        );
      };
    };

    systemd.services.${serviceName} = {
      description = "Ory Kratos";
      wantedBy = [ "multi-user.target" ];
      requires = [ "${migrateServiceName}.service" ];
      after = [
        "network-online.target"
        "${migrateServiceName}.service"
      ]
      ++ optionals cfg.database.createLocally [ "postgresql.target" ];
      wants = [ "network-online.target" ];
      restartTriggers = commonRestartTriggers;
      serviceConfig = commonServiceConfig // {
        Type = "simple";
        ExecStart = mkKratosExecStart "kratos-serve" (
          [ "serve" ]
          ++ configArgs
          ++ optionals cfg.dev [ "--dev" ]
          ++ optionals cfg.watchCourier [ "--watch-courier" ]
        );
        Restart = "on-failure";
        RestartSec = 5;
      };
    };

    users.users.kratos = mkIf (cfg.user == "kratos") {
      isSystemUser = true;
      group = cfg.group;
      description = "Ory Kratos user";
    };

    users.groups.kratos = mkIf (cfg.group == "kratos") { };

    services.postgresql.enable = mkIf cfg.database.createLocally true;
  };

  meta.maintainers = with maintainers; [ philocalyst ];
}
