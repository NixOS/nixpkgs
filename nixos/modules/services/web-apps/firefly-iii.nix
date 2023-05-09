{ pkgs, config, lib, ... }:

with lib;

let
  cfg = config.services.firefly-iii;
  db = cfg.database;
  mail = cfg.mail;

  user = cfg.user;
  group = cfg.group;

  firefly-iii = pkgs.firefly-iii;

  defaultUser = "firefly-iii";
  defaultGroup = defaultUser;

  tlsEnabled = cfg.nginx.addSSL || cfg.nginx.forceSSL || cfg.nginx.onlySSL || cfg.nginx.enableACME;

in {

  options.services.firefly-iii = {

    enable = mkEnableOption "Firefly III";

    dataDir = mkOption {
      description = mdDoc "Firefly III data directory";
      default = "/var/lib/firefly-iii";
      type = types.path;
    };

    # App configuration
    appURL = mkOption {
      description = mdDoc ''
        The root URL that you want to host Firefly III on. All URLs in Firefly III will be generated using this value.
      '';
      default = "http${lib.optionalString tlsEnabled "s"}://${cfg.hostname}";
      defaultText = ''http''${lib.optionalString tlsEnabled "s"}://''${cfg.hostname}'';
      example = "https://example.com";
      type = types.str;
    };

    appKeyFile = mkOption {
      description = mdDoc ''
        A file containing the Laravel APP_KEY - a 32 character long,
        base64 encoded key used for encryption where needed. Can be
        generated with `head -c 32 /dev/urandom | base64`.
      '';
      example = "/run/keys/firefly-iii-appkey";
      type = types.path;
    };

    # PHP
    poolConfig = mkOption {
      type = with types; attrsOf (oneOf [ str int bool ]);
      default = {
        "pm" = "dynamic";
        "pm.max_children" = 32;
        "pm.start_servers" = 2;
        "pm.min_spare_servers" = 2;
        "pm.max_spare_servers" = 4;
        "pm.max_requests" = 500;
      };
      description = mdDoc ''
        Options for the Firefly III PHP pool. See the documentation on <literal>php-fpm.conf</literal>
        for details on configuration directives.
      '';
    };

    # Reverse proxy
    hostname = lib.mkOption {
      type = lib.types.str;
      default = if config.networking.domain != null then
                  config.networking.fqdn
                else
                  config.networking.hostName;
      defaultText = literalMD "config.networking.fqdn";
      example = "firefly.example.com";
      description = mdDoc "The hostname to serve Firefly III on.";
    };

    nginx = mkOption {
      type = types.submodule (
        recursiveUpdate
          (import ../web-servers/nginx/vhost-options.nix { inherit config lib; }) {}
      );
      default = {};
      example = literalMD ''
        {
          serverAliases = [
            "firefly.''${cfg.hostname}"
          ];

          # To enable encryption and let Let's Encrypt take care of certificate
          forceSSL = true;
          enableACME = true;
        }
      '';
      description = mdDoc "With this option, you can customize the nginx virtualHost settings.";
    };

    # Config
    config = mkOption {
      type = with types;
        attrsOf
          (nullOr
            (either
              (oneOf [
                bool
                int
                port
                path
                str
              ])
              (submodule {
                options = {
                  _secret = mkOption {
                    type = nullOr (oneOf [ str path ]);
                    description = ''
                      The path to a file containing the value the
                      option should be set to in the final
                      configuration file.
                    '';
                  };
                };
              })));
      default = {};
      example = literalMD ''
        {
          MAILGUN_SECRET = { _secret = "/run/keys/mailgun_secret" };
        }
      '';
      description = ''
        Firefly III configuration options to set in the <filename>.env</filename> file.

        Settings containing secret data should be set to an attribute
        set containing the attribute <literal>_secret</literal> - a
        string pointing to a file containing the value the option
        should be set to. See the example to get a better picture of
        this: in the resulting <filename>.env</filename> file, the
        <literal>MAILGUN_SECRET</literal> key will be set to the
        contents of the <filename>/run/keys/mailgun_secret</filename>
        file.
      '';
    };

    database = {
      type = mkOption {
        type = types.enum [ "pgsql" "mysql" "sqlite" ];
        example = "mysql";
        default = "mysql";
        description = mdDoc "Database engine to use.";
      };
      host = mkOption {
        type = types.str;
        default = "localhost";
        description = mdDoc "Database host address.";
      };
      port = mkOption {
        type = types.port;
        default = 3306;
        description = mdDoc "Database host port.";
      };
      name = mkOption {
        type = types.str;
        default = "firefly";
        description = mdDoc "Database name.";
      };
      user = mkOption {
        type = types.str;
        default = user;
        defaultText = literalMD "user";
        description = mdDoc "Database username.";
      };
      passwordFile = mkOption {
        type = with types; nullOr path;
        default = null;
        example = "/run/keys/firefly-iii-dbpassword";
        description = ''
          A file containing the password corresponding to
          <option>database.user</option>
        '';
      };
      createLocally = mkOption {
        type = types.bool;
        default = false;
        description = mdDoc "Create the database and database user locally.";
      };
    };

    mail = {
      driver = mkOption {
        type = types.enum [ "smtp" "sendmail" "mandrill" "sparkpost" "log" ];
        default = "log";
        description = mdDoc "Mail driver to use.";
      };
      host = mkOption {
        type = with types; nullOr str;
        default = "null";
        description = mdDoc "Mail host address.";
      };
      port = mkOption {
        type = types.port;
        default = 2525;
        description = mdDoc "Mail host port.";
      };
      fromName = mkOption {
        type = types.str;
        default = "Firefly III";
        description = mdDoc "Mail \"from\" name";
      };
      user = mkOption {
        type = with types; nullOr str;
        default = null;
        example = "firefly-iii";
        description = mdDoc "Mail username.";
      };
      passwordFile = mkOption {
        type = with types; nullOr path;
        default = null;
        example = "/run/keys/firefly-iii-mailpassword";
        description = ''
          A file containing the password corresponding to
          <option>mail.user</option>.
        '';
      };
      encryption = mkOption {
        type = with types; nullOr (enum [ "tls" ]);
        default = null;
        description = mdDoc "SMTP encryption mechanism to use.";
      };
    };

    # User management
    user = mkOption {
      default = defaultUser;
      description = mdDoc "User Firefly III runs as.";
      type = types.str;
    };

    group = mkOption {
      default = defaultGroup;
      description = mdDoc "Group Firefly III runs as.";
      type = types.str;
    };

  };

  #
  # Config
  #
  config = mkIf cfg.enable {

    assertions = [
      {
        assertion = db.createLocally -> db.user == user;
        message = "services.firefly-iii.database.user must be set to ${user} if services.firefly-iii.database.createLocally is set true.";
      }
      {
        assertion = db.createLocally -> db.passwordFile == null;
        message = "services.firefly-iii.database.passwordFile cannot be specified if services.firefly-iii.database.createLocally is set true.";
      }
      {
        assertion = db.createLocally -> db.type == "mysql";
        message = "services.firefly-iii.database.type must be set to mysql if services.firefly-iii.database.createLocally is set true.";
      }
    ];

    # PHP
    services.phpfpm.pools.firefly-iii = {
      inherit user;
      inherit group;
      phpOptions = ''
        log_errors = on
      '';
      settings = {
        "listen.mode" = "0660";
        "listen.owner" = "nginx";
        "listen.group" = "nginx";
      } // cfg.poolConfig;
    };

    # MySQL
    services.mysql = mkIf db.createLocally {
      enable = true;
      package = mkDefault pkgs.mariadb;
      ensureDatabases = [ db.name ];
      ensureUsers = [
        {
          name = db.user;
          ensurePermissions = { "${db.name}.*" = "ALL PRIVILEGES"; };
        }
      ];
    };

    # Reverse proxy
    services.nginx = {
      enable = mkDefault true;
      recommendedTlsSettings = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;
      virtualHosts.${cfg.hostname} = mkMerge [ cfg.nginx {
        root = mkForce "${firefly-iii}/public";
        locations = {
          "/" = {
            index = "index.php";
            tryFiles = "$uri $uri/ /index.php?$query_string";
          };
          "~ \.php$".extraConfig = ''
            fastcgi_pass unix:${config.services.phpfpm.pools."firefly-iii".socket};
          '';
          "~ \.(js|css|gif|png|ico|jpg|jpeg)$" = {
            extraConfig = "expires 365d;";
          };
        };
      }];
    };

    # Config
    services.firefly-iii.config = {
      APP_URL = cfg.appURL;
      APP_KEY._secret = cfg.appKeyFile;

      DB_CONNECTION = db.type;
      DB_HOST = db.host;
      DB_PORT = db.port;
      DB_DATABASE = db.name;
      DB_USERNAME = db.user;
      DB_PASSWORD._secret = db.passwordFile;

      MAIL_MAILER = mail.driver;
      MAIL_HOST = mail.host;
      MAIL_PORT = mail.port;
      MAIL_FROM = mail.fromName;
      MAIL_USERNAME = mail.user;
      MAIL_PASSWORD._secret = mail.passwordFile;
      MAIL_ENCRYPTION = mail.encryption;
    };

    # Set-up script
    systemd.services.firefly-iii-setup = {
      description = mdDoc "Preparation tasks for Firefly III";
      before = [ "phpfpm-firefly-iii.service" ];
      after = optional db.createLocally "mysql.service";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        User = user;
        WorkingDirectory = "${firefly-iii}";
      };
      path = [ pkgs.replace-secret ];
      script =
        let
          isSecret  = v: isAttrs v && v ? _secret && (isString v._secret || builtins.isPath v._secret);
          fireflyEnvVars = lib.generators.toKeyValue {
            mkKeyValue = lib.flip lib.generators.mkKeyValueDefault "=" {
              mkValueString = v: with builtins;
                if isInt             v then toString v
                else if isString     v then "\"${v}\""
                else if true  ==     v then "true"
                else if false ==     v then "false"
                else if isSecret     v then
                  if (isString v._secret) then
                    hashString "sha256" v._secret
                  else
                    hashString "sha256" (builtins.readFile v._secret)
                else throw "unsupported type ${typeOf v}: ${(lib.generators.toPretty {}) v}";
            };
          };
          secretPaths = lib.mapAttrsToList (_: v: v._secret) (lib.filterAttrs (_: isSecret) cfg.config);
          mkSecretReplacement = file: ''
            replace-secret ${escapeShellArgs [
              (
                if (isString file) then
                  builtins.hashString "sha256" file
                else
                  builtins.hashString "sha256" (builtins.readFile file)
              )
              file
              "${cfg.dataDir}/.env"
            ]}
          '';
          secretReplacements = lib.concatMapStrings mkSecretReplacement secretPaths;
          filteredConfig = lib.converge (lib.filterAttrsRecursive (_: v: ! elem v [ {} null ])) cfg.config;
          fireflyEnv = pkgs.writeText "firefly-iii.env" (fireflyEnvVars filteredConfig);
      in ''
        set -euo pipefail
        umask 077

        # create the .env file
        install -T -m 0600 -o ${user} ${fireflyEnv} "${cfg.dataDir}/.env"
        ${secretReplacements}
        if ! grep 'APP_KEY=base64:' "${cfg.dataDir}/.env" >/dev/null; then
            sed -i 's/APP_KEY=/APP_KEY=base64:/' "${cfg.dataDir}/.env"
        fi

        # migrate db
        ${pkgs.php}/bin/php artisan migrate --force
      '';
    };

    # Data dir
    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir}                            0710 ${user} ${group} - -"
      "d ${cfg.dataDir}/storage                    0700 ${user} ${group} - -"
      "d ${cfg.dataDir}/storage/app                0700 ${user} ${group} - -"
      "d ${cfg.dataDir}/storage/database           0700 ${user} ${group} - -"
      "d ${cfg.dataDir}/storage/export             0700 ${user} ${group} - -"
      "d ${cfg.dataDir}/storage/framework          0700 ${user} ${group} - -"
      "d ${cfg.dataDir}/storage/framework/cache    0700 ${user} ${group} - -"
      "d ${cfg.dataDir}/storage/framework/sessions 0700 ${user} ${group} - -"
      "d ${cfg.dataDir}/storage/framework/views    0700 ${user} ${group} - -"
      "d ${cfg.dataDir}/storage/logs               0700 ${user} ${group} - -"
      "d ${cfg.dataDir}/storage/upload             0700 ${user} ${group} - -"
    ];

    # User management
    users = {
      users = mkIf (user == defaultUser) {
        ${defaultUser} = {
          inherit group;
          isSystemUser = true;
        };
        "${config.services.nginx.user}".extraGroups = [ group ];
      };
      groups = mkIf (group == defaultGroup) {
        ${defaultGroup} = {};
      };
    };

  };

}
