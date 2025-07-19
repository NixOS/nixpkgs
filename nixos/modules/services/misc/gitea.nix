{
  config,
  lib,
  options,
  pkgs,
  ...
}:

let
  cfg = config.services.gitea;
  opt = options.services.gitea;
  exe = lib.getExe cfg.package;
  nginx = config.services.nginx;
  pg = config.services.postgresql;
  useMysql = cfg.database.type == "mysql";
  usePostgresql = cfg.database.type == "postgres";
  useSqlite = cfg.database.type == "sqlite3";
  format = pkgs.formats.ini { };
  configFile = pkgs.writeText "app.ini" ''
    APP_NAME = ${cfg.appName}
    RUN_USER = ${cfg.user}
    RUN_MODE = prod
    WORK_PATH = ${cfg.stateDir}

    ${lib.generators.toINI { } cfg.settings}

    ${lib.optionalString (cfg.extraConfig != null) cfg.extraConfig}
  '';

  inherit (cfg.settings) mailer;
  useSendmail = mailer.ENABLED && mailer.PROTOCOL == "sendmail";
in

{
  imports = [
    (lib.mkRenamedOptionModule
      [ "services" "gitea" "cookieSecure" ]
      [ "services" "gitea" "settings" "session" "COOKIE_SECURE" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "gitea" "disableRegistration" ]
      [ "services" "gitea" "settings" "service" "DISABLE_REGISTRATION" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "gitea" "domain" ]
      [ "services" "gitea" "settings" "server" "DOMAIN" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "gitea" "httpAddress" ]
      [ "services" "gitea" "settings" "server" "HTTP_ADDR" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "gitea" "httpPort" ]
      [ "services" "gitea" "settings" "server" "HTTP_PORT" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "gitea" "log" "level" ]
      [ "services" "gitea" "settings" "log" "LEVEL" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "gitea" "log" "rootPath" ]
      [ "services" "gitea" "settings" "log" "ROOT_PATH" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "gitea" "rootUrl" ]
      [ "services" "gitea" "settings" "server" "ROOT_URL" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "gitea" "ssh" "clonePort" ]
      [ "services" "gitea" "settings" "server" "SSH_PORT" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "gitea" "staticRootPath" ]
      [ "services" "gitea" "settings" "server" "STATIC_ROOT_PATH" ]
    )

    (lib.mkChangedOptionModule
      [ "services" "gitea" "enableUnixSocket" ]
      [ "services" "gitea" "settings" "server" "PROTOCOL" ]
      (config: if config.services.gitea.enableUnixSocket then "http+unix" else "http")
    )

    (lib.mkRemovedOptionModule [ "services" "gitea" "ssh" "enable" ]
      "It has been migrated into freeform setting services.gitea.settings.server.DISABLE_SSH. Keep in mind that the setting is inverted."
    )
    (lib.mkRemovedOptionModule [
      "services"
      "gitea"
      "useWizard"
    ] "Has been removed because it was broken and lacked automated testing.")
  ];

  options = {
    services.gitea = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Enable Gitea Service.";
      };

      package = lib.mkPackageOption pkgs "gitea" { };

      stateDir = lib.mkOption {
        default = "/var/lib/gitea";
        type = lib.types.str;
        description = "Gitea data directory.";
      };

      customDir = lib.mkOption {
        default = "${cfg.stateDir}/custom";
        defaultText = lib.literalExpression ''"''${config.${opt.stateDir}}/custom"'';
        type = lib.types.str;
        description = "Gitea custom directory. Used for config, custom templates and other options.";
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "gitea";
        description = "User account under which gitea runs.";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "gitea";
        description = "Group under which gitea runs.";
      };

      database = {
        type = lib.mkOption {
          type = lib.types.enum [
            "sqlite3"
            "mysql"
            "postgres"
          ];
          example = "mysql";
          default = "sqlite3";
          description = "Database engine to use.";
        };

        host = lib.mkOption {
          type = lib.types.str;
          default = "127.0.0.1";
          description = "Database host address.";
        };

        port = lib.mkOption {
          type = lib.types.port;
          default = if usePostgresql then pg.settings.port else 3306;
          defaultText = lib.literalExpression ''if config.${opt.database.type} != "postgresql" then 3306 else 5432'';
          description = "Database host port.";
        };

        name = lib.mkOption {
          type = lib.types.str;
          default = "gitea";
          description = "Database name.";
        };

        user = lib.mkOption {
          type = lib.types.str;
          default = "gitea";
          description = "Database user.";
        };

        password = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = ''
            The password corresponding to {option}`database.user`.
            Warning: this is stored in cleartext in the Nix store!
            Use {option}`database.passwordFile` instead.
          '';
        };

        passwordFile = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          example = "/run/keys/gitea-dbpassword";
          description = ''
            A file containing the password corresponding to
            {option}`database.user`.
          '';
        };

        socket = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default =
            if (cfg.database.createDatabase && usePostgresql) then
              "/run/postgresql"
            else if (cfg.database.createDatabase && useMysql) then
              "/run/mysqld/mysqld.sock"
            else
              null;
          # TODO: actually represent logic
          defaultText = lib.literalExpression "null";
          example = "/run/mysqld/mysqld.sock";
          description = "Path to the unix socket file to use for authentication.";
        };

        path = lib.mkOption {
          type = lib.types.str;
          default = "${cfg.stateDir}/data/gitea.db";
          defaultText = lib.literalExpression ''"''${config.${opt.stateDir}}/data/gitea.db"'';
          description = "Path to the sqlite3 database file.";
        };

        createDatabase = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Whether to create a local database automatically.";
        };
      };

      captcha = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            Enables Gitea to display a CAPTCHA challenge on registration.
          '';
        };

        secretFile = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          example = "/var/lib/secrets/gitea/captcha_secret";
          description = "Path to a file containing the CAPTCHA secret key.";
        };

        siteKey = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          example = "my_site_key";
          description = "CAPTCHA site key to use for Gitea.";
        };

        url = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          example = "https://google.com/recaptcha";
          description = "CAPTCHA url to use for Gitea. Only relevant for `recaptcha` and `mcaptcha`.";
        };

        type = lib.mkOption {
          type = lib.types.enum [
            "image"
            "recaptcha"
            "hcaptcha"
            "mcaptcha"
            "cfturnstile"
          ];
          default = "image";
          example = "recaptcha";
          description = "The type of CAPTCHA to use for Gitea.";
        };

        requireForLogin = lib.mkOption {
          type = lib.types.bool;
          default = false;
          example = true;
          description = "Displays a CAPTCHA challenge whenever a user logs in.";
        };

        requireForExternalRegistration = lib.mkOption {
          type = lib.types.bool;
          default = false;
          example = true;
          description = "Displays a CAPTCHA challenge for users that register externally.";
        };
      };

      dump = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            Enable a timer that runs gitea dump to generate backup-files of the
            current gitea database and repositories.
          '';
        };

        interval = lib.mkOption {
          type = lib.types.str;
          default = "04:31";
          example = "hourly";
          description = ''
            Run a gitea dump at this interval. Runs by default at 04:31 every day.

            The format is described in
            {manpage}`systemd.time(7)`.
          '';
        };

        backupDir = lib.mkOption {
          type = lib.types.str;
          default = "${cfg.stateDir}/dump";
          defaultText = lib.literalExpression ''"''${config.${opt.stateDir}}/dump"'';
          description = "Path to the dump files.";
        };

        type = lib.mkOption {
          type = lib.types.enum [
            "zip"
            "rar"
            "tar"
            "sz"
            "tar.gz"
            "tar.xz"
            "tar.bz2"
            "tar.br"
            "tar.lz4"
            "tar.zst"
          ];
          default = "zip";
          description = "Archive format used to store the dump file.";
        };

        file = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "Filename to be used for the dump. If `null` a default name is chosen by gitea.";
          example = "gitea-dump";
        };
      };

      lfs = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enables git-lfs support.";
        };

        contentDir = lib.mkOption {
          type = lib.types.str;
          default = "${cfg.stateDir}/data/lfs";
          defaultText = lib.literalExpression ''"''${config.${opt.stateDir}}/data/lfs"'';
          description = "Where to store LFS files.";
        };
      };

      appName = lib.mkOption {
        type = lib.types.str;
        default = "gitea: Gitea Service";
        description = "Application name.";
      };

      repositoryRoot = lib.mkOption {
        type = lib.types.str;
        default = "${cfg.stateDir}/repositories";
        defaultText = lib.literalExpression ''"''${config.${opt.stateDir}}/repositories"'';
        description = "Path to the git repositories.";
      };

      camoHmacKeyFile = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "/var/lib/secrets/gitea/camoHmacKey";
        description = "Path to a file containing the camo HMAC key.";
      };

      mailerPasswordFile = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "/var/lib/secrets/gitea/mailpw";
        description = "Path to a file containing the SMTP password.";
      };

      metricsTokenFile = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "/var/lib/secrets/gitea/metrics_token";
        description = "Path to a file containing the metrics authentication token.";
      };

      minioAccessKeyId = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "/var/lib/secrets/gitea/minio_access_key_id";
        description = "Path to a file containing the Minio access key id.";
      };

      minioSecretAccessKey = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "/var/lib/secrets/gitea/minio_secret_access_key";
        description = "Path to a file containing the Minio secret access key.";
      };

      settings = lib.mkOption {
        default = { };
        description = ''
          Gitea configuration. Refer to <https://docs.gitea.io/en-us/config-cheat-sheet/>
          for details on supported values.
        '';
        example = lib.literalExpression ''
          {
            "cron.sync_external_users" = {
              RUN_AT_START = true;
              SCHEDULE = "@every 24h";
              UPDATE_EXISTING = true;
            };
            mailer = {
              ENABLED = true;
              PROTOCOL = "smtp+starttls";
              SMTP_ADDR = "smtp.example.org";
              SMTP_PORT = "587";
              FROM = "Gitea Service <do-not-reply@example.org>";
              USER = "do-not-reply@example.org";
            };
            other = {
              SHOW_FOOTER_VERSION = false;
            };
          }
        '';
        type = lib.types.submodule (
          { config, options, ... }:
          {
            freeformType = format.type;
            options = {
              log = {
                ROOT_PATH = lib.mkOption {
                  default = "${cfg.stateDir}/log";
                  defaultText = lib.literalExpression ''"''${config.${opt.stateDir}}/log"'';
                  type = lib.types.str;
                  description = "Root path for log files.";
                };
                LEVEL = lib.mkOption {
                  default = "Info";
                  type = lib.types.enum [
                    "Trace"
                    "Debug"
                    "Info"
                    "Warn"
                    "Error"
                    "Critical"
                  ];
                  description = "General log level.";
                };
              };

              mailer = {
                ENABLED = lib.mkOption {
                  type = lib.types.bool;
                  default = false;
                  description = "Whether to use an email service to send notifications.";
                };

                PROTOCOL = lib.mkOption {
                  type = lib.types.enum [
                    null
                    "smtp"
                    "smtps"
                    "smtp+starttls"
                    "smtp+unix"
                    "sendmail"
                    "dummy"
                  ];
                  default = null;
                  description = "Which mail server protocol to use.";
                };

                SENDMAIL_PATH = lib.mkOption {
                  type = lib.types.str;
                  # somewhat duplicated with useSendmail but cannot be deduped because of infinite recursion
                  default =
                    if config.mailer.ENABLED && config.mailer.PROTOCOL == "sendmail" then
                      "/run/wrappers/bin/sendmail"
                    else
                      "sendmail";
                  defaultText = lib.literalExpression ''if config.${options.mailer.ENABLED} && config.${options.mailer.PROTOCOL} == "sendmail" then "/run/wrappers/bin/sendmail" else "sendmail"'';
                  description = "Path to sendmail binary or script.";
                };
              };

              # These are the upstream Gitea defaults which we we copied to be able to access them via the module system.
              # https://docs.gitea.com/administration/config-cheat-sheet#picture-picture
              picture = {
                AVATAR_STORAGE_TYPE = lib.mkOption {
                  type = lib.types.str;
                  default = config.storage.STORAGE_TYPE;
                  description = "Type of storage to use for user avatars.";
                };

                AVATAR_UPLOAD_PATH = lib.mkOption {
                  type = lib.types.str;
                  default = "avatars";
                  description = "Path under which user avatars will be uploaded.";
                };

                REPOSITORY_AVATAR_STORAGE_TYPE = lib.mkOption {
                  type = lib.types.str;
                  default = config.storage.STORAGE_TYPE;
                  description = "Type of storage to use for repository avatars.";
                };

                REPOSITORY_AVATAR_UPLOAD_PATH = lib.mkOption {
                  type = lib.types.str;
                  default = "repo-avatars";
                  description = "Path under which repository avatars will be uploaded.";
                };
              };

              server = {
                PROTOCOL = lib.mkOption {
                  type = lib.types.enum [
                    "http"
                    "https"
                    "fcgi"
                    "http+unix"
                    "fcgi+unix"
                  ];
                  default = if cfg.configureNginx then "http+unix" else "http";
                  defaultText = lib.literalExpression ''if config.${opt.configureNginx} then "http+unix" else "http"'';
                  description = ''Listen protocol. `+unix` means "over unix", not "in addition to."'';
                };

                HTTP_ADDR = lib.mkOption {
                  type = lib.types.either lib.types.str lib.types.path;
                  default =
                    if lib.hasSuffix "+unix" cfg.settings.server.PROTOCOL then "/run/gitea/gitea.sock" else "0.0.0.0";
                  defaultText = lib.literalExpression ''if lib.hasSuffix "+unix" config.${options.server.PROTOCOL} then "/run/gitea/gitea.sock" else "0.0.0.0"'';
                  description = "Listen address. Must be a path when using a unix socket.";
                };

                HTTP_PORT = lib.mkOption {
                  type = lib.types.port;
                  default = 3000;
                  description = "Listen port. Ignored when using a unix socket.";
                };

                DOMAIN = lib.mkOption {
                  type = lib.types.str;
                  default = "localhost";
                  description = "Domain name of your server.";
                };

                ROOT_URL = lib.mkOption {
                  type = lib.types.str;
                  default = "http://${cfg.settings.server.DOMAIN}:${toString cfg.settings.server.HTTP_PORT}/";
                  defaultText = lib.literalExpression ''"http://''${config.${options.server.DOMAIN}:''${toString config.${options.server.HTTP_PORT}/"'';
                  description = "Full public URL of gitea server.";
                };

                STATIC_ROOT_PATH = lib.mkOption {
                  type = lib.types.either lib.types.str lib.types.path;
                  default =
                    if cfg.configureNginx then "${pkgs.compressDrvWeb cfg.package.data { }}" else "${cfg.package.data}";
                  defaultText = lib.literalExpression ''if config.${opt.configureNginx} then ''${pkgs.compressDrvWeb config.${opt.package}.data { }} else "{config.${opt.package}.data}"'';
                  example = "/var/lib/gitea/data";
                  description = "Upper level of template and static files path.";
                };

                DISABLE_SSH = lib.mkOption {
                  type = lib.types.bool;
                  default = false;
                  description = "Disable external SSH feature.";
                };

                SSH_PORT = lib.mkOption {
                  type = lib.types.port;
                  default = 22;
                  example = 2222;
                  description = ''
                    SSH port displayed in clone URL.
                    The option is required to configure a service when the external visible port
                    differs from the local listening port i.e. if port forwarding is used.
                  '';
                };
              };

              service = {
                DISABLE_REGISTRATION = lib.mkEnableOption "the registration lock" // {
                  description = ''
                    By default any user can create an account on this `gitea` instance.
                    This can be disabled by using this option.

                    *Note:* please keep in mind that this should be added after the initial
                    deploy as the first registered user will be the administrator.
                  '';
                };
              };

              session = {
                COOKIE_SECURE = lib.mkOption {
                  type = lib.types.bool;
                  default =
                    if cfg.configureNginx then nginx.virtualHosts.${cfg.settings.server.DOMAIN}.forceSSL else false;
                  defaultText = lib.literalExpression ''if config.${opt.configureNginx} then config.services.nginx.virtualHosts.''${cfg.settings.server.DOMAIN}.forceSSL else false'';
                  description = ''
                    Marks session cookies as "secure" as a hint for browsers to only send
                    them via HTTPS. This option is recommend, if gitea is being served over HTTPS.
                  '';
                };
              };

              storage = {
                STORAGE_TYPE = lib.mkOption {
                  type = lib.types.enum [
                    "local"
                    "minio"
                    "azureblob"
                  ];
                  default = "local";
                  description = "Type of storage to use for uploaded blobs like attachments, avatars, archives or packages.";
                };
              };
            };
          }
        );
      };

      configureNginx = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to configure Nginx as a reverse proxy.";
      };

      maxUploadSize = lib.mkOption {
        type = lib.types.int;
        # default taken from https://docs.gitea.com/administration/reverse-proxies?_highlight=nginx#nginx
        default = 512;
        description = ''
          Maximum supported size for a file upload in MiB. Maximum HTTP body
          size is set to this value for nginx. It affects attachment uploading,
          form posting, package uploading and LFS pushing, etc.
        '';
      };

      extraConfig = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        description = "Configuration lines appended to the generated gitea configuration file.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.database.createDatabase -> useSqlite || cfg.database.user == cfg.user;
        message = "services.gitea.database.user must match services.gitea.user if the database is to be automatically provisioned";
      }
      {
        assertion = cfg.database.createDatabase && usePostgresql -> cfg.database.user == cfg.database.name;
        message = ''
          When creating a database via NixOS, the db user and db name must be equal!
          If you already have an existing DB+user and this assertion is new, you can safely set
          `services.gitea.createDatabase` to `false` because removal of `ensureUsers`
          and `ensureDatabases` doesn't have any effect.
        '';
      }
      {
        assertion =
          cfg.captcha.enable
          -> cfg.captcha.type != "image"
          -> (cfg.captcha.secretFile != null && cfg.captcha.siteKey != null);
        message = ''
          Using a CAPTCHA service that is not `image` requires providing a CAPTCHA secret through
          the `captcha.secretFile` option and a CAPTCHA site key through the `captcha.siteKey` option.
        '';
      }
      {
        assertion =
          cfg.captcha.url != null
          -> (builtins.elem cfg.captcha.type [
            "mcaptcha"
            "recaptcha"
          ]);
        message = ''
          `captcha.url` is only relevant when `captcha.type` is `mcaptcha` or `recaptcha`.
        '';
      }
    ];

    services.gitea.settings =
      let
        captchaPrefix =
          lib.optionalString cfg.captcha.enable
            {
              image = "IMAGE";
              recaptcha = "RECAPTCHA";
              hcaptcha = "HCAPTCHA";
              mcaptcha = "MCAPTCHA";
              cfturnstile = "CF_TURNSTILE";
            }
            ."${cfg.captcha.type}";
      in
      {
        camo = lib.mkIf (cfg.camoHmacKeyFile != null) {
          HMAC_KEY = "#hmackey#";
        };

        "cron.update_checker".ENABLED = lib.mkDefault false;

        database = lib.mkMerge [
          {
            DB_TYPE = cfg.database.type;
          }
          (lib.mkIf (useMysql || usePostgresql) {
            HOST =
              if cfg.database.socket != null then
                cfg.database.socket
              else
                cfg.database.host + ":" + toString cfg.database.port;
            NAME = cfg.database.name;
            USER = cfg.database.user;
            PASSWD = "#dbpass#";
          })
          (lib.mkIf useSqlite {
            PATH = cfg.database.path;
          })
          (lib.mkIf usePostgresql {
            SSL_MODE = "disable";
          })
        ];

        lfs = lib.mkIf cfg.lfs.enable {
          PATH = cfg.lfs.contentDir;
        };

        mailer = lib.mkIf (cfg.mailerPasswordFile != null) {
          PASSWD = "#mailerpass#";
        };

        metrics = lib.mkIf (cfg.metricsTokenFile != null) {
          TOKEN = "#metricstoken#";
        };

        oauth2 = {
          JWT_SECRET = "#oauth2jwtsecret#";
        };

        packages.CHUNKED_UPLOAD_PATH = "${cfg.stateDir}/tmp/package-upload";

        repository = {
          ROOT = cfg.repositoryRoot;
        };

        server = lib.mkMerge [
          (lib.mkIf cfg.configureNginx {
            STATIC_URL_PREFIX = lib.mkDefault "/static";
          })
          (lib.mkIf cfg.lfs.enable {
            LFS_START_SERVER = true;
            LFS_JWT_SECRET = "#lfsjwtsecret#";
          })
        ];

        session = {
          COOKIE_NAME = lib.mkDefault "session";
        };

        security = {
          SECRET_KEY = "#secretkey#";
          INTERNAL_TOKEN = "#internaltoken#";
          INSTALL_LOCK = true;
        };

        service = lib.mkIf cfg.captcha.enable (
          lib.mkMerge [
            {
              ENABLE_CAPTCHA = true;
              CAPTCHA_TYPE = cfg.captcha.type;
              REQUIRE_CAPTCHA_FOR_LOGIN = cfg.captcha.requireForLogin;
              REQUIRE_EXTERNAL_REGISTRATION_CAPTCHA = cfg.captcha.requireForExternalRegistration;
            }
            (lib.mkIf (cfg.captcha.secretFile != null) {
              "${captchaPrefix}_SECRET" = "#captchasecret#";
            })
            (lib.mkIf (cfg.captcha.siteKey != null) {
              "${captchaPrefix}_SITEKEY" = cfg.captcha.siteKey;
            })
            (lib.mkIf (cfg.captcha.url != null) {
              "${captchaPrefix}_URL" = cfg.captcha.url;
            })
          ]
        );

        storage = lib.mkMerge [
          (lib.mkIf (cfg.minioAccessKeyId != null) {
            MINIO_ACCESS_KEY_ID = "#minioaccesskeyid#";
          })
          (lib.mkIf (cfg.minioSecretAccessKey != null) {
            MINIO_SECRET_ACCESS_KEY = "#miniosecretaccesskey#";
          })
        ];
      };

    services.postgresql = lib.mkIf (usePostgresql && cfg.database.createDatabase) {
      enable = lib.mkDefault true;

      ensureDatabases = [ cfg.database.name ];
      ensureUsers = [
        {
          name = cfg.database.user;
          ensureDBOwnership = true;
        }
      ];
    };

    services.mysql = lib.mkIf (useMysql && cfg.database.createDatabase) {
      enable = lib.mkDefault true;
      package = lib.mkDefault pkgs.mariadb;

      ensureDatabases = [ cfg.database.name ];
      ensureUsers = [
        {
          name = cfg.database.user;
          ensurePermissions = {
            "${cfg.database.name}.*" = "ALL PRIVILEGES";
          };
        }
      ];
    };

    services.nginx = lib.mkIf cfg.configureNginx {
      enable = true;
      upstreams = {
        "gitea" = {
          servers = {
            ${
              if (cfg.settings.server.PROTOCOL == "http+unix") then
                "unix:${cfg.settings.server.HTTP_ADDR}"
              else
                "127.0.0.1:${toString cfg.httpPort}"
            } =
              {
                fail_timeout = "0";
              };
          };
        };
      };
      virtualHosts."${cfg.settings.server.DOMAIN}" = {
        root = "${cfg.customDir}/public";
        locations =
          let
            nginxCommonHeaders =
              lib.optionalString nginx.virtualHosts.${cfg.settings.server.DOMAIN}.forceSSL ''
                more_set_headers "Strict-Transport-Security: max-age=31536000";
              ''
              +
                lib.optionalString
                  (
                    nginx.virtualHosts.${cfg.settings.server.DOMAIN}.quic
                    && nginx.virtualHosts.${cfg.settings.server.DOMAIN}.http3
                  )
                  ''
                    more_set_headers 'Alt-Svc: h3=":$server_port"; ma=604800';
                  '';
          in
          {
            "/" = {
              priority = 100;
              tryFiles = "$uri @gitea";
              extraConfig = nginxCommonHeaders;
            };

            "^~ /avatars/" = lib.mkIf (cfg.settings.picture.AVATAR_STORAGE_TYPE == "local") {
              alias = "${cfg.stateDir}/data/${cfg.settings.picture.AVATAR_UPLOAD_PATH}/";
              priority = 200;
              tryFiles = "$uri =404";
              extraConfig =
                ''
                  default_type "image";
                  more_set_headers "Cache-Control: public, max-age=604800, must-revalidate";
                ''
                + nginxCommonHeaders;
            };

            "^~ /repo-avatars/" = lib.mkIf (cfg.settings.picture.REPOSITORY_AVATAR_STORAGE_TYPE == "local") {
              alias = "${cfg.stateDir}/data/${cfg.settings.picture.REPOSITORY_AVATAR_UPLOAD_PATH}/";
              priority = 210;
              tryFiles = "$uri =404";
              extraConfig =
                ''
                  default_type "image";
                  more_set_headers "Cache-Control: public, max-age=604800, must-revalidate";
                ''
                + nginxCommonHeaders;
            };

            "^~ ${cfg.settings.server.STATIC_URL_PREFIX}/assets/" = {
              alias = "${cfg.settings.server.STATIC_ROOT_PATH}/public/assets/";
              priority = 220;
              tryFiles = "$uri =404";
              extraConfig =
                ''
                  more_set_headers "Cache-Control: public, max-age=604800, must-revalidate";
                ''
                + nginxCommonHeaders;
            };

            "@gitea" = {
              priority = 300;
              proxyPass = "http://gitea";
              recommendedProxySettings = true;
              extraConfig =
                ''
                  client_max_body_size ${toString cfg.maxUploadSize}M;
                ''
                + nginxCommonHeaders;
            };
          };
      };
    };

    systemd.tmpfiles.rules =
      [
        "d '${cfg.dump.backupDir}' 0750 ${cfg.user} ${cfg.group} - -"
        "z '${cfg.dump.backupDir}' 0750 ${cfg.user} ${cfg.group} - -"
        "d '${cfg.repositoryRoot}' 0750 ${cfg.user} ${cfg.group} - -"
        "z '${cfg.repositoryRoot}' 0750 ${cfg.user} ${cfg.group} - -"
        "d '${cfg.stateDir}' 0750 ${cfg.user} ${cfg.group} - -"
        "d '${cfg.stateDir}/conf' 0750 ${cfg.user} ${cfg.group} - -"
        "d '${cfg.customDir}/public' 0750 ${cfg.user} ${cfg.group} - -"
        "d '${cfg.customDir}' 0750 ${cfg.user} ${cfg.group} - -"
        "d '${cfg.customDir}/conf' 0750 ${cfg.user} ${cfg.group} - -"
        "d '${cfg.stateDir}/data' 0750 ${cfg.user} ${cfg.group} - -"
        "d '${cfg.stateDir}/log' 0750 ${cfg.user} ${cfg.group} - -"
        "z '${cfg.stateDir}' 0750 ${cfg.user} ${cfg.group} - -"
        "z '${cfg.stateDir}/.ssh' 0700 ${cfg.user} ${cfg.group} - -"
        "z '${cfg.stateDir}/conf' 0750 ${cfg.user} ${cfg.group} - -"
        "z '${cfg.customDir}' 0750 ${cfg.user} ${cfg.group} - -"
        "z '${cfg.customDir}/conf' 0750 ${cfg.user} ${cfg.group} - -"
        "z '${cfg.customDir}/public' 0750 ${cfg.user} ${cfg.group} - -"
        "z '${cfg.stateDir}/data' 0750 ${cfg.user} ${cfg.group} - -"
        "z '${cfg.stateDir}/log' 0750 ${cfg.user} ${cfg.group} - -"

        # If we have a folder or symlink with gitea locales, remove it
        # And symlink the current gitea locales in place
        "L+ '${cfg.stateDir}/conf/locale' - - - - ${cfg.package.out}/locale"

      ]
      ++ lib.optionals cfg.lfs.enable [
        "d '${cfg.lfs.contentDir}' 0750 ${cfg.user} ${cfg.group} - -"
        "z '${cfg.lfs.contentDir}' 0750 ${cfg.user} ${cfg.group} - -"
      ];

    systemd.services.gitea = {
      description = "gitea";
      after =
        [ "network.target" ]
        ++ lib.optional usePostgresql "postgresql.target"
        ++ lib.optional useMysql "mysql.service";
      requires =
        lib.optional (cfg.database.createDatabase && usePostgresql) "postgresql.target"
        ++ lib.optional (cfg.database.createDatabase && useMysql) "mysql.service";
      wantedBy = [ "multi-user.target" ];
      path = [
        cfg.package
        pkgs.git
        pkgs.gnupg
      ];

      # In older versions the secret naming for JWT was kind of confusing.
      # The file jwt_secret hold the value for LFS_JWT_SECRET and JWT_SECRET
      # wasn't persistent at all.
      # To fix that, there is now the file oauth2_jwt_secret containing the
      # values for JWT_SECRET and the file jwt_secret gets renamed to
      # lfs_jwt_secret.
      # We have to consider this to stay compatible with older installations.
      preStart =
        let
          runConfig = "${cfg.customDir}/conf/app.ini";
          secretKey = "${cfg.customDir}/conf/secret_key";
          oauth2JwtSecret = "${cfg.customDir}/conf/oauth2_jwt_secret";
          oldLfsJwtSecret = "${cfg.customDir}/conf/jwt_secret"; # old file for LFS_JWT_SECRET
          lfsJwtSecret = "${cfg.customDir}/conf/lfs_jwt_secret"; # new file for LFS_JWT_SECRET
          internalToken = "${cfg.customDir}/conf/internal_token";
          replaceSecretBin = "${pkgs.replace-secret}/bin/replace-secret";
        in
        ''
          # copy custom configuration and generate random secrets if needed
          function gitea_setup {
            cp -f '${configFile}' '${runConfig}'

            if [ ! -s '${secretKey}' ]; then
                ${exe} generate secret SECRET_KEY > '${secretKey}'
            fi

            # Migrate LFS_JWT_SECRET filename
            if [[ -s '${oldLfsJwtSecret}' && ! -s '${lfsJwtSecret}' ]]; then
                mv '${oldLfsJwtSecret}' '${lfsJwtSecret}'
            fi

            if [ ! -s '${oauth2JwtSecret}' ]; then
                ${exe} generate secret JWT_SECRET > '${oauth2JwtSecret}'
            fi

            ${lib.optionalString cfg.lfs.enable ''
              if [ ! -s '${lfsJwtSecret}' ]; then
                  ${exe} generate secret LFS_JWT_SECRET > '${lfsJwtSecret}'
              fi
            ''}

            if [ ! -s '${internalToken}' ]; then
                ${exe} generate secret INTERNAL_TOKEN > '${internalToken}'
            fi

            chmod u+w '${runConfig}'
            ${replaceSecretBin} '#secretkey#' '${secretKey}' '${runConfig}'
            ${replaceSecretBin} '#dbpass#' '${cfg.database.passwordFile}' '${runConfig}'
            ${replaceSecretBin} '#oauth2jwtsecret#' '${oauth2JwtSecret}' '${runConfig}'
            ${replaceSecretBin} '#internaltoken#' '${internalToken}' '${runConfig}'

            ${lib.optionalString cfg.lfs.enable ''
              ${replaceSecretBin} '#lfsjwtsecret#' '${lfsJwtSecret}' '${runConfig}'
            ''}

            ${lib.optionalString (cfg.camoHmacKeyFile != null) ''
              ${replaceSecretBin} '#hmackey#' '${cfg.camoHmacKeyFile}' '${runConfig}'
            ''}

            ${lib.optionalString (cfg.mailerPasswordFile != null) ''
              ${replaceSecretBin} '#mailerpass#' '${cfg.mailerPasswordFile}' '${runConfig}'
            ''}

            ${lib.optionalString (cfg.metricsTokenFile != null) ''
              ${replaceSecretBin} '#metricstoken#' '${cfg.metricsTokenFile}' '${runConfig}'
            ''}

            ${lib.optionalString (cfg.minioAccessKeyId != null) ''
              ${replaceSecretBin} '#minioaccesskeyid#' '${cfg.minioAccessKeyId}' '${runConfig}'
            ''}
            ${lib.optionalString (cfg.minioSecretAccessKey != null) ''
              ${replaceSecretBin} '#miniosecretaccesskey#' '${cfg.minioSecretAccessKey}' '${runConfig}'
            ''}

            ${lib.optionalString (cfg.captcha.secretFile != null) ''
              ${replaceSecretBin} '#captchasecret#' '${cfg.captcha.secretFile}' '${runConfig}'
            ''}
            chmod u-w '${runConfig}'
          }
          (umask 027; gitea_setup)

          # run migrations/init the database
          ${exe} migrate

          # update all hooks' binary paths
          ${exe} admin regenerate hooks

          # update command option in authorized_keys
          if [ -r ${cfg.stateDir}/.ssh/authorized_keys ]
          then
            ${exe} admin regenerate keys
          fi
        '';

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = cfg.stateDir;
        ExecStart = "${exe} web --pid /run/gitea/gitea.pid";
        Restart = "always";
        # Runtime directory and mode
        RuntimeDirectory = "gitea";
        RuntimeDirectoryMode = "0755";
        # Proc filesystem
        ProcSubset = "pid";
        ProtectProc = "invisible";
        ReadOnlyPaths = [ "${cfg.customDir}/public" ];
        # Access write directories
        ReadWritePaths = [
          cfg.customDir
          cfg.dump.backupDir
          cfg.repositoryRoot
          cfg.stateDir
          cfg.lfs.contentDir
        ] ++ lib.optional (useSendmail && config.services.postfix.enable) "/var/lib/postfix/queue/maildrop";
        UMask = "0027";
        # Capabilities
        CapabilityBoundingSet = "";
        # Security
        NoNewPrivileges = !useSendmail;
        # Sandboxing
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        PrivateDevices = true;
        PrivateUsers = !useSendmail;
        ProtectHostname = true;
        ProtectClock = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
        ] ++ lib.optional (useSendmail && config.services.postfix.enable) "AF_NETLINK";
        RestrictNamespaces = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RemoveIPC = true;
        PrivateMounts = true;
        # System Call Filtering
        SystemCallArchitectures = "native";
        SystemCallFilter =
          [
            "~@cpu-emulation @debug @keyring @mount @obsolete @setuid"
            "setrlimit"
          ]
          ++ lib.optionals (!useSendmail) [
            "~@privileged"
          ];
      };

      environment = {
        USER = cfg.user;
        HOME = cfg.stateDir;
        GITEA_WORK_DIR = cfg.stateDir;
        GITEA_CUSTOM = cfg.customDir;
      };
    };

    users.users = lib.mkIf (cfg.user == "gitea") {
      gitea = {
        description = "Gitea Service";
        home = cfg.stateDir;
        useDefaultShell = true;
        group = cfg.group;
        isSystemUser = true;
      };
    };

    users.groups = lib.mkIf (cfg.group == "gitea") {
      gitea = {
        members = lib.optional cfg.configureNginx nginx.user;
      };
    };

    warnings =
      lib.optional (cfg.database.password != "")
        "config.${opt.database.password} will be stored as plaintext in the Nix store. Use database.passwordFile instead."
      ++ lib.optional (cfg.extraConfig != null) ''
        services.gitea.`extraConfig` is deprecated, please use services.gitea.`settings`.
      ''
      ++ lib.optional (lib.getName cfg.package == "forgejo") ''
        Running forgejo via services.gitea.package is no longer supported.
        Please use services.forgejo instead.
        See https://nixos.org/manual/nixos/unstable/#module-forgejo for migration instructions.
      '';

    # Create database passwordFile default when password is configured.
    services.gitea.database.passwordFile = lib.mkDefault (
      toString (
        pkgs.writeTextFile {
          name = "gitea-database-password";
          text = cfg.database.password;
        }
      )
    );

    systemd.services.gitea-dump = lib.mkIf cfg.dump.enable {
      description = "gitea dump";
      after = [ "gitea.service" ];
      path = [ cfg.package ];

      environment = {
        USER = cfg.user;
        HOME = cfg.stateDir;
        GITEA_WORK_DIR = cfg.stateDir;
        GITEA_CUSTOM = cfg.customDir;
      };

      serviceConfig = {
        Type = "oneshot";
        User = cfg.user;
        ExecStart =
          "${exe} dump --type ${cfg.dump.type}"
          + lib.optionalString (cfg.dump.file != null) " --file ${cfg.dump.file}";
        WorkingDirectory = cfg.dump.backupDir;
      };
    };

    systemd.timers.gitea-dump = lib.mkIf cfg.dump.enable {
      description = "Update timer for gitea-dump";
      partOf = [ "gitea-dump.service" ];
      wantedBy = [ "timers.target" ];
      timerConfig.OnCalendar = cfg.dump.interval;
    };
  };

  meta.maintainers = with lib.maintainers; [
    techknowlogick
    SuperSandro2000
  ];
}
