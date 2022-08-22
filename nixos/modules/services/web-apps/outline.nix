{ config, lib, pkgs, ...}:

let
  defaultUser = "outline";
  cfg = config.services.outline;
in
{
  # See here for a reference of all the options:
  #   https://github.com/outline/outline/blob/v0.65.2/.env.sample
  #   https://github.com/outline/outline/blob/v0.65.2/app.json
  #   https://github.com/outline/outline/blob/v0.65.2/server/env.ts
  #   https://github.com/outline/outline/blob/v0.65.2/shared/types.ts
  # The order is kept the same here to make updating easier.
  options.services.outline = {
    enable = lib.mkEnableOption "outline";

    package = lib.mkOption {
      default = pkgs.outline;
      defaultText = lib.literalExpression "pkgs.outline";
      type = lib.types.package;
      example = lib.literalExpression ''
        pkgs.outline.overrideAttrs (super: {
          # Ignore the domain part in emails that come from OIDC. This is might
          # be helpful if you want multiple users with different email providers
          # to still land in the same team. Note that this effectively makes
          # Outline a single-team instance.
          patchPhase = ${"''"}
            sed -i 's/const domain = parts\.length && parts\[1\];/const domain = "example.com";/g' server/routes/auth/providers/oidc.ts
          ${"''"};
        })
      '';
      description = "Outline package to use.";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = defaultUser;
      description = ''
        User under which the service should run. If this is the default value,
        the user will be created, with the specified group as the primary
        group.
      '';
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = defaultUser;
      description = ''
        Group under which the service should run. If this is the default value,
        the group will be created.
      '';
    };

    sequelizeArguments = lib.mkOption {
      type = lib.types.str;
      default = "";
      example = "--env=production-ssl-disabled";
      description = ''
        Optional arguments to pass to <literal>sequelize</literal> calls.
      '';
    };

    #
    # Required options
    #

    secretKeyFile = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/outline/secret_key";
      description = ''
        File path that contains the application secret key. It must be 32
        bytes long and hex-encoded. If the file does not exist, a new key will
        be generated and saved here.
      '';
    };

    utilsSecretFile = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/outline/utils_secret";
      description = ''
        File path that contains the utility secret key. If the file does not
        exist, a new key will be generated and saved here.
      '';
    };

    databaseUrl = lib.mkOption {
      type = lib.types.str;
      default = "local";
      description = ''
        URI to use for the main PostgreSQL database. If this needs to include
        credentials that shouldn't be world-readable in the Nix store, set an
        environment file on the systemd service and override the
        <literal>DATABASE_URL</literal> entry. Pass the string
        <literal>local</literal> to setup a database on the local server.
      '';
    };

    redisUrl = lib.mkOption {
      type = lib.types.str;
      default = "local";
      description = ''
        Connection to a redis server. If this needs to include credentials
        that shouldn't be world-readable in the Nix store, set an environment
        file on the systemd service and override the
        <literal>REDIS_URL</literal> entry. Pass the string
        <literal>local</literal> to setup a local Redis database.
      '';
    };

    publicUrl = lib.mkOption {
      type = lib.types.str;
      default = "http://localhost:3000";
      description = "The fully qualified, publicly accessible URL";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 3000;
      description = "Listening port.";
    };

    storage = lib.mkOption {
      description = ''
        To support uploading of images for avatars and document attachments an
        s3-compatible storage must be provided. AWS S3 is recommended for
        redundency however if you want to keep all file storage local an
        alternative such as <link xlink:href="https://github.com/minio/minio">minio</link>
        can be used.

        A more detailed guide on setting up S3 is available
        <link xlink:href="https://wiki.generaloutline.com/share/125de1cc-9ff6-424b-8415-0d58c809a40f">here</link>.
      '';
      example = lib.literalExpression ''
        {
          accessKey = "...";
          secretKeyFile = "/somewhere";
          uploadBucketUrl = "https://minio.example.com";
          uploadBucketName = "outline";
          region = "us-east-1";
        }
      '';
      type = lib.types.submodule {
        options = {
          accessKey = lib.mkOption {
            type = lib.types.str;
            description = "S3 access key.";
          };
          secretKeyFile = lib.mkOption {
            type = lib.types.path;
            description = "File path that contains the S3 secret key.";
          };
          region = lib.mkOption {
            type = lib.types.str;
            default = "xx-xxxx-x";
            description = "AWS S3 region name.";
          };
          uploadBucketUrl = lib.mkOption {
            type = lib.types.str;
            description = ''
              URL endpoint of an S3-compatible API where uploads should be
              stored.
            '';
          };
          uploadBucketName = lib.mkOption {
            type = lib.types.str;
            description = "Name of the bucket where uploads should be stored.";
          };
          uploadMaxSize = lib.mkOption {
            type = lib.types.int;
            default = 26214400;
            description = "Maxmium file size for uploads.";
          };
          forcePathStyle = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Force S3 path style.";
          };
          acl = lib.mkOption {
            type = lib.types.str;
            default = "private";
            description = "ACL setting.";
          };
        };
      };
    };

    #
    # Authentication
    #

    slackAuthentication = lib.mkOption {
      description = ''
        To configure Slack auth, you'll need to create an Application at
        https://api.slack.com/apps

        When configuring the Client ID, add a redirect URL under "OAuth &amp; Permissions"
        to <literal>https://[publicUrl]/auth/slack.callback</literal>.
      '';
      default = null;
      type = lib.types.nullOr (lib.types.submodule {
        options = {
          clientId = lib.mkOption {
            type = lib.types.str;
            description = "Authentication key.";
          };
          secretFile = lib.mkOption {
            type = lib.types.str;
            description = "File path containing the authentication secret.";
          };
        };
      });
    };

    googleAuthentication = lib.mkOption {
      description = ''
        To configure Google auth, you'll need to create an OAuth Client ID at
        https://console.cloud.google.com/apis/credentials

        When configuring the Client ID, add an Authorized redirect URI to
        <literal>https://[publicUrl]/auth/google.callback</literal>.
      '';
      default = null;
      type = lib.types.nullOr (lib.types.submodule {
        options = {
          clientId = lib.mkOption {
            type = lib.types.str;
            description = "Authentication client identifier.";
          };
          clientSecretFile = lib.mkOption {
            type = lib.types.str;
            description = "File path containing the authentication secret.";
          };
        };
      });
    };

    azureAuthentication = lib.mkOption {
      description = ''
        To configure Microsoft/Azure auth, you'll need to create an OAuth
        Client. See
        <link xlink:href="https://wiki.generaloutline.com/share/dfa77e56-d4d2-4b51-8ff8-84ea6608faa4">the guide</link>
        for details on setting up your Azure App.
      '';
      default = null;
      type = lib.types.nullOr (lib.types.submodule {
        options = {
          clientId = lib.mkOption {
            type = lib.types.str;
            description = "Authentication client identifier.";
          };
          clientSecretFile = lib.mkOption {
            type = lib.types.str;
            description = "File path containing the authentication secret.";
          };
          resourceAppId = lib.mkOption {
            type = lib.types.str;
            description = "Authentication application resource ID.";
          };
        };
      });
    };

    oidcAuthentication = lib.mkOption {
      description = ''
        To configure generic OIDC auth, you'll need some kind of identity
        provider. See the documentation for whichever IdP you use to fill out
        all the fields. The redirect URL is
        <literal>https://[publicUrl]/auth/oidc.callback</literal>.
      '';
      default = null;
      type = lib.types.nullOr (lib.types.submodule {
        options = {
          clientId = lib.mkOption {
            type = lib.types.str;
            description = "Authentication client identifier.";
          };
          clientSecretFile = lib.mkOption {
            type = lib.types.str;
            description = "File path containing the authentication secret.";
          };
          authUrl = lib.mkOption {
            type = lib.types.str;
            description = "OIDC authentication URL endpoint.";
          };
          tokenUrl = lib.mkOption {
            type = lib.types.str;
            description = "OIDC token URL endpoint.";
          };
          userinfoUrl = lib.mkOption {
            type = lib.types.str;
            description = "OIDC userinfo URL endpoint.";
          };
          usernameClaim = lib.mkOption {
            type = lib.types.str;
            description = ''
              Specify which claims to derive user information from. Supports any
              valid JSON path with the JWT payload
            '';
            default = "preferred_username";
          };
          displayName = lib.mkOption {
            type = lib.types.str;
            description = "Display name for OIDC authentication.";
            default = "OpenID";
          };
          scopes = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            description = "OpenID authentication scopes.";
            default = [ "openid" "profile" "email" ];
          };
        };
      });
    };

    #
    # Optional configuration
    #

    sslKeyFile = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        File path that contains the Base64-encoded private key for HTTPS
        termination. This is only required if you do not use an external reverse
        proxy. See
        <link xlink:href="https://wiki.generaloutline.com/share/dfa77e56-d4d2-4b51-8ff8-84ea6608faa4">the documentation</link>.
      '';
    };
    sslCertFile = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        File path that contains the Base64-encoded certificate for HTTPS
        termination. This is only required if you do not use an external reverse
        proxy. See
        <link xlink:href="https://wiki.generaloutline.com/share/dfa77e56-d4d2-4b51-8ff8-84ea6608faa4">the documentation</link>.
      '';
    };

    cdnUrl = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = ''
        If using a Cloudfront/Cloudflare distribution or similar it can be set
        using this option. This will cause paths to JavaScript files,
        stylesheets and images to be updated to the hostname defined here. In
        your CDN configuration the origin server should be set to public URL.
      '';
    };

    forceHttps = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Auto-redirect to HTTPS in production. The default is
        <literal>true</literal> but you may set this to <literal>false</literal>
        if you can be sure that SSL is terminated at an external loadbalancer.
      '';
    };

    enableUpdateCheck = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Have the installation check for updates by sending anonymized statistics
        to the maintainers.
      '';
    };

    concurrency = lib.mkOption {
      type = lib.types.int;
      default = 1;
      description = ''
        How many processes should be spawned. For a rough estimate, divide your
        server's available memory by 512.
      '';
    };

    maximumImportSize = lib.mkOption {
      type = lib.types.int;
      default = 5120000;
      description = ''
        The maximum size of document imports. Overriding this could be required
        if you have especially large Word documents with embedded imagery.
      '';
    };

    debugOutput = lib.mkOption {
      type = lib.types.nullOr (lib.types.enum [ "http" ]);
      default = null;
      description = "Set this to <literal>http</literal> log HTTP requests.";
    };

    slackIntegration = lib.mkOption {
      description = ''
        For a complete Slack integration with search and posting to channels
        this configuration is also needed. See here for details:
        https://wiki.generaloutline.com/share/be25efd1-b3ef-4450-b8e5-c4a4fc11e02a
      '';
      default = null;
      type = lib.types.nullOr (lib.types.submodule {
        options = {
          verificationTokenFile = lib.mkOption {
            type = lib.types.str;
            description = "File path containing the verification token.";
          };
          appId = lib.mkOption {
            type = lib.types.str;
            description = "Application ID.";
          };
          messageActions = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Whether to enable message actions.";
          };
        };
      });
    };

    googleAnalyticsId = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        Optionally enable Google Analytics to track page views in the knowledge
        base.
      '';
    };

    sentryDsn = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        Optionally enable <link xlink:href="https://sentry.io/">Sentry</link> to
        track errors and performance.
      '';
    };

    logo = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        Custom logo displayed on the authentication screen. This will be scaled
        to a height of 60px.
      '';
    };

    smtp = lib.mkOption {
      description = ''
        To support sending outgoing transactional emails such as
        "document updated" or "you've been invited" you'll need to provide
        authentication for an SMTP server.
      '';
      default = null;
      type = lib.types.nullOr (lib.types.submodule {
        options = {
          host = lib.mkOption {
            type = lib.types.str;
            description = "Host name or IP adress of the SMTP server.";
          };
          port = lib.mkOption {
            type = lib.types.port;
            description = "TCP port of the SMTP server.";
          };
          username = lib.mkOption {
            type = lib.types.str;
            description = "Username to authenticate with.";
          };
          passwordFile = lib.mkOption {
            type = lib.types.str;
            description = ''
              File path containing the password to authenticate with.
            '';
          };
          fromEmail = lib.mkOption {
            type = lib.types.str;
            description = "Sender email in outgoing mail.";
          };
          replyEmail = lib.mkOption {
            type = lib.types.str;
            description = "Reply address in outgoing mail.";
          };
          tlsCiphers = lib.mkOption {
            type = lib.types.str;
            default = "";
            description = "Override SMTP cipher configuration.";
          };
          secure = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Use a secure SMTP connection.";
          };
        };
      });
    };

    defaultLanguage = lib.mkOption {
      type = lib.types.enum [
         "da_DK"
         "de_DE"
         "en_US"
         "es_ES"
         "fa_IR"
         "fr_FR"
         "it_IT"
         "ja_JP"
         "ko_KR"
         "nl_NL"
         "pl_PL"
         "pt_BR"
         "pt_PT"
         "ru_RU"
         "sv_SE"
         "th_TH"
         "vi_VN"
         "zh_CN"
         "zh_TW"
      ];
      default = "en_US";
      description = ''
        The default interface language. See
        <link xlink:href="https://translate.getoutline.com/">translate.getoutline.com</link>
        for a list of available language codes and their rough percentage
        translated.
      '';
    };

    rateLimiter.enable = lib.mkEnableOption "rate limiter for the application web server";
    rateLimiter.requests = lib.mkOption {
      type = lib.types.int;
      default = 5000;
      description = "Maximum number of requests in a throttling window.";
    };
    rateLimiter.durationWindow = lib.mkOption {
      type = lib.types.int;
      default = 60;
      description = "Length of a throttling window.";
    };
  };

  config = lib.mkIf cfg.enable {
    users.users = lib.optionalAttrs (cfg.user == defaultUser) {
      ${defaultUser} = {
        isSystemUser = true;
        group = cfg.group;
      };
    };

    users.groups = lib.optionalAttrs (cfg.group == defaultUser) {
      ${defaultUser} = { };
    };

    systemd.tmpfiles.rules = [
      "f ${cfg.secretKeyFile} 0600 ${cfg.user} ${cfg.group} -"
      "f ${cfg.utilsSecretFile} 0600 ${cfg.user} ${cfg.group} -"
      "f ${cfg.storage.secretKeyFile} 0600 ${cfg.user} ${cfg.group} -"
    ];

    services.postgresql = lib.mkIf (cfg.databaseUrl == "local") {
      enable = true;
      ensureUsers = [{
        name = "outline";
        ensurePermissions."DATABASE outline" = "ALL PRIVILEGES";
      }];
      ensureDatabases = [ "outline" ];
    };

    services.redis.servers.outline = lib.mkIf (cfg.redisUrl == "local") {
      enable = true;
      user = config.services.outline.user;
      port = 0; # Disable the TCP listener
    };

    systemd.services.outline = let
      localRedisUrl = "redis+unix:///run/redis-outline/redis.sock";
      localPostgresqlUrl = "postgres://localhost/outline?host=/run/postgresql";

      # Create an outline-sequalize wrapper (a wrapper around the wrapper) that
      # has the config file's path baked in. This is necessary because there is
      # at least one occurrence of outline calling this from its own code.
      sequelize = pkgs.writeShellScriptBin "outline-sequelize" ''
        exec ${cfg.package}/bin/outline-sequelize \
          --config $RUNTIME_DIRECTORY/database.json \
          ${cfg.sequelizeArguments} \
          "$@"
      '';
    in {
      description = "Outline wiki and knowledge base";
      wantedBy = [ "multi-user.target" ];
      after = [ "networking.target" ]
        ++ lib.optional (cfg.databaseUrl == "local") "postgresql.service"
        ++ lib.optional (cfg.redisUrl == "local") "redis-outline.service";
      requires = lib.optional (cfg.databaseUrl == "local") "postgresql.service"
        ++ lib.optional (cfg.redisUrl == "local") "redis-outline.service";
      path = [
        pkgs.openssl # Required by the preStart script
        sequelize
      ];


      environment = lib.mkMerge [
        {
          NODE_ENV = "production";

          REDIS_URL = if cfg.redisUrl == "local" then localRedisUrl else cfg.redisUrl;
          URL = cfg.publicUrl;
          PORT = builtins.toString cfg.port;

          AWS_ACCESS_KEY_ID = cfg.storage.accessKey;
          AWS_REGION = cfg.storage.region;
          AWS_S3_UPLOAD_BUCKET_URL = cfg.storage.uploadBucketUrl;
          AWS_S3_UPLOAD_BUCKET_NAME = cfg.storage.uploadBucketName;
          AWS_S3_UPLOAD_MAX_SIZE = builtins.toString cfg.storage.uploadMaxSize;
          AWS_S3_FORCE_PATH_STYLE = builtins.toString cfg.storage.forcePathStyle;
          AWS_S3_ACL = cfg.storage.acl;

          CDN_URL = cfg.cdnUrl;
          FORCE_HTTPS = builtins.toString cfg.forceHttps;
          ENABLE_UPDATES = builtins.toString cfg.enableUpdateCheck;
          WEB_CONCURRENCY = builtins.toString cfg.concurrency;
          MAXIMUM_IMPORT_SIZE = builtins.toString cfg.maximumImportSize;
          DEBUG = cfg.debugOutput;
          GOOGLE_ANALYTICS_ID = lib.optionalString (cfg.googleAnalyticsId != null) cfg.googleAnalyticsId;
          SENTRY_DSN = lib.optionalString (cfg.sentryDsn != null) cfg.sentryDsn;
          TEAM_LOGO = lib.optionalString (cfg.logo != null) cfg.logo;
          DEFAULT_LANGUAGE = cfg.defaultLanguage;

          RATE_LIMITER_ENABLED = builtins.toString cfg.rateLimiter.enable;
          RATE_LIMITER_REQUESTS = builtins.toString cfg.rateLimiter.requests;
          RATE_LIMITER_DURATION_WINDOW = builtins.toString cfg.rateLimiter.durationWindow;
        }

        (lib.mkIf (cfg.slackAuthentication != null) {
          SLACK_CLIENT_ID = cfg.slackAuthentication.clientId;
        })

        (lib.mkIf (cfg.googleAuthentication != null) {
          GOOGLE_CLIENT_ID = cfg.googleAuthentication.clientId;
        })

        (lib.mkIf (cfg.azureAuthentication != null) {
          AZURE_CLIENT_ID = cfg.azureAuthentication.clientId;
          AZURE_RESOURCE_APP_ID = cfg.azureAuthentication.resourceAppId;
        })

        (lib.mkIf (cfg.oidcAuthentication != null) {
          OIDC_CLIENT_ID = cfg.oidcAuthentication.clientId;
          OIDC_AUTH_URI = cfg.oidcAuthentication.authUrl;
          OIDC_TOKEN_URI = cfg.oidcAuthentication.tokenUrl;
          OIDC_USERINFO_URI = cfg.oidcAuthentication.userinfoUrl;
          OIDC_USERNAME_CLAIM = cfg.oidcAuthentication.usernameClaim;
          OIDC_DISPLAY_NAME = cfg.oidcAuthentication.displayName;
          OIDC_SCOPES = lib.concatStringsSep " " cfg.oidcAuthentication.scopes;
        })

        (lib.mkIf (cfg.slackIntegration != null) {
          SLACK_APP_ID = cfg.slackIntegration.appId;
          SLACK_MESSAGE_ACTIONS = builtins.toString cfg.slackIntegration.messageActions;
        })

        (lib.mkIf (cfg.smtp != null) {
          SMTP_HOST = cfg.smtp.host;
          SMTP_PORT = builtins.toString cfg.smtp.port;
          SMTP_USERNAME = cfg.smtp.username;
          SMTP_FROM_EMAIL = cfg.smtp.fromEmail;
          SMTP_REPLY_EMAIL = cfg.smtp.replyEmail;
          SMTP_TLS_CIPHERS = cfg.smtp.tlsCiphers;
          SMTP_SECURE = builtins.toString cfg.smtp.secure;
        })
      ];

      preStart = ''
        if [ ! -s ${lib.escapeShellArg cfg.secretKeyFile} ]; then
          openssl rand -hex 32 > ${lib.escapeShellArg cfg.secretKeyFile}
        fi
        if [ ! -s ${lib.escapeShellArg cfg.utilsSecretFile} ]; then
          openssl rand -hex 32 > ${lib.escapeShellArg cfg.utilsSecretFile}
        fi

        # The config file is required for the CLI, the DATABASE_URL environment
        # variable is read by the app.
        ${if (cfg.databaseUrl == "local") then ''
          cat <<EOF > $RUNTIME_DIRECTORY/database.json
          {
            "production": {
              "dialect": "postgres",
              "host": "/run/postgresql",
              "username": null,
              "password": null
            }
          }
          EOF
          export DATABASE_URL=${lib.escapeShellArg localPostgresqlUrl}
          export PGSSLMODE=disable
        '' else ''
          cat <<EOF > $RUNTIME_DIRECTORY/database.json
          {
            "production": {
              "use_env_variable": "DATABASE_URL",
              "dialect": "postgres",
              "dialectOptions": {
                "ssl": {
                  "rejectUnauthorized": false
                }
              }
            },
            "production-ssl-disabled": {
              "use_env_variable": "DATABASE_URL",
              "dialect": "postgres"
            }
          }
          EOF
          export DATABASE_URL=${lib.escapeShellArg cfg.databaseUrl}
        ''}

        cd $RUNTIME_DIRECTORY
        ${sequelize}/bin/outline-sequelize db:migrate
      '';

      script = ''
        export SECRET_KEY="$(head -n1 ${lib.escapeShellArg cfg.secretKeyFile})"
        export UTILS_SECRET="$(head -n1 ${lib.escapeShellArg cfg.utilsSecretFile})"
        export AWS_SECRET_ACCESS_KEY="$(head -n1 ${lib.escapeShellArg cfg.storage.secretKeyFile})"
        ${lib.optionalString (cfg.slackAuthentication != null) ''
          export SLACK_CLIENT_SECRET="$(head -n1 ${lib.escapeShellArg cfg.slackAuthentication.secretFile})"
        ''}
        ${lib.optionalString (cfg.googleAuthentication != null) ''
          export GOOGLE_CLIENT_SECRET="$(head -n1 ${lib.escapeShellArg cfg.googleAuthentication.clientSecretFile})"
        ''}
        ${lib.optionalString (cfg.azureAuthentication != null) ''
          export AZURE_CLIENT_SECRET="$(head -n1 ${lib.escapeShellArg cfg.azureAuthentication.clientSecretFile})"
        ''}
        ${lib.optionalString (cfg.oidcAuthentication != null) ''
          export OIDC_CLIENT_SECRET="$(head -n1 ${lib.escapeShellArg cfg.oidcAuthentication.clientSecretFile})"
        ''}
        ${lib.optionalString (cfg.sslKeyFile != null) ''
          export SSL_KEY="$(head -n1 ${lib.escapeShellArg cfg.sslKeyFile})"
        ''}
        ${lib.optionalString (cfg.sslCertFile != null) ''
          export SSL_CERT="$(head -n1 ${lib.escapeShellArg cfg.sslCertFile})"
        ''}
        ${lib.optionalString (cfg.slackIntegration != null) ''
          export SLACK_VERIFICATION_TOKEN="$(head -n1 ${lib.escapeShellArg cfg.slackIntegration.verificationTokenFile})"
        ''}
        ${lib.optionalString (cfg.smtp != null) ''
          export SMTP_PASSWORD="$(head -n1 ${lib.escapeShellArg cfg.smtp.passwordFile})"
        ''}

        ${if (cfg.databaseUrl == "local") then ''
          export DATABASE_URL=${lib.escapeShellArg localPostgresqlUrl}
          export PGSSLMODE=disable
        '' else ''
          export DATABASE_URL=${lib.escapeShellArg cfg.databaseUrl}
        ''}

        ${cfg.package}/bin/outline-server
      '';

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        Restart = "always";
        ProtectSystem = "strict";
        PrivateHome = true;
        PrivateTmp = true;
        UMask = "0007";

        StateDirectory = "outline";
        StateDirectoryMode = "0750";
        RuntimeDirectory = "outline";
        RuntimeDirectoryMode = "0750";
        # This working directory is required to find stuff like the set of
        # onboarding files:
        WorkingDirectory = "${cfg.package}/share/outline/build";
      };
    };
  };
}
