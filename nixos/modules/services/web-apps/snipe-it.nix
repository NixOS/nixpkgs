{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.snipe-it;
  snipe-it = pkgs.snipe-it.override {
    dataDir = cfg.dataDir;
  };
  db = cfg.database;
  mail = cfg.mail;

  user = cfg.user;
  group = cfg.group;

  tlsEnabled = cfg.nginx.addSSL || cfg.nginx.forceSSL || cfg.nginx.onlySSL || cfg.nginx.enableACME;

  # shell script for local administration
  artisan = pkgs.writeScriptBin "snipe-it" ''
    #! ${pkgs.runtimeShell}
    cd ${snipe-it}
    sudo=exec
    if [[ "$USER" != ${user} ]]; then
      sudo='exec /run/wrappers/bin/sudo -u ${user}'
    fi
    $sudo ${pkgs.php}/bin/php artisan $*
  '';
in {
  options.services.snipe-it = {

    enable = mkEnableOption "A free open source IT asset/license management system";

    user = mkOption {
      default = "snipeit";
      description = "User snipe-it runs as.";
      type = types.str;
    };

    group = mkOption {
      default = "snipeit";
      description = "Group snipe-it runs as.";
      type = types.str;
    };

    appKeyFile = mkOption {
      description = ''
        A file containing the Laravel APP_KEY - a 32 character long,
        base64 encoded key used for encryption where needed. Can be
        generated with <code>head -c 32 /dev/urandom | base64</code>.
      '';
      example = "/run/keys/snipe-it/appkey";
      type = types.path;
    };

    hostName = lib.mkOption {
      type = lib.types.str;
      default = if config.networking.domain != null then
                  config.networking.fqdn
                else
                  config.networking.hostName;
      defaultText = lib.literalExpression "config.networking.fqdn";
      example = "snipe-it.example.com";
      description = ''
        The hostname to serve Snipe-IT on.
      '';
    };

    appURL = mkOption {
      description = ''
        The root URL that you want to host Snipe-IT on. All URLs in Snipe-IT will be generated using this value.
        If you change this in the future you may need to run a command to update stored URLs in the database.
        Command example: <code>snipe-it snipe-it:update-url https://old.example.com https://new.example.com</code>
      '';
      default = "http${lib.optionalString tlsEnabled "s"}://${cfg.hostName}";
      defaultText = ''
        http''${lib.optionalString tlsEnabled "s"}://''${cfg.hostName}
      '';
      example = "https://example.com";
      type = types.str;
    };

    dataDir = mkOption {
      description = "snipe-it data directory";
      default = "/var/lib/snipe-it";
      type = types.path;
    };

    database = {
      host = mkOption {
        type = types.str;
        default = "localhost";
        description = "Database host address.";
      };
      port = mkOption {
        type = types.port;
        default = 3306;
        description = "Database host port.";
      };
      name = mkOption {
        type = types.str;
        default = "snipeit";
        description = "Database name.";
      };
      user = mkOption {
        type = types.str;
        default = user;
        defaultText = literalExpression "user";
        description = "Database username.";
      };
      passwordFile = mkOption {
        type = with types; nullOr path;
        default = null;
        example = "/run/keys/snipe-it/dbpassword";
        description = ''
          A file containing the password corresponding to
          <option>database.user</option>.
        '';
      };
      createLocally = mkOption {
        type = types.bool;
        default = false;
        description = "Create the database and database user locally.";
      };
    };

    mail = {
      driver = mkOption {
        type = types.enum [ "smtp" "sendmail" ];
        default = "smtp";
        description = "Mail driver to use.";
      };
      host = mkOption {
        type = types.str;
        default = "localhost";
        description = "Mail host address.";
      };
      port = mkOption {
        type = types.port;
        default = 1025;
        description = "Mail host port.";
      };
      encryption = mkOption {
        type = with types; nullOr (enum [ "tls" "ssl" ]);
        default = null;
        description = "SMTP encryption mechanism to use.";
      };
      user = mkOption {
        type = with types; nullOr str;
        default = null;
        example = "snipeit";
        description = "Mail username.";
      };
      passwordFile = mkOption {
        type = with types; nullOr path;
        default = null;
        example = "/run/keys/snipe-it/mailpassword";
        description = ''
          A file containing the password corresponding to
          <option>mail.user</option>.
        '';
      };
      backupNotificationAddress = mkOption {
        type = types.str;
        default = "backup@example.com";
        description = "Email Address to send Backup Notifications to.";
      };
      from = {
        name = mkOption {
          type = types.str;
          default = "Snipe-IT Asset Management";
          description = "Mail \"from\" name.";
        };
        address = mkOption {
          type = types.str;
          default = "mail@example.com";
          description = "Mail \"from\" address.";
        };
      };
      replyTo = {
        name = mkOption {
          type = types.str;
          default = "Snipe-IT Asset Management";
          description = "Mail \"reply-to\" name.";
        };
        address = mkOption {
          type = types.str;
          default = "mail@example.com";
          description = "Mail \"reply-to\" address.";
        };
      };
    };

    maxUploadSize = mkOption {
      type = types.str;
      default = "18M";
      example = "1G";
      description = "The maximum size for uploads (e.g. images).";
    };

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
      description = ''
        Options for the snipe-it PHP pool. See the documentation on <literal>php-fpm.conf</literal>
        for details on configuration directives.
      '';
    };

    nginx = mkOption {
      type = types.submodule (
        recursiveUpdate
          (import ../web-servers/nginx/vhost-options.nix { inherit config lib; }) {}
      );
      default = {};
      example = literalExpression ''
        {
          serverAliases = [
            "snipe-it.''${config.networking.domain}"
          ];
          # To enable encryption and let let's encrypt take care of certificate
          forceSSL = true;
          enableACME = true;
        }
      '';
      description = ''
        With this option, you can customize the nginx virtualHost settings.
      '';
    };

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
      example = literalExpression ''
        {
          ALLOWED_IFRAME_HOSTS = "https://example.com";
          WKHTMLTOPDF = "''${pkgs.wkhtmltopdf}/bin/wkhtmltopdf";
          AUTH_METHOD = "oidc";
          OIDC_NAME = "MyLogin";
          OIDC_DISPLAY_NAME_CLAIMS = "name";
          OIDC_CLIENT_ID = "snipe-it";
          OIDC_CLIENT_SECRET = {_secret = "/run/keys/oidc_secret"};
          OIDC_ISSUER = "https://keycloak.example.com/auth/realms/My%20Realm";
          OIDC_ISSUER_DISCOVER = true;
        }
      '';
      description = ''
        Snipe-IT configuration options to set in the
        <filename>.env</filename> file.
        Refer to <link xlink:href="https://snipe-it.readme.io/docs/configuration"/>
        for details on supported values.

        Settings containing secret data should be set to an attribute
        set containing the attribute <literal>_secret</literal> - a
        string pointing to a file containing the value the option
        should be set to. See the example to get a better picture of
        this: in the resulting <filename>.env</filename> file, the
        <literal>OIDC_CLIENT_SECRET</literal> key will be set to the
        contents of the <filename>/run/keys/oidc_secret</filename>
        file.
      '';
    };
  };

  config = mkIf cfg.enable {

    assertions = [
      { assertion = db.createLocally -> db.user == user;
        message = "services.snipe-it.database.user must be set to ${user} if services.snipe-it.database.createLocally is set true.";
      }
      { assertion = db.createLocally -> db.passwordFile == null;
        message = "services.snipe-it.database.passwordFile cannot be specified if services.snipe-it.database.createLocally is set to true.";
      }
    ];

    environment.systemPackages = [ artisan ];

    services.snipe-it.config = {
      APP_ENV = "production";
      APP_KEY._secret = cfg.appKeyFile;
      APP_URL = cfg.appURL;
      DB_HOST = db.host;
      DB_PORT = db.port;
      DB_DATABASE = db.name;
      DB_USERNAME = db.user;
      DB_PASSWORD._secret = db.passwordFile;
      MAIL_DRIVER = mail.driver;
      MAIL_FROM_NAME = mail.from.name;
      MAIL_FROM_ADDR = mail.from.address;
      MAIL_REPLYTO_NAME = mail.from.name;
      MAIL_REPLYTO_ADDR = mail.from.address;
      MAIL_BACKUP_NOTIFICATION_ADDRESS = mail.backupNotificationAddress;
      MAIL_HOST = mail.host;
      MAIL_PORT = mail.port;
      MAIL_USERNAME = mail.user;
      MAIL_ENCRYPTION = mail.encryption;
      MAIL_PASSWORD._secret = mail.passwordFile;
      APP_SERVICES_CACHE = "/run/snipe-it/cache/services.php";
      APP_PACKAGES_CACHE = "/run/snipe-it/cache/packages.php";
      APP_CONFIG_CACHE = "/run/snipe-it/cache/config.php";
      APP_ROUTES_CACHE = "/run/snipe-it/cache/routes-v7.php";
      APP_EVENTS_CACHE = "/run/snipe-it/cache/events.php";
      SESSION_SECURE_COOKIE = tlsEnabled;
    };

    services.mysql = mkIf db.createLocally {
      enable = true;
      package = mkDefault pkgs.mariadb;
      ensureDatabases = [ db.name ];
      ensureUsers = [
        { name = db.user;
          ensurePermissions = { "${db.name}.*" = "ALL PRIVILEGES"; };
        }
      ];
    };

    services.phpfpm.pools.snipe-it = {
      inherit user group;
      phpPackage = pkgs.php81;
      phpOptions = ''
        post_max_size = ${cfg.maxUploadSize}
        upload_max_filesize = ${cfg.maxUploadSize}
      '';
      settings = {
        "listen.mode" = "0660";
        "listen.owner" = user;
        "listen.group" = group;
      } // cfg.poolConfig;
    };

    services.nginx = {
      enable = mkDefault true;
      virtualHosts."${cfg.hostName}" = mkMerge [ cfg.nginx {
        root = mkForce "${snipe-it}/public";
        extraConfig = optionalString (cfg.nginx.addSSL || cfg.nginx.forceSSL || cfg.nginx.onlySSL || cfg.nginx.enableACME) "fastcgi_param HTTPS on;";
        locations = {
          "/" = {
            index = "index.php";
            extraConfig = ''try_files $uri $uri/ /index.php?$query_string;'';
          };
          "~ \.php$" = {
            extraConfig = ''
              try_files $uri $uri/ /index.php?$query_string;
              include ${config.services.nginx.package}/conf/fastcgi_params;
              fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
              fastcgi_param REDIRECT_STATUS 200;
              fastcgi_pass unix:${config.services.phpfpm.pools."snipe-it".socket};
              ${optionalString (cfg.nginx.addSSL || cfg.nginx.forceSSL || cfg.nginx.onlySSL || cfg.nginx.enableACME) "fastcgi_param HTTPS on;"}
            '';
          };
          "~ \.(js|css|gif|png|ico|jpg|jpeg)$" = {
            extraConfig = "expires 365d;";
          };
        };
      }];
    };

    systemd.services.snipe-it-setup = {
      description = "Preperation tasks for snipe-it";
      before = [ "phpfpm-snipe-it.service" ];
      after = optional db.createLocally "mysql.service";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        User = user;
        WorkingDirectory = snipe-it;
        RuntimeDirectory = "snipe-it/cache";
        RuntimeDirectoryMode = 0700;
      };
      path = [ pkgs.replace-secret ];
      script =
        let
          isSecret  = v: isAttrs v && v ? _secret && (isString v._secret || builtins.isPath v._secret);
          snipeITEnvVars = lib.generators.toKeyValue {
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
          snipeITEnv = pkgs.writeText "snipeIT.env" (snipeITEnvVars filteredConfig);
        in ''
          # error handling
          set -euo pipefail

          # set permissions
          umask 077

          # create .env file
          install -T -m 0600 -o ${user} ${snipeITEnv} "${cfg.dataDir}/.env"

          # replace secrets
          ${secretReplacements}

          # prepend `base64:` if it does not exist in APP_KEY
          if ! grep 'APP_KEY=base64:' "${cfg.dataDir}/.env" >/dev/null; then
              sed -i 's/APP_KEY=/APP_KEY=base64:/' "${cfg.dataDir}/.env"
          fi

          # purge cache
          rm "${cfg.dataDir}"/bootstrap/cache/*.php || true

          # migrate db
          ${pkgs.php}/bin/php artisan migrate --force
        '';
    };

    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir}                            0710 ${user} ${group} - -"
      "d ${cfg.dataDir}/bootstrap                  0750 ${user} ${group} - -"
      "d ${cfg.dataDir}/bootstrap/cache            0750 ${user} ${group} - -"
      "d ${cfg.dataDir}/public                     0750 ${user} ${group} - -"
      "d ${cfg.dataDir}/public/uploads             0750 ${user} ${group} - -"
      "d ${cfg.dataDir}/storage                    0700 ${user} ${group} - -"
      "d ${cfg.dataDir}/storage/app                0700 ${user} ${group} - -"
      "d ${cfg.dataDir}/storage/fonts              0700 ${user} ${group} - -"
      "d ${cfg.dataDir}/storage/framework          0700 ${user} ${group} - -"
      "d ${cfg.dataDir}/storage/framework/cache    0700 ${user} ${group} - -"
      "d ${cfg.dataDir}/storage/framework/sessions 0700 ${user} ${group} - -"
      "d ${cfg.dataDir}/storage/framework/views    0700 ${user} ${group} - -"
      "d ${cfg.dataDir}/storage/logs               0700 ${user} ${group} - -"
      "d ${cfg.dataDir}/storage/uploads            0700 ${user} ${group} - -"
    ];

    users = {
      users = mkIf (user == "snipeit") {
        snipeit = {
          inherit group;
          isSystemUser = true;
        };
        "${config.services.nginx.user}".extraGroups = [ group ];
      };
      groups = mkIf (group == "snipeit") {
        snipeit = {};
      };
    };

  };

  meta.maintainers = with maintainers; [ yayayayaka ];
}
