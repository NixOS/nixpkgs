{ config, lib, pkgs, ...}:

let
  defaultUser = "outline";
  cfg = config.services.outline;
  inherit (lib) mkRemovedOptionModule;
in
{
  imports = [
    (mkRemovedOptionModule [ "services" "outline" "sequelizeArguments" ] "Database migration are run agains configurated database by outline directly")
  ];
  # See here for a reference of all the options:
  #   https://github.com/outline/outline/blob/v0.67.0/.env.sample
  #   https://github.com/outline/outline/blob/v0.67.0/app.json
  #   https://github.com/outline/outline/blob/v0.67.0/server/env.ts
  #   https://github.com/outline/outline/blob/v0.67.0/shared/types.ts
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
            sed -i 's/const domain = parts\.length && parts\[1\];/const domain = "example.com";/g' plugins/oidc/server/auth/oidc.ts
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
        `DATABASE_URL` entry. Pass the string
        `local` to setup a database on the local server.
      '';
    };

    redisUrl = lib.mkOption {
      type = lib.types.str;
      default = "local";
      description = ''
        Connection to a redis server. If this needs to include credentials
        that shouldn't be world-readable in the Nix store, set an environment
        file on the systemd service and override the
        `REDIS_URL` entry. Pass the string
        `local` to setup a local Redis database.
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
        s3-compatible storage can be provided. AWS S3 is recommended for
        redundancy however if you want to keep all file storage local an
        alternative such as [minio](https://github.com/minio/minio)
        can be used.
        Local filesystem storage can also be used.

        A more detailed guide on setting up storage is available
        [here](https://docs.getoutline.com/s/hosting/doc/file-storage-N4M0T6Ypu7).
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
          storageType = lib.mkOption {
            type = lib.types.enum [ "local" "s3" ];
            description = "File storage type, it can be local or s3.";
            default = "s3";
          };
          localRootDir = lib.mkOption {
            type = lib.types.str;
            description = ''
              If `storageType` is `local`, this sets the parent directory
              under which all attachments/images go.
            '';
            default = "/var/lib/outline/data";
          };
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

        When configuring the Client ID, add a redirect URL under "OAuth & Permissions"
        to `https://[publicUrl]/auth/slack.callback`.
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
        `https://[publicUrl]/auth/google.callback`.
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
        [the guide](https://wiki.generaloutline.com/share/dfa77e56-d4d2-4b51-8ff8-84ea6608faa4)
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
        `https://[publicUrl]/auth/oidc.callback`.
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
        [the documentation](https://wiki.generaloutline.com/share/dfa77e56-d4d2-4b51-8ff8-84ea6608faa4).
      '';
    };
    sslCertFile = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        File path that contains the Base64-encoded certificate for HTTPS
        termination. This is only required if you do not use an external reverse
        proxy. See
        [the documentation](https://wiki.generaloutline.com/share/dfa77e56-d4d2-4b51-8ff8-84ea6608faa4).
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
        `true` but you may set this to `false`
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
      description = "Set this to `http` log HTTP requests.";
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
        Optionally enable [Sentry](https://sentry.io/) to
        track errors and performance.
      '';
    };

    sentryTunnel = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        Optionally add a
        [Sentry proxy tunnel](https://docs.sentry.io/platforms/javascript/troubleshooting/#using-the-tunnel-option)
        for bypassing ad blockers in the UI.
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
            description = "Host name or IP address of the SMTP server.";
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
        [translate.getoutline.com](https://translate.getoutline.com/)
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
      (if (cfg.storage.storageType == "s3") then
        "f ${cfg.storage.secretKeyFile} 0600 ${cfg.user} ${cfg.group} -"
      else
        "d ${cfg.storage.localRootDir} 0700 ${cfg.user} ${cfg.group} - -")
    ];

    services.postgresql = lib.mkIf (cfg.databaseUrl == "local") {
      enable = true;
      ensureUsers = [{
        name = "outline";
        ensureDBOwnership = true;
      }];
      ensureDatabases = [ "outline" ];
    };

    # Outline is unable to create the uuid-ossp extension when using postgresql 12, in later version this
    # extension can be created without superuser permission. This services therefor this extension before
    # outline starts and postgresql 12 is using on the host.
    #
    # Can be removed after postgresql 12 is dropped from nixos.
    systemd.services.outline-postgresql =
      let
        pgsql = config.services.postgresql;
      in
        lib.mkIf (cfg.databaseUrl == "local" && pgsql.package == pkgs.postgresql_12) {
          after = [ "postgresql.service" ];
          bindsTo = [ "postgresql.service" ];
          wantedBy = [ "outline.service" ];
          partOf = [ "outline.service" ];
          path = [
            pgsql.package
          ];
          script = ''
            set -o errexit -o pipefail -o nounset -o errtrace
            shopt -s inherit_errexit

            psql outline -tAc 'CREATE EXTENSION IF NOT EXISTS "uuid-ossp"'
          '';

          serviceConfig = {
            User = pgsql.superUser;
            Type = "oneshot";
            RemainAfterExit = true;
          };
        };

    services.redis.servers.outline = lib.mkIf (cfg.redisUrl == "local") {
      enable = true;
      user = config.services.outline.user;
      port = 0; # Disable the TCP listener
    };

    systemd.services.outline = let
      localRedisUrl = "redis+unix:///run/redis-outline/redis.sock";
      localPostgresqlUrl = "postgres://localhost/outline?host=/run/postgresql";
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
      ];


      environment = lib.mkMerge [
        {
          NODE_ENV = "production";

          REDIS_URL = if cfg.redisUrl == "local" then localRedisUrl else cfg.redisUrl;
          URL = cfg.publicUrl;
          PORT = builtins.toString cfg.port;

          CDN_URL = cfg.cdnUrl;
          FORCE_HTTPS = builtins.toString cfg.forceHttps;
          ENABLE_UPDATES = builtins.toString cfg.enableUpdateCheck;
          WEB_CONCURRENCY = builtins.toString cfg.concurrency;
          MAXIMUM_IMPORT_SIZE = builtins.toString cfg.maximumImportSize;
          DEBUG = cfg.debugOutput;
          GOOGLE_ANALYTICS_ID = lib.optionalString (cfg.googleAnalyticsId != null) cfg.googleAnalyticsId;
          SENTRY_DSN = lib.optionalString (cfg.sentryDsn != null) cfg.sentryDsn;
          SENTRY_TUNNEL = lib.optionalString (cfg.sentryTunnel != null) cfg.sentryTunnel;
          TEAM_LOGO = lib.optionalString (cfg.logo != null) cfg.logo;
          DEFAULT_LANGUAGE = cfg.defaultLanguage;

          RATE_LIMITER_ENABLED = builtins.toString cfg.rateLimiter.enable;
          RATE_LIMITER_REQUESTS = builtins.toString cfg.rateLimiter.requests;
          RATE_LIMITER_DURATION_WINDOW = builtins.toString cfg.rateLimiter.durationWindow;

          FILE_STORAGE = cfg.storage.storageType;
          FILE_STORAGE_UPLOAD_MAX_SIZE = builtins.toString cfg.storage.uploadMaxSize;
          FILE_STORAGE_LOCAL_ROOT_DIR = cfg.storage.localRootDir;
        }

        (lib.mkIf (cfg.storage.storageType == "s3") {
          AWS_ACCESS_KEY_ID = cfg.storage.accessKey;
          AWS_REGION = cfg.storage.region;
          AWS_S3_UPLOAD_BUCKET_URL = cfg.storage.uploadBucketUrl;
          AWS_S3_UPLOAD_BUCKET_NAME = cfg.storage.uploadBucketName;
          AWS_S3_FORCE_PATH_STYLE = builtins.toString cfg.storage.forcePathStyle;
          AWS_S3_ACL = cfg.storage.acl;
        })

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

      '';

      script = ''
        export SECRET_KEY="$(head -n1 ${lib.escapeShellArg cfg.secretKeyFile})"
        export UTILS_SECRET="$(head -n1 ${lib.escapeShellArg cfg.utilsSecretFile})"
        ${lib.optionalString (cfg.storage.storageType == "s3") ''
          export AWS_SECRET_ACCESS_KEY="$(head -n1 ${lib.escapeShellArg cfg.storage.secretKeyFile})"
        ''}
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
        WorkingDirectory = "${cfg.package}/share/outline";
        # In case this directory is not in /var/lib/outline, it needs to be made writable explicitly
        ReadWritePaths = lib.mkIf (cfg.storage.storageType == "local") [ cfg.storage.localRootDir ];
      };
    };
  };
}
