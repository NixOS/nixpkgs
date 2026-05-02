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
  } (lib.filterAttrs (n: v: v != null) cfg.settings);

  envFile = pkgs.writeText "simplelogin.env" renderedEnv;

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

  webEnv = envFile;
in
{
  options.services.simplelogin = {
    enable = mkEnableOption "SimpleLogin";

    package = mkPackageOption pkgs "simplelogin" { };

    hostName = mkOption {
      type = types.str;
      example = "app.example.com";
      description = "The public hostname of the SimpleLogin instance. Used for nginx virtual host and default URL.";
    };

    url = mkOption {
      type = types.str;
      default = "https://${cfg.hostName}";
      description = "Public URL of the SimpleLogin instance, used in links sent in email.";
    };

    emailDomain = mkOption {
      type = types.str;
      example = "example.com";
      description = "The domain used for email aliases.";
    };

    supportEmail = mkOption {
      type = types.str;
      default = "support@${cfg.emailDomain}";
      description = "Email address for support messages sent by the application.";
    };

    flaskSecret = mkOption {
      type = types.str;
      description = "Flask secret. Use a secret manager in real deployments.";
    };

    dkimKeyFile = mkOption {
      type = types.path;
      description = "Path to the DKIM private key.";
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
      type = types.attrsOf (
        types.oneOf [
          types.str
          types.int
          types.float
          types.bool
          (types.listOf types.anything)
          (types.attrsOf types.anything)
        ]
      );
      default = { };
      description = ''
        Free-form upstream environment variables.

        Booleans map to presence-style variables: `true` becomes `FOO=1`,
        `false` is omitted.
      '';
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
        default = [
          {
            priority = 10;
            host = "${cfg.hostName}.";
          }
        ];
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

  config = mkIf cfg.enable {
    services.simplelogin.settings = mkMerge [
      defaultSettings
      {
        ALIAS_DOMAINS = [ cfg.emailDomain ];
      }
    ];

    users.users.simplelogin = {
      isSystemUser = true;
      group = "simplelogin";
      home = "/var/lib/simplelogin";
      createHome = true;
    };

    users.groups.simplelogin = { };

    services.postgresql = mkIf cfg.database.createLocally {
      enable = true;
      ensureDatabases = [ cfg.database.name ];
      ensureUsers = [
        {
          name = cfg.database.user;
          ensureDBOwnership = true;
        }
      ];
    };

    systemd.services.simplelogin-setup = {
      description = "SimpleLogin database setup";
      wantedBy = [ "multi-user.target" ];
      before = [
        "simplelogin-web.service"
      ]
      ++ optional cfg.mail.enable "simplelogin-email-handler.service"
      ++ optional cfg.jobRunner.enable "simplelogin-job-runner.service";
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
      description = "SimpleLogin web service";
      wantedBy = [ "multi-user.target" ];
      requires = [ "simplelogin-setup.service" ];
      after = [ "simplelogin-setup.service" ];
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

    systemd.services.simplelogin-email-handler = mkIf cfg.mail.enable {
      description = "SimpleLogin email handler";
      wantedBy = [ "multi-user.target" ];
      requires = [ "simplelogin-setup.service" ];
      after = [ "simplelogin-setup.service" ];
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

    systemd.services.simplelogin-job-runner = mkIf cfg.jobRunner.enable {
      description = "SimpleLogin job runner";
      wantedBy = [ "multi-user.target" ];
      requires = [ "simplelogin-setup.service" ];
      after = [ "simplelogin-setup.service" ];
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

    systemd.services.simplelogin-event-listener = mkIf cfg.eventListener.enable {
      description = "SimpleLogin event listener";
      wantedBy = [ "multi-user.target" ];
      requires = [ "simplelogin-setup.service" ];
      after = [ "simplelogin-setup.service" ];
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

    systemd.services.simplelogin-monitoring = mkIf cfg.monitoring.enable {
      description = "SimpleLogin monitoring exporter";
      wantedBy = [ "multi-user.target" ];
      requires = [ "simplelogin-setup.service" ];
      after = [ "simplelogin-setup.service" ];
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

    services.nginx = mkIf cfg.nginx.enable {
      enable = true;
      virtualHosts.${cfg.hostName} = {
        forceSSL = mkDefault cfg.nginx.forceSSL;
        enableACME = mkDefault cfg.nginx.enableACME;
        locations."/".proxyPass = "http://${cfg.web.address}:${toString cfg.web.port}";
      };
    };

    services.postfix = mkIf (cfg.mail.enable && cfg.mail.configurePostfix) {
      enable = true;
      settings.main = {
        mydestination = [ ];
        myhostname = cfg.hostName;
        mydomain = cfg.emailDomain;
        myorigin = cfg.emailDomain;
        relay_domains = [ cfg.emailDomain ];
        transport_maps = [ "hash:/etc/postfix/transport" ];
      };
      mapFiles.transport = pkgs.writeText "simplelogin-transport" ''
        ${cfg.emailDomain} smtp:${cfg.mail.listenAddress}:${toString cfg.mail.listenPort}
      '';
    };

    networking.firewall.allowedTCPPorts = optional cfg.nginx.enable 80 ++ optional cfg.nginx.enable 443;
  };

  meta.maintainers = [ ];
}
