{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.bookstack;
  bookstack = pkgs.bookstack.override {
    dataDir = cfg.dataDir;
  };
  db = cfg.database;
  mail = cfg.mail;

  user = cfg.user;
  group = cfg.group;

  # shell script for local administration
  artisan = pkgs.writeScriptBin "bookstack" ''
    #! ${pkgs.runtimeShell}
    cd ${bookstack}
    sudo=exec
    if [[ "$USER" != ${user} ]]; then
      sudo='exec /run/wrappers/bin/sudo -u ${user}'
    fi
    $sudo ${pkgs.php}/bin/php artisan $*
  '';

  tlsEnabled = cfg.nginx.addSSL || cfg.nginx.forceSSL || cfg.nginx.onlySSL || cfg.nginx.enableACME;

in {
  imports = [
    (mkRemovedOptionModule [ "services" "bookstack" "extraConfig" ] "Use services.bookstack.config instead.")
    (mkRemovedOptionModule [ "services" "bookstack" "cacheDir" ] "The cache directory is now handled automatically.")
  ];

  options.services.bookstack = {

    enable = mkEnableOption (lib.mdDoc "BookStack");

    user = mkOption {
      default = "bookstack";
      description = lib.mdDoc "User bookstack runs as.";
      type = types.str;
    };

    group = mkOption {
      default = "bookstack";
      description = lib.mdDoc "Group bookstack runs as.";
      type = types.str;
    };

    appKeyFile = mkOption {
      description = lib.mdDoc ''
        A file containing the Laravel APP_KEY - a 32 character long,
        base64 encoded key used for encryption where needed. Can be
        generated with `head -c 32 /dev/urandom | base64`.
      '';
      example = "/run/keys/bookstack-appkey";
      type = types.path;
    };

    hostname = lib.mkOption {
      type = lib.types.str;
      default = config.networking.fqdnOrHostName;
      defaultText = lib.literalExpression "config.networking.fqdnOrHostName";
      example = "bookstack.example.com";
      description = lib.mdDoc ''
        The hostname to serve BookStack on.
      '';
    };

    appURL = mkOption {
      description = lib.mdDoc ''
        The root URL that you want to host BookStack on. All URLs in BookStack will be generated using this value.
        If you change this in the future you may need to run a command to update stored URLs in the database. Command example: `php artisan bookstack:update-url https://old.example.com https://new.example.com`
      '';
      default = "http${lib.optionalString tlsEnabled "s"}://${cfg.hostname}";
      defaultText = ''http''${lib.optionalString tlsEnabled "s"}://''${cfg.hostname}'';
      example = "https://example.com";
      type = types.str;
    };

    dataDir = mkOption {
      description = lib.mdDoc "BookStack data directory";
      default = "/var/lib/bookstack";
      type = types.path;
    };

    database = {
      host = mkOption {
        type = types.str;
        default = "localhost";
        description = lib.mdDoc "Database host address.";
      };
      port = mkOption {
        type = types.port;
        default = 3306;
        description = lib.mdDoc "Database host port.";
      };
      name = mkOption {
        type = types.str;
        default = "bookstack";
        description = lib.mdDoc "Database name.";
      };
      user = mkOption {
        type = types.str;
        default = user;
        defaultText = literalExpression "user";
        description = lib.mdDoc "Database username.";
      };
      passwordFile = mkOption {
        type = with types; nullOr path;
        default = null;
        example = "/run/keys/bookstack-dbpassword";
        description = lib.mdDoc ''
          A file containing the password corresponding to
          {option}`database.user`.
        '';
      };
      createLocally = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Create the database and database user locally.";
      };
    };

    mail = {
      driver = mkOption {
        type = types.enum [ "smtp" "sendmail" ];
        default = "smtp";
        description = lib.mdDoc "Mail driver to use.";
      };
      host = mkOption {
        type = types.str;
        default = "localhost";
        description = lib.mdDoc "Mail host address.";
      };
      port = mkOption {
        type = types.port;
        default = 1025;
        description = lib.mdDoc "Mail host port.";
      };
      fromName = mkOption {
        type = types.str;
        default = "BookStack";
        description = lib.mdDoc "Mail \"from\" name.";
      };
      from = mkOption {
        type = types.str;
        default = "mail@bookstackapp.com";
        description = lib.mdDoc "Mail \"from\" email.";
      };
      user = mkOption {
        type = with types; nullOr str;
        default = null;
        example = "bookstack";
        description = lib.mdDoc "Mail username.";
      };
      passwordFile = mkOption {
        type = with types; nullOr path;
        default = null;
        example = "/run/keys/bookstack-mailpassword";
        description = lib.mdDoc ''
          A file containing the password corresponding to
          {option}`mail.user`.
        '';
      };
      encryption = mkOption {
        type = with types; nullOr (enum [ "tls" ]);
        default = null;
        description = lib.mdDoc "SMTP encryption mechanism to use.";
      };
    };

    maxUploadSize = mkOption {
      type = types.str;
      default = "18M";
      example = "1G";
      description = lib.mdDoc "The maximum size for uploads (e.g. images).";
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
      description = lib.mdDoc ''
        Options for the bookstack PHP pool. See the documentation on `php-fpm.conf`
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
            "bookstack.''${config.networking.domain}"
          ];
          # To enable encryption and let let's encrypt take care of certificate
          forceSSL = true;
          enableACME = true;
        }
      '';
      description = lib.mdDoc ''
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
                    type = nullOr str;
                    description = lib.mdDoc ''
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
          WKHTMLTOPDF = "/home/user/bins/wkhtmltopdf";
          AUTH_METHOD = "oidc";
          OIDC_NAME = "MyLogin";
          OIDC_DISPLAY_NAME_CLAIMS = "name";
          OIDC_CLIENT_ID = "bookstack";
          OIDC_CLIENT_SECRET = {_secret = "/run/keys/oidc_secret"};
          OIDC_ISSUER = "https://keycloak.example.com/auth/realms/My%20Realm";
          OIDC_ISSUER_DISCOVER = true;
        }
      '';
      description = lib.mdDoc ''
        BookStack configuration options to set in the
        {file}`.env` file.

        Refer to <https://www.bookstackapp.com/docs/>
        for details on supported values.

        Settings containing secret data should be set to an attribute
        set containing the attribute `_secret` - a
        string pointing to a file containing the value the option
        should be set to. See the example to get a better picture of
        this: in the resulting {file}`.env` file, the
        `OIDC_CLIENT_SECRET` key will be set to the
        contents of the {file}`/run/keys/oidc_secret`
        file.
      '';
    };

  };

  config = mkIf cfg.enable {

    assertions = [
      { assertion = db.createLocally -> db.user == user;
        message = "services.bookstack.database.user must be set to ${user} if services.bookstack.database.createLocally is set true.";
      }
      { assertion = db.createLocally -> db.passwordFile == null;
        message = "services.bookstack.database.passwordFile cannot be specified if services.bookstack.database.createLocally is set to true.";
      }
    ];

    services.bookstack.config = {
      APP_KEY._secret = cfg.appKeyFile;
      APP_URL = cfg.appURL;
      DB_HOST = db.host;
      DB_PORT = db.port;
      DB_DATABASE = db.name;
      DB_USERNAME = db.user;
      MAIL_DRIVER = mail.driver;
      MAIL_FROM_NAME = mail.fromName;
      MAIL_FROM = mail.from;
      MAIL_HOST = mail.host;
      MAIL_PORT = mail.port;
      MAIL_USERNAME = mail.user;
      MAIL_ENCRYPTION = mail.encryption;
      DB_PASSWORD._secret = db.passwordFile;
      MAIL_PASSWORD._secret = mail.passwordFile;
      APP_SERVICES_CACHE = "/run/bookstack/cache/services.php";
      APP_PACKAGES_CACHE = "/run/bookstack/cache/packages.php";
      APP_CONFIG_CACHE = "/run/bookstack/cache/config.php";
      APP_ROUTES_CACHE = "/run/bookstack/cache/routes-v7.php";
      APP_EVENTS_CACHE = "/run/bookstack/cache/events.php";
      SESSION_SECURE_COOKIE = tlsEnabled;
    };

    environment.systemPackages = [ artisan ];

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

    services.phpfpm.pools.bookstack = {
      inherit user;
      inherit group;
      phpOptions = ''
        log_errors = on
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
      recommendedTlsSettings = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;
      virtualHosts.${cfg.hostname} = mkMerge [ cfg.nginx {
        root = mkForce "${bookstack}/public";
        locations = {
          "/" = {
            index = "index.php";
            tryFiles = "$uri $uri/ /index.php?$query_string";
          };
          "~ \.php$".extraConfig = ''
            fastcgi_pass unix:${config.services.phpfpm.pools."bookstack".socket};
          '';
          "~ \.(js|css|gif|png|ico|jpg|jpeg)$" = {
            extraConfig = "expires 365d;";
          };
        };
      }];
    };

    systemd.services.bookstack-setup = {
      description = "Preparation tasks for BookStack";
      before = [ "phpfpm-bookstack.service" ];
      after = optional db.createLocally "mysql.service";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        User = user;
        WorkingDirectory = "${bookstack}";
        RuntimeDirectory = "bookstack/cache";
        RuntimeDirectoryMode = "0700";
      };
      path = [ pkgs.replace-secret ];
      script =
        let
          isSecret = v: isAttrs v && v ? _secret && isString v._secret;
          bookstackEnvVars = lib.generators.toKeyValue {
            mkKeyValue = lib.flip lib.generators.mkKeyValueDefault "=" {
              mkValueString = v: with builtins;
                if isInt         v then toString v
                else if isString v then v
                else if true  == v then "true"
                else if false == v then "false"
                else if isSecret v then hashString "sha256" v._secret
                else throw "unsupported type ${typeOf v}: ${(lib.generators.toPretty {}) v}";
            };
          };
          secretPaths = lib.mapAttrsToList (_: v: v._secret) (lib.filterAttrs (_: isSecret) cfg.config);
          mkSecretReplacement = file: ''
            replace-secret ${escapeShellArgs [ (builtins.hashString "sha256" file) file "${cfg.dataDir}/.env" ]}
          '';
          secretReplacements = lib.concatMapStrings mkSecretReplacement secretPaths;
          filteredConfig = lib.converge (lib.filterAttrsRecursive (_: v: ! elem v [ {} null ])) cfg.config;
          bookstackEnv = pkgs.writeText "bookstack.env" (bookstackEnvVars filteredConfig);
        in ''
        # error handling
        set -euo pipefail

        # set permissions
        umask 077

        # create .env file
        install -T -m 0600 -o ${user} ${bookstackEnv} "${cfg.dataDir}/.env"
        ${secretReplacements}
        if ! grep 'APP_KEY=base64:' "${cfg.dataDir}/.env" >/dev/null; then
            sed -i 's/APP_KEY=/APP_KEY=base64:/' "${cfg.dataDir}/.env"
        fi

        # migrate db
        ${pkgs.php}/bin/php artisan migrate --force
      '';
    };

    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir}                            0710 ${user} ${group} - -"
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
      users = mkIf (user == "bookstack") {
        bookstack = {
          inherit group;
          isSystemUser = true;
        };
        "${config.services.nginx.user}".extraGroups = [ group ];
      };
      groups = mkIf (group == "bookstack") {
        bookstack = {};
      };
    };

  };

  meta.maintainers = with maintainers; [ ymarkus ];
}
