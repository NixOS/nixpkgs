{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.canaille;

  inherit (lib)
    lib.mkOption
    mkIf
    mkEnableOption
    mkPackageOption
    types
    getExe
    lib.optional
    converge
    filterAttrsRecursive
    ;

  dataDir = "/var/lib/canaille";
  secretsDir = "${dataDir}/secrets";

  settingsFormat = pkgs.formats.toml { };

  # Remove null values, so we can document lib.optional/forbidden values that don't end up in the generated TOML file.
  filterConfig = converge (lib.filterAttrsRecursive (_: v: v != null));

  finalPackage = cfg.package.overridePythonAttrs (old: {
    dependencies =
      old.dependencies
      ++ old.optional-dependencies.front
      ++ old.optional-dependencies.oidc
      ++ old.optional-dependencies.ldap
      ++ old.optional-dependencies.sentry
      ++ old.optional-dependencies.postgresql;
    makeWrapperArgs = (old.makeWrapperArgs or [ ]) ++ [
      "--set CONFIG /etc/canaille/config.toml"
      "--set SECRETS_DIR \"${secretsDir}\""
    ];
  });
  inherit (finalPackage) python;
  pythonEnv = python.buildEnv.override {
    extraLibs = with python.pkgs; [
      (toPythonModule finalPackage)
      celery
    ];
  };

  commonServiceConfig = {
    WorkingDirectory = dataDir;
    User = "canaille";
    Group = "canaille";
    StateDirectory = "canaille";
    StateDirectoryMode = "0750";
    PrivateTmp = true;
  };

  postgresqlHost = "postgresql://localhost/canaille?host=/run/postgresql";
  createLocalPostgresqlDb = cfg.settings.CANAILLE_SQL.DATABASE_URI == postgresqlHost;
in
{

  options.services.canaille = {
    enable = lib.mkEnableOption "Canaille";
    package = lib.mkPackageOption pkgs "canaille" { };
    secretKeyFile = lib.mkOption {
      description = ''
        File containing the Flask secret key. Its content is going to be
        provided to Canaille as `SECRET_KEY`. Make sure it has appropriate
        permissions. For example, copy the output of this to the specified
        file:

        ```
        python3 -c 'import secrets; print(secrets.token_hex())'
        ```
      '';
      type = lib.types.path;
    };
    smtpPasswordFile = lib.mkOption {
      description = ''
        File containing the SMTP password. Make sure it has appropriate permissions.
      '';
      default = null;
      type = lib.types.nullOr lib.types.path;
    };
    jwtPrivateKeyFile = lib.mkOption {
      description = ''
        File containing the JWT private key. Make sure it has appropriate permissions.

        You can generate one using
        ```
        openssl genrsa -out private.pem 4096
        openssl rsa -in private.pem -pubout -outform PEM -out public.pem
        ```
      '';
      default = null;
      type = lib.types.nullOr lib.types.path;
    };
    ldapBindPasswordFile = lib.mkOption {
      description = ''
        File containing the LDAP bind password.
      '';
      default = null;
      type = lib.types.nullOr lib.types.path;
    };
    settings = lib.mkOption {
      default = { };
      description = "Settings for Canaille. See [the documentation](https://canaille.readthedocs.io/en/latest/references/configuration.html) for details.";
      type = lib.types.submodule {
        freeformType = settingsFormat.type;
        options = {
          SECRET_KEY = lib.mkOption {
            readOnly = true;
            description = ''
              Flask Secret Key. Can't be set and must be provided through
              `services.canaille.settings.secretKeyFile`.
            '';
            default = null;
            type = lib.types.nullOr lib.types.str;
          };
          SERVER_NAME = lib.mkOption {
            description = "The domain name on which canaille will be served.";
            example = "auth.example.org";
            type = lib.types.str;
          };
          PREFERRED_URL_SCHEME = lib.mkOption {
            description = "The url scheme by which canaille will be served.";
            default = "https";
            type = lib.types.enum [
              "http"
              "https"
            ];
          };

          CANAILLE = {
            ACL = lib.mkOption {
              default = null;
              description = ''
                Access Control Lists.

                See also [the documentation](https://canaille.readthedocs.io/en/latest/references/configuration.html#canaille.core.configuration.ACLSettings).
              '';
              type = lib.types.nullOr (
                types.submodule {
                  freeformType = settingsFormat.type;
                  options = { };
                }
              );
            };
            SMTP = lib.mkOption {
              default = null;
              example = { };
              description = ''
                SMTP configuration. By default, sending emails is not enabled.

                Set to an empty attrs to send emails from localhost without
                authentication.

                See also [the documentation](https://canaille.readthedocs.io/en/latest/references/configuration.html#canaille.core.configuration.SMTPSettings).
              '';
              type = lib.types.nullOr (
                types.submodule {
                  freeformType = settingsFormat.type;
                  options = {
                    PASSWORD = lib.mkOption {
                      readOnly = true;
                      description = ''
                        SMTP Password. Can't be set and has to be provided using
                        `services.canaille.smtpPasswordFile`.
                      '';
                      default = null;
                      type = lib.types.nullOr lib.types.str;
                    };
                  };
                }
              );
            };

          };
          CANAILLE_OIDC = lib.mkOption {
            default = null;
            description = ''
              OpenID Connect settings. See [the documentation](https://canaille.readthedocs.io/en/latest/references/configuration.html#canaille.oidc.configuration.OIDCSettings).
            '';
            type = lib.types.nullOr (
              types.submodule {
                freeformType = settingsFormat.type;
                options = {
                  JWT.PRIVATE_KEY = lib.mkOption {
                    readOnly = true;
                    description = ''
                      JWT private key. Can't be set and has to be provided using
                      `services.canaille.jwtPrivateKeyFile`.
                    '';
                    default = null;
                    type = lib.types.nullOr lib.types.str;
                  };
                };
              }
            );
          };
          CANAILLE_LDAP = lib.mkOption {
            default = null;
            description = ''
              Configuration for the LDAP backend. This storage backend is not
              yet supported by the module, so use at your own risk!
            '';
            type = lib.types.nullOr (
              types.submodule {
                freeformType = settingsFormat.type;
                options = {
                  BIND_PW = lib.mkOption {
                    readOnly = true;
                    description = ''
                      The LDAP bind password. Can't be set and has to be provided using
                      `services.canaille.ldapBindPasswordFile`.
                    '';
                    default = null;
                    type = lib.types.nullOr lib.types.str;
                  };
                };
              }
            );
          };
          CANAILLE_SQL = {
            DATABASE_URI = lib.mkOption {
              description = ''
                The SQL server URI. Will configure a local PostgreSQL db if
                left to default. Please note that the NixOS module only really
                supports PostgreSQL for now. Change at your own risk!
              '';
              default = postgresqlHost;
              type = lib.types.str;
            };
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # We can use some kind of fix point for the config anyways, and
    # /etc/canaille is recommended by upstream. The alternative would be to use
    # a double wrapped canaille executable, to avoid having to rebuild Canaille
    # on every config change.
    environment.etc."canaille/config.toml" = {
      source = settingsFormat.generate "config.toml" (filterConfig cfg.settings);
      user = "canaille";
      group = "canaille";
    };

    # Secrets management is unfortunately done in a semi stateful way, due to these constraints:
    # - Canaille uses Pydantic, which currently only accepts an env file or a single
    #   directory (SECRETS_DIR) for loading settings from files.
    # - The canaille user needs access to secrets, as it needs to run the CLI
    #   for e.g. user creation. Therefore specifying the SECRETS_DIR as systemd's
    #   CREDENTIALS_DIRECTORY is not an option.
    #
    # See this for how Pydantic maps file names/env vars to config settings:
    # https://docs.pydantic.dev/latest/concepts/pydantic_settings/#parsing-environment-variable-values
    systemd.tmpfiles.rules =
      [
        "Z  ${secretsDir} 700 canaille canaille - -"
        "L+ ${secretsDir}/SECRET_KEY - - - - ${cfg.secretKeyFile}"
      ]
      ++ lib.optional (
        cfg.smtpPasswordFile != null
      ) "L+ ${secretsDir}/CANAILLE_SMTP__PASSWORD - - - - ${cfg.smtpPasswordFile}"
      ++ lib.optional (
        cfg.jwtPrivateKeyFile != null
      ) "L+ ${secretsDir}/CANAILLE_OIDC__JWT__PRIVATE_KEY - - - - ${cfg.jwtPrivateKeyFile}"
      ++ lib.optional (
        cfg.ldapBindPasswordFile != null
      ) "L+ ${secretsDir}/CANAILLE_LDAP__BIND_PW - - - - ${cfg.ldapBindPasswordFile}";

    # This is not a migration, just an initial setup of schemas
    systemd.services.canaille-install = {
      # We want this on boot, not on socket activation
      wantedBy = [ "multi-user.target" ];
      after = lib.optional createLocalPostgresqlDb "postgresql.service";
      serviceConfig = commonServiceConfig // {
        Type = "oneshot";
        ExecStart = "${getExe finalPackage} install";
      };
    };

    systemd.services.canaille = {
      description = "Canaille";
      documentation = [ "https://canaille.readthedocs.io/en/latest/tutorial/deployment.html" ];
      after = [
        "network.target"
        "canaille-install.service"
      ] ++ lib.optional createLocalPostgresqlDb "postgresql.service";
      requires = [
        "canaille-install.service"
        "canaille.socket"
      ];
      environment = {
        PYTHONPATH = "${pythonEnv}/${python.sitePackages}/";
        CONFIG = "/etc/canaille/config.toml";
        SECRETS_DIR = secretsDir;
      };
      serviceConfig = commonServiceConfig // {
        Restart = "on-failure";
        ExecStart =
          let
            gunicorn = python.pkgs.gunicorn.overridePythonAttrs (old: {
              # Allows Gunicorn to set a meaningful process name
              dependencies = (old.dependencies or [ ]) ++ old.optional-dependencies.setproctitle;
            });
          in
          ''
            ${getExe gunicorn} \
              --name=canaille \
              --bind='unix:///run/canaille.socket' \
              'canaille:create_app()'
          '';
      };
      restartTriggers = [ "/etc/canaille/config.toml" ];
    };

    systemd.sockets.canaille = {
      before = [ "nginx.service" ];
      wantedBy = [ "sockets.target" ];
      socketConfig = {
        ListenStream = "/run/canaille.socket";
        SocketUser = "canaille";
        SocketGroup = "canaille";
        SocketMode = "770";
      };
    };

    services.nginx.enable = true;
    services.nginx.recommendedGzipSettings = true;
    services.nginx.recommendedProxySettings = true;
    services.nginx.virtualHosts."${cfg.settings.SERVER_NAME}" = {
      forceSSL = true;
      enableACME = true;
      # Config from https://canaille.readthedocs.io/en/latest/tutorial/deployment.html#nginx
      extraConfig = ''
        charset utf-8;
        client_max_body_size 10M;

        add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;
        add_header X-Frame-Options                      "SAMEORIGIN"    always;
        add_header X-XSS-Protection                     "1; mode=block" always;
        add_header X-Content-Type-Options               "nosniff"       always;
        add_header Referrer-Policy                      "same-origin"   always;
      '';
      locations = {
        "/".proxyPass = "http://unix:///run/canaille.socket";
        "/static" = {
          root = "${finalPackage}/${python.sitePackages}/canaille";
        };
        "~* ^/static/.+\\.(?:css|cur|js|jpe?g|gif|htc|ico|png|html|xml|otf|ttf|eot|woff|woff2|svg)$" = {
          root = "${finalPackage}/${python.sitePackages}/canaille";
          extraConfig = ''
            access_log off;
            expires 30d;
            more_set_headers Cache-Control public;
          '';
        };
      };
    };

    services.postgresql = lib.mkIf createLocalPostgresqlDb {
      enable = true;
      ensureUsers = [
        {
          name = "canaille";
          ensureDBOwnership = true;
        }
      ];
      ensureDatabases = [ "canaille" ];
    };

    users.users.canaille = {
      isSystemUser = true;
      group = "canaille";
      packages = [ finalPackage ];
    };

    users.groups.canaille.members = [ config.services.nginx.user ];
  };

  meta.maintainers = with lib.maintainers; [ erictapen ];
}
