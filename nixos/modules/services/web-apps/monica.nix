{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.monica;
  monica = pkgs.monica.override {
    dataDir = cfg.dataDir;
  };
  db = cfg.database;
  mail = cfg.mail;

  user = cfg.user;
  group = cfg.group;

  # shell script for local administration
  artisan = pkgs.writeScriptBin "monica" ''
    #! ${pkgs.runtimeShell}
    cd ${monica}
    sudo() {
      if [[ "$USER" != ${user} ]]; then
        exec /run/wrappers/bin/sudo -u ${user} "$@"
      else
        exec "$@"
      fi
    }
    sudo ${pkgs.php}/bin/php artisan "$@"
  '';

  tlsEnabled = cfg.nginx.addSSL || cfg.nginx.forceSSL || cfg.nginx.onlySSL || cfg.nginx.enableACME;
in {
  options.services.monica = {
    enable = mkEnableOption "monica";

    user = mkOption {
      default = "monica";
      description = "User monica runs as.";
      type = types.str;
    };

    group = mkOption {
      default = "monica";
      description = "Group monica runs as.";
      type = types.str;
    };

    appKeyFile = mkOption {
      description = ''
        A file containing the Laravel APP_KEY - a 32 character long,
        base64 encoded key used for encryption where needed. Can be
        generated with <code>head -c 32 /dev/urandom | base64</code>.
      '';
      example = "/run/keys/monica-appkey";
      type = types.path;
    };

    hostname = lib.mkOption {
      type = lib.types.str;
      default =
        if config.networking.domain != null
        then config.networking.fqdn
        else config.networking.hostName;
      defaultText = lib.literalExpression "config.networking.fqdn";
      example = "monica.example.com";
      description = ''
        The hostname to serve monica on.
      '';
    };

    appURL = mkOption {
      description = ''
        The root URL that you want to host monica on. All URLs in monica will be generated using this value.
        If you change this in the future you may need to run a command to update stored URLs in the database.
        Command example: <code>php artisan monica:update-url https://old.example.com https://new.example.com</code>
      '';
      default = "http${lib.optionalString tlsEnabled "s"}://${cfg.hostname}";
      defaultText = ''http''${lib.optionalString tlsEnabled "s"}://''${cfg.hostname}'';
      example = "https://example.com";
      type = types.str;
    };

    dataDir = mkOption {
      description = "monica data directory";
      default = "/var/lib/monica";
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
        default = "monica";
        description = "Database name.";
      };
      user = mkOption {
        type = types.str;
        default = user;
        defaultText = lib.literalExpression "user";
        description = "Database username.";
      };
      passwordFile = mkOption {
        type = with types; nullOr path;
        default = null;
        example = "/run/keys/monica-dbpassword";
        description = ''
          A file containing the password corresponding to
          <option>database.user</option>.
        '';
      };
      createLocally = mkOption {
        type = types.bool;
        default = true;
        description = "Create the database and database user locally.";
      };
    };

    mail = {
      driver = mkOption {
        type = types.enum ["smtp" "sendmail"];
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
      fromName = mkOption {
        type = types.str;
        default = "monica";
        description = "Mail \"from\" name.";
      };
      from = mkOption {
        type = types.str;
        default = "mail@monica.com";
        description = "Mail \"from\" email.";
      };
      user = mkOption {
        type = with types; nullOr str;
        default = null;
        example = "monica";
        description = "Mail username.";
      };
      passwordFile = mkOption {
        type = with types; nullOr path;
        default = null;
        example = "/run/keys/monica-mailpassword";
        description = ''
          A file containing the password corresponding to
          <option>mail.user</option>.
        '';
      };
      encryption = mkOption {
        type = with types; nullOr (enum ["tls"]);
        default = null;
        description = "SMTP encryption mechanism to use.";
      };
    };

    maxUploadSize = mkOption {
      type = types.str;
      default = "18M";
      example = "1G";
      description = "The maximum size for uploads (e.g. images).";
    };

    poolConfig = mkOption {
      type = with types; attrsOf (oneOf [str int bool]);
      default = {
        "pm" = "dynamic";
        "pm.max_children" = 32;
        "pm.start_servers" = 2;
        "pm.min_spare_servers" = 2;
        "pm.max_spare_servers" = 4;
        "pm.max_requests" = 500;
      };
      description = ''
        Options for the monica PHP pool. See the documentation on <literal>php-fpm.conf</literal>
        for details on configuration directives.
      '';
    };

    nginx = mkOption {
      type = types.submodule (
        recursiveUpdate
        (import ../web-servers/nginx/vhost-options.nix {inherit config lib;}) {}
      );
      default = {};
      example = ''
        {
          serverAliases = [
            "monica.''${config.networking.domain}"
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
                  type = nullOr str;
                  description = ''
                    The path to a file containing the value the
                    option should be set to in the final
                    configuration file.
                  '';
                };
              };
            })));
      default = {};
      example = ''
        {
          ALLOWED_IFRAME_HOSTS = "https://example.com";
          WKHTMLTOPDF = "/home/user/bins/wkhtmltopdf";
          AUTH_METHOD = "oidc";
          OIDC_NAME = "MyLogin";
          OIDC_DISPLAY_NAME_CLAIMS = "name";
          OIDC_CLIENT_ID = "monica";
          OIDC_CLIENT_SECRET = {_secret = "/run/keys/oidc_secret"};
          OIDC_ISSUER = "https://keycloak.example.com/auth/realms/My%20Realm";
          OIDC_ISSUER_DISCOVER = true;
        }
      '';
      description = ''
        monica configuration options to set in the
        <filename>.env</filename> file.

        Refer to <link xlink:href="https://github.com/monicahq/monica"/>
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
      {
        assertion = db.createLocally -> db.user == user;
        message = "services.monica.database.user must be set to ${user} if services.monica.database.createLocally is set true.";
      }
      {
        assertion = db.createLocally -> db.passwordFile == null;
        message = "services.monica.database.passwordFile cannot be specified if services.monica.database.createLocally is set to true.";
      }
    ];

    services.monica.config = {
      APP_ENV = "production";
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
      APP_SERVICES_CACHE = "/run/monica/cache/services.php";
      APP_PACKAGES_CACHE = "/run/monica/cache/packages.php";
      APP_CONFIG_CACHE = "/run/monica/cache/config.php";
      APP_ROUTES_CACHE = "/run/monica/cache/routes-v7.php";
      APP_EVENTS_CACHE = "/run/monica/cache/events.php";
      SESSION_SECURE_COOKIE = tlsEnabled;
    };

    environment.systemPackages = [artisan];

    services.mysql = mkIf db.createLocally {
      enable = true;
      package = mkDefault pkgs.mariadb;
      ensureDatabases = [db.name];
      ensureUsers = [
        {
          name = db.user;
          ensurePermissions = {"${db.name}.*" = "ALL PRIVILEGES";};
        }
      ];
    };

    services.phpfpm.pools.monica = {
      inherit user group;
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
      recommendedBrotliSettings = true;
      recommendedProxySettings = true;
      virtualHosts.${cfg.hostname} = mkMerge [
        cfg.nginx
        {
          root = mkForce "${monica}/public";
          locations = {
            "/" = {
              index = "index.php";
              tryFiles = "$uri $uri/ /index.php?$query_string";
            };
            "~ \.php$".extraConfig = ''
              fastcgi_pass unix:${config.services.phpfpm.pools."monica".socket};
            '';
            "~ \.(js|css|gif|png|ico|jpg|jpeg)$" = {
              extraConfig = "expires 365d;";
            };
          };
        }
      ];
    };

    systemd.services.monica-setup = {
      description = "Preparation tasks for monica";
      before = ["phpfpm-monica.service"];
      after = optional db.createLocally "mysql.service";
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        User = user;
        UMask = 077;
        WorkingDirectory = "${monica}";
        RuntimeDirectory = "monica/cache";
        RuntimeDirectoryMode = 0700;
      };
      path = [pkgs.replace-secret];
      script = let
        isSecret = v: isAttrs v && v ? _secret && isString v._secret;
        monicaEnvVars = lib.generators.toKeyValue {
          mkKeyValue = lib.flip lib.generators.mkKeyValueDefault "=" {
            mkValueString = v:
              with builtins;
                if isInt v
                then toString v
                else if isString v
                then v
                else if true == v
                then "true"
                else if false == v
                then "false"
                else if isSecret v
                then hashString "sha256" v._secret
                else throw "unsupported type ${typeOf v}: ${(lib.generators.toPretty {}) v}";
          };
        };
        secretPaths = lib.mapAttrsToList (_: v: v._secret) (lib.filterAttrs (_: isSecret) cfg.config);
        mkSecretReplacement = file: ''
          replace-secret ${escapeShellArgs [(builtins.hashString "sha256" file) file "${cfg.dataDir}/.env"]}
        '';
        secretReplacements = lib.concatMapStrings mkSecretReplacement secretPaths;
        filteredConfig = lib.converge (lib.filterAttrsRecursive (_: v: ! elem v [{} null])) cfg.config;
        monicaEnv = pkgs.writeText "monica.env" (monicaEnvVars filteredConfig);
      in ''
        # error handling
        set -euo pipefail

        # create .env file
        install -T -m 0600 -o ${user} ${monicaEnv} "${cfg.dataDir}/.env"
        ${secretReplacements}
        if ! grep 'APP_KEY=base64:' "${cfg.dataDir}/.env" >/dev/null; then
          sed -i 's/APP_KEY=/APP_KEY=base64:/' "${cfg.dataDir}/.env"
        fi

        # migrate & seed db
        ${pkgs.php}/bin/php artisan key:generate --force
        ${pkgs.php}/bin/php artisan setup:production -v --force
      '';
    };

    systemd.services.monica-scheduler = {
      description = "Background tasks for monica";
      startAt = "minutely";
      after = ["monica-setup.service"];
      serviceConfig = {
        Type = "oneshot";
        User = user;
        WorkingDirectory = "${monica}";
        ExecStart = "${pkgs.php}/bin/php ${monica}/artisan schedule:run -v";
      };
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
      users = mkIf (user == "monica") {
        monica = {
          inherit group;
          isSystemUser = true;
        };
        "${config.services.nginx.user}".extraGroups = [group];
      };
      groups = mkIf (group == "monica") {
        monica = {};
      };
    };
  };
}

