{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    mkMerge
    mkDefault
    optional
    types
    ;

  cfg = config.services.simplelogin;

in
{
  options.services.simplelogin = {
    enable = mkEnableOption "SimpleLogin email alias service";

    package = mkPackageOption pkgs "simplelogin" { };

    hostName = mkOption {
      type = types.str;
      example = "app.example.com";
      description = "The public hostname of the SimpleLogin instance. Used for nginx virtual host and default URL.";
    };

    url = mkOption {
      type = types.str;
      defaultText = lib.literalExpression ''"https/''${config.services.simplelogin.hostName}"'';
      description = "Public URL of the SimpleLogin instance, used in links sent in email.";
    };

    emailDomain = mkOption {
      type = types.str;
      example = "example.com";
      description = "The domain used for email aliases.";
    };

    supportEmail = mkOption {
      type = types.str;
      defaultText = lib.literalExpression ''"support/''${config.services.simplelogin.emailDomain}"'';
      description = "Email address for support messages sent by the application.";
    };

    flaskSecret = mkOption {
      type = types.str;
      example = "0123456789abcdef0123456789abcdef";
      description = "Secret key for Flask session signing. Must be at least 32 characters.";
    };

    dkimKeyFile = mkOption {
      type = types.path;
      description = "Path to the DKIM private key file.";
    };

    secretFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        Path to a file containing extra environment variables for secrets and
        overrides, loaded after the generated config. Useful for supplying
        credentials that should not appear in the Nix store.
      '';
    };

    settings = mkOption {
      type = types.attrsOf types.anything;
      default = { };
      example = {
        NOT_SEND_EMAIL = true;
        DISABLE_REGISTRATION = true;
      };
      description = "Extra settings to be added to the SimpleLogin configuration environment.";
    };

    database = {
      createLocally = mkOption {
        type = types.bool;
        default = true;
        description = "Create and manage a local PostgreSQL database for SimpleLogin.";
      };
      name = mkOption {
        type = types.str;
        default = "simplelogin";
        description = "Name of the PostgreSQL database.";
      };
      user = mkOption {
        type = types.str;
        default = "simplelogin";
        description = "PostgreSQL user that owns the database.";
      };
      uri = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Full database URI. Only needed when {option}`createLocally` is false.";
      };
      passwordFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = "Not yet implemented; reserved for future use.";
      };
    };

    web = {
      address = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = "IP address the gunicorn web server binds to.";
      };
      port = mkOption {
        type = types.port;
        default = 7777;
        description = "Port the gunicorn web server listens on.";
      };
      workers = mkOption {
        type = types.int;
        default = 2;
        description = "Number of gunicorn worker processes.";
      };
      timeout = mkOption {
        type = types.int;
        default = 15;
        description = "Gunicorn worker timeout in seconds.";
      };
    };

    nginx = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Configure nginx as a reverse proxy for SimpleLogin.";
      };
      forceSSL = mkOption {
        type = types.bool;
        default = true;
        description = "Redirect all HTTP requests to HTTPS.";
      };
      enableACME = mkOption {
        type = types.bool;
        default = true;
        description = "Automatically obtain and renew TLS certificates via ACME.";
      };
    };

    mail = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable the SimpleLogin SMTP email handler.";
      };
      listenAddress = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = "Address the email handler SMTP server listens on.";
      };
      listenPort = mkOption {
        type = types.port;
        default = 20381;
        description = "Port the email handler SMTP server listens on.";
      };
      postfixHost = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = "Hostname of the Postfix relay.";
      };
      postfixPort = mkOption {
        type = types.port;
        default = 25;
        description = "Port of the Postfix relay.";
      };
      emailServersWithPriority = mkOption {
        type = types.listOf (
          types.submodule {
            options = {
              priority = mkOption {
                type = types.int;
                description = "MX priority for this mail server.";
              };
              host = mkOption {
                type = types.str;
                description = "Hostname of the mail server.";
              };
            };
          }
        );
        defaultText = lib.literalExpression ''
          [ { priority = 10; host = "''${config.services.simplelogin.hostName}."; } ]
        '';
        description = "List of mail servers used for MX entries, in order of priority.";
      };
      configurePostfix = mkOption {
        type = types.bool;
        default = true;
        description = "Automatically configure Postfix to route emails to the SimpleLogin email handler.";
      };
    };

    jobRunner.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable the background job runner service.";
    };
    eventListener.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable the event listener service.";
    };
    eventListener.mode = mkOption {
      type = types.enum [
        "listener"
        "dead_letter"
      ];
      default = "listener";
      description = "Operating mode for the event listener.";
    };
    monitoring.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable the monitoring/metrics exporter service.";
    };
  };

  config = mkIf cfg.enable (
    let
      dbUri =
        if cfg.database.createLocally then
          "postgresql:///${cfg.database.name}"
        else if cfg.database.passwordFile != null then
          throw "services.simplelogin.database.passwordFile support should be implemented with a generated runtime env file"
        else
          cfg.database.uri;

      defaultSettings = {
        URL = cfg.url;
        EMAIL_DOMAIN = cfg.emailDomain;
        SUPPORT_EMAIL = cfg.supportEmail;
        DB_URI = dbUri;
        FLASK_SECRET = cfg.flaskSecret;
        LOCAL_FILE_UPLOAD = true;
        DISABLE_ALIAS_SUFFIX = true;
        GNUPGHOME = "/var/lib/simplelogin/pgp";
        POSTFIX_SERVER = cfg.mail.postfixHost;
        POSTFIX_PORT = cfg.mail.postfixPort;
        EMAIL_SERVERS_WITH_PRIORITY = map (x: [
          x.priority
          x.host
        ]) cfg.mail.emailServersWithPriority;
        DKIM_PRIVATE_KEY_PATH = cfg.dkimKeyFile;
        OPENID_PRIVATE_KEY_PATH = "${cfg.package}/share/simplelogin/local_data/jwtRS256.key";
        OPENID_PUBLIC_KEY_PATH = "${cfg.package}/share/simplelogin/local_data/jwtRS256.key.pub";
        WORDS_FILE_PATH = "${cfg.package}/share/simplelogin/local_data/words.txt";
      };

      renderedEnv = lib.generators.toKeyValue {
        mkValueString =
          v:
          if builtins.isBool v then
            (if v then "1" else null)
          else if builtins.isInt v || builtins.isFloat v then
            toString v
          else if builtins.isList v || builtins.isAttrs v then
            builtins.toJSON v
          else
            toString v;
      } (lib.filterAttrs (n: v: v != null) (defaultSettings // cfg.settings));

      envFile = pkgs.writeText "simplelogin.env" renderedEnv;
      webEnv = envFile;
    in
    mkMerge [
      {
        services.simplelogin.url = mkDefault "https://${cfg.hostName}";
        services.simplelogin.supportEmail = mkDefault "support@${cfg.emailDomain}";
        services.simplelogin.mail.emailServersWithPriority = mkDefault [
          {
            priority = 10;
            host = "${cfg.hostName}.";
          }
        ];

        users.users.simplelogin = {
          isSystemUser = true;
          group = "simplelogin";
        };
        users.groups.simplelogin = { };

        systemd.services.simplelogin-setup = {
          description = "SimpleLogin Setup";
          wantedBy = [ "multi-user.target" ];
          after = optional cfg.database.createLocally "postgresql.service";
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            User = "simplelogin";
            Group = "simplelogin";
            StateDirectory = "simplelogin";
            WorkingDirectory = "/var/lib/simplelogin";
            EnvironmentFile = [ webEnv ] ++ optional (cfg.secretFile != null) cfg.secretFile;
            ExecStartPre = [
              "${pkgs.coreutils}/bin/mkdir -p /var/lib/simplelogin/pgp /var/lib/simplelogin/upload"
            ];
            ExecStart = [
              "${cfg.package}/bin/simplelogin-db-upgrade"
              "${cfg.package}/bin/simplelogin-init-app"
            ];
            NoNewPrivileges = true;
            PrivateTmp = true;
            ProtectSystem = "strict";
            ReadWritePaths = [ "/var/lib/simplelogin" ];
          };
        };

        systemd.services.simplelogin-web = {
          description = "SimpleLogin Web Service";
          wantedBy = [ "multi-user.target" ];
          after = [
            "network.target"
            "simplelogin-setup.service"
          ];
          requires = [ "simplelogin-setup.service" ];
          serviceConfig = {
            User = "simplelogin";
            Group = "simplelogin";
            WorkingDirectory = "/var/lib/simplelogin";
            StateDirectory = "simplelogin";
            EnvironmentFile = [ webEnv ] ++ optional (cfg.secretFile != null) cfg.secretFile;
            ExecStart = ''
              ${cfg.package}/bin/simplelogin-web -b ${cfg.web.address}:${toString cfg.web.port} -w ${toString cfg.web.workers} --timeout ${toString cfg.web.timeout}
            '';
            Restart = "on-failure";
            RestartSec = "5s";
            NoNewPrivileges = true;
            PrivateTmp = true;
            ProtectSystem = "strict";
            ReadWritePaths = [ "/var/lib/simplelogin" ];
          };
        };
      }

      (mkIf cfg.database.createLocally {
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

      (mkIf cfg.nginx.enable {
        services.nginx = {
          enable = true;
          virtualHosts."${cfg.hostName}" = {
            forceSSL = cfg.nginx.forceSSL;
            enableACME = cfg.nginx.enableACME;
            locations."/" = {
              proxyPass = "http://${cfg.web.address}:${toString cfg.web.port}";
              extraConfig = ''
                proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr;
              '';
            };
          };
        };
      })

      (mkIf cfg.mail.enable {
        systemd.services.simplelogin-email-handler = {
          description = "SimpleLogin Email Handler";
          wantedBy = [ "multi-user.target" ];
          after = [
            "network.target"
            "simplelogin-setup.service"
          ];
          requires = [ "simplelogin-setup.service" ];
          serviceConfig = {
            User = "simplelogin";
            Group = "simplelogin";
            WorkingDirectory = "/var/lib/simplelogin";
            StateDirectory = "simplelogin";
            EnvironmentFile = [ webEnv ] ++ optional (cfg.secretFile != null) cfg.secretFile;
            ExecStart = "${cfg.package}/bin/simplelogin-email-handler";
            Restart = "on-failure";
            RestartSec = "5s";
            NoNewPrivileges = true;
            PrivateTmp = true;
            ProtectSystem = "strict";
            ReadWritePaths = [ "/var/lib/simplelogin" ];
          };
        };
      })

      (mkIf cfg.mail.configurePostfix {
        services.postfix = {
          enable = true;
          hostname = cfg.hostName;
          networks = [
            "127.0.0.0/8"
            "[::ffff:127.0.0.0]/104"
            "[::1]/128"
          ];
          config = {
            transport_maps = [ "hash:/etc/postfix/transport" ];
            virtual_alias_maps = [
              "proxy:pgsql:/etc/postfix/pgsql-aliases.cf"
              "proxy:pgsql:/etc/postfix/pgsql-virtual-alias-maps.cf"
            ];
            virtual_mailbox_domains = [ "proxy:pgsql:/etc/postfix/pgsql-domains.cf" ];
            virtual_mailbox_maps = [ "proxy:pgsql:/etc/postfix/pgsql-mailboxes.cf" ];
            mydestination = "localhost.$mydomain, localhost, $myhostname";
          };
        };

        environment.etc = {
          "postfix/transport".text =
            "${cfg.emailDomain} smtp:[${cfg.mail.listenAddress}]:${toString cfg.mail.listenPort}";
          "postfix/pgsql-aliases.cf".text = ''
            user = ${cfg.database.user}
            hosts = localhost
            dbname = ${cfg.database.name}
            query = SELECT email FROM alias WHERE email='%s' AND enabled=1;
          '';
          "postfix/pgsql-virtual-alias-maps.cf".text = ''
            user = ${cfg.database.user}
            hosts = localhost
            dbname = ${cfg.database.name}
            query = SELECT mailbox.email FROM mailbox, alias, alias_mailbox WHERE alias.email='%s' AND alias.id=alias_mailbox.alias_id AND mailbox.id=alias_mailbox.mailbox_id AND alias.enabled=1;
          '';
          "postfix/pgsql-domains.cf".text = ''
            user = ${cfg.database.user}
            hosts = localhost
            dbname = ${cfg.database.name}
            query = SELECT domain FROM domain WHERE domain='%s' AND verified=1;
          '';
          "postfix/pgsql-mailboxes.cf".text = ''
            user = ${cfg.database.user}
            hosts = localhost
            dbname = ${cfg.database.name}
            query = SELECT email FROM mailbox WHERE email='%s' AND verified=1;
          '';
        };
      })

      (mkIf cfg.jobRunner.enable {
        systemd.services.simplelogin-job-runner = {
          description = "SimpleLogin Job Runner";
          wantedBy = [ "multi-user.target" ];
          after = [
            "network.target"
            "simplelogin-setup.service"
          ];
          requires = [ "simplelogin-setup.service" ];
          serviceConfig = {
            User = "simplelogin";
            Group = "simplelogin";
            WorkingDirectory = "/var/lib/simplelogin";
            StateDirectory = "simplelogin";
            EnvironmentFile = [ webEnv ] ++ optional (cfg.secretFile != null) cfg.secretFile;
            ExecStart = "${cfg.package}/bin/simplelogin-job-runner";
            Restart = "on-failure";
            RestartSec = "5s";
            NoNewPrivileges = true;
            PrivateTmp = true;
            ProtectSystem = "strict";
            ReadWritePaths = [ "/var/lib/simplelogin" ];
          };
        };
      })

      (mkIf cfg.eventListener.enable {
        systemd.services.simplelogin-event-listener = {
          description = "SimpleLogin Event Listener";
          wantedBy = [ "multi-user.target" ];
          after = [
            "network.target"
            "simplelogin-setup.service"
          ];
          requires = [ "simplelogin-setup.service" ];
          serviceConfig = {
            User = "simplelogin";
            Group = "simplelogin";
            WorkingDirectory = "/var/lib/simplelogin";
            StateDirectory = "simplelogin";
            EnvironmentFile = [ webEnv ] ++ optional (cfg.secretFile != null) cfg.secretFile;
            ExecStart = "${cfg.package}/bin/simplelogin-event-listener ${cfg.eventListener.mode}";
            Restart = "on-failure";
            RestartSec = "5s";
            NoNewPrivileges = true;
            PrivateTmp = true;
            ProtectSystem = "strict";
            ReadWritePaths = [ "/var/lib/simplelogin" ];
          };
        };
      })

      (mkIf cfg.monitoring.enable {
        systemd.services.simplelogin-monitoring = {
          description = "SimpleLogin Monitoring";
          wantedBy = [ "multi-user.target" ];
          after = [
            "network.target"
            "simplelogin-setup.service"
          ];
          requires = [ "simplelogin-setup.service" ];
          serviceConfig = {
            User = "simplelogin";
            Group = "simplelogin";
            WorkingDirectory = "/var/lib/simplelogin";
            StateDirectory = "simplelogin";
            EnvironmentFile = [ webEnv ] ++ optional (cfg.secretFile != null) cfg.secretFile;
            ExecStart = "${cfg.package}/bin/simplelogin-monitoring";
            Restart = "on-failure";
            RestartSec = "5s";
            NoNewPrivileges = true;
            PrivateTmp = true;
            ProtectSystem = "strict";
            ReadWritePaths = [ "/var/lib/simplelogin" ];
          };
        };
      })
    ]
  );

  meta.maintainers = with lib.maintainers; [ philocalyst ];
}
