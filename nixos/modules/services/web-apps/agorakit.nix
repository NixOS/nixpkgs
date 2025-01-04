{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.services.agorakit;
  agorakit = pkgs.agorakit.override { dataDir = cfg.dataDir; };
  db = cfg.database;
  mail = cfg.mail;

  user = cfg.user;
  group = cfg.group;

  # shell script for local administration
  artisan = pkgs.writeScriptBin "agorakit" ''
    #! ${pkgs.runtimeShell}
    cd ${agorakit}
    sudo() {
      if [[ "$USER" != ${user} ]]; then
        exec /run/wrappers/bin/sudo -u ${user} "$@"
      else
        exec "$@"
      fi
    }
    sudo ${lib.getExe pkgs.php} artisan "$@"
  '';

  tlsEnabled = cfg.nginx.addSSL || cfg.nginx.forceSSL || cfg.nginx.onlySSL || cfg.nginx.enableACME;
in
{
  options.services.agorakit = {
    enable = mkEnableOption "agorakit";

    user = mkOption {
      default = "agorakit";
      description = "User agorakit runs as.";
      type = types.str;
    };

    group = mkOption {
      default = "agorakit";
      description = "Group agorakit runs as.";
      type = types.str;
    };

    appKeyFile = mkOption {
      description = ''
        A file containing the Laravel APP_KEY - a 32 character long,
        base64 encoded key used for encryption where needed. Can be
        generated with <code>head -c 32 /dev/urandom | base64</code>.
      '';
      example = "/run/keys/agorakit-appkey";
      type = types.path;
    };

    hostName = lib.mkOption {
      type = lib.types.str;
      default =
        if config.networking.domain != null then config.networking.fqdn else config.networking.hostName;
      defaultText = lib.literalExpression "config.networking.fqdn";
      example = "agorakit.example.com";
      description = ''
        The hostname to serve agorakit on.
      '';
    };

    appURL = mkOption {
      description = ''
        The root URL that you want to host agorakit on. All URLs in agorakit will be generated using this value.
        If you change this in the future you may need to run a command to update stored URLs in the database.
        Command example: <code>php artisan agorakit:update-url https://old.example.com https://new.example.com</code>
      '';
      default = "http${lib.optionalString tlsEnabled "s"}://${cfg.hostName}";
      defaultText = ''http''${lib.optionalString tlsEnabled "s"}://''${cfg.hostName}'';
      example = "https://example.com";
      type = types.str;
    };

    dataDir = mkOption {
      description = "agorakit data directory";
      default = "/var/lib/agorakit";
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
        default = "agorakit";
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
        example = "/run/keys/agorakit-dbpassword";
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
        type = types.enum [
          "smtp"
          "sendmail"
        ];
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
        default = "agorakit";
        description = "Mail \"from\" name.";
      };
      from = mkOption {
        type = types.str;
        default = "mail@agorakit.com";
        description = "Mail \"from\" email.";
      };
      user = mkOption {
        type = with types; nullOr str;
        default = null;
        example = "agorakit";
        description = "Mail username.";
      };
      passwordFile = mkOption {
        type = with types; nullOr path;
        default = null;
        example = "/run/keys/agorakit-mailpassword";
        description = ''
          A file containing the password corresponding to
          <option>mail.user</option>.
        '';
      };
      encryption = mkOption {
        type = with types; nullOr (enum [ "tls" ]);
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
      type =
        with types;
        attrsOf (oneOf [
          str
          int
          bool
        ]);
      default = {
        "pm" = "dynamic";
        "pm.max_children" = 32;
        "pm.start_servers" = 2;
        "pm.min_spare_servers" = 2;
        "pm.max_spare_servers" = 4;
        "pm.max_requests" = 500;
      };
      description = ''
        Options for the agorakit PHP pool. See the documentation on <literal>php-fpm.conf</literal>
        for details on configuration directives.
      '';
    };

    nginx = mkOption {
      type = types.submodule (
        recursiveUpdate (import ../web-servers/nginx/vhost-options.nix {
          inherit config lib;
        }) { }
      );
      default = { };
      example = ''
        {
          serverAliases = [
            "agorakit.''${config.networking.domain}"
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
      type =
        with types;
        attrsOf (
          nullOr (
            either
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
              })
          )
        );
      default = { };
      example = ''
        {
          ALLOWED_IFRAME_HOSTS = "https://example.com";
          AUTH_METHOD = "oidc";
          OIDC_NAME = "MyLogin";
          OIDC_DISPLAY_NAME_CLAIMS = "name";
          OIDC_CLIENT_ID = "agorakit";
          OIDC_CLIENT_SECRET = {_secret = "/run/keys/oidc_secret"};
          OIDC_ISSUER = "https://keycloak.example.com/auth/realms/My%20Realm";
          OIDC_ISSUER_DISCOVER = true;
        }
      '';
      description = ''
        Agorakit configuration options to set in the
        <filename>.env</filename> file.

        Refer to <link xlink:href="https://github.com/agorakit/agorakit"/>
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
        message = "services.agorakit.database.user must be set to ${user} if services.agorakit.database.createLocally is set true.";
      }
      {
        assertion = db.createLocally -> db.passwordFile == null;
        message = "services.agorakit.database.passwordFile cannot be specified if services.agorakit.database.createLocally is set to true.";
      }
    ];

    services.agorakit.config = {
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
      APP_SERVICES_CACHE = "/run/agorakit/cache/services.php";
      APP_PACKAGES_CACHE = "/run/agorakit/cache/packages.php";
      APP_CONFIG_CACHE = "/run/agorakit/cache/config.php";
      APP_ROUTES_CACHE = "/run/agorakit/cache/routes-v7.php";
      APP_EVENTS_CACHE = "/run/agorakit/cache/events.php";
      SESSION_SECURE_COOKIE = tlsEnabled;
    };

    environment.systemPackages = [ artisan ];

    services.mysql = mkIf db.createLocally {
      enable = true;
      package = mkDefault pkgs.mariadb;
      ensureDatabases = [ db.name ];
      ensureUsers = [
        {
          name = db.user;
          ensurePermissions = {
            "${db.name}.*" = "ALL PRIVILEGES";
          };
        }
      ];
    };

    services.phpfpm.pools.agorakit = {
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
      virtualHosts.${cfg.hostName} = mkMerge [
        cfg.nginx
        {
          root = mkForce "${agorakit}/public";
          locations = {
            "/" = {
              index = "index.php";
              tryFiles = "$uri $uri/ /index.php?$query_string";
            };
            "~ \.php$".extraConfig = ''
              fastcgi_pass unix:${config.services.phpfpm.pools."agorakit".socket};
            '';
            "~ \.(js|css|gif|png|ico|jpg|jpeg)$" = {
              extraConfig = "expires 365d;";
            };
          };
        }
      ];
    };

    systemd.services.agorakit-setup = {
      description = "Preparation tasks for agorakit";
      before = [ "phpfpm-agorakit.service" ];
      after = optional db.createLocally "mysql.service";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        User = user;
        UMask = 77;
        WorkingDirectory = "${agorakit}";
        RuntimeDirectory = "agorakit/cache";
        RuntimeDirectoryMode = 700;
      };
      path = [ pkgs.replace-secret ];
      script =
        let
          isSecret = v: isAttrs v && v ? _secret && isString v._secret;
          agorakitEnvVars = lib.generators.toKeyValue {
            mkKeyValue = lib.flip lib.generators.mkKeyValueDefault "=" {
              mkValueString =
                v:
                with builtins;
                if isInt v then
                  toString v
                else if isString v then
                  v
                else if true == v then
                  "true"
                else if false == v then
                  "false"
                else if isSecret v then
                  hashString "sha256" v._secret
                else
                  throw "unsupported type ${typeOf v}: ${(lib.generators.toPretty { }) v}";
            };
          };
          secretPaths = lib.mapAttrsToList (_: v: v._secret) (lib.filterAttrs (_: isSecret) cfg.config);
          mkSecretReplacement = file: ''
            replace-secret ${
              escapeShellArgs [
                (builtins.hashString "sha256" file)
                file
                "${cfg.dataDir}/.env"
              ]
            }
          '';
          secretReplacements = lib.concatMapStrings mkSecretReplacement secretPaths;
          filteredConfig = lib.converge (lib.filterAttrsRecursive (
            _: v:
            !elem v [
              { }
              null
            ]
          )) cfg.config;
          agorakitEnv = pkgs.writeText "agorakit.env" (agorakitEnvVars filteredConfig);
        in
        ''
          # error handling
          set -euo pipefail

          # create .env file
          install -T -m 0600 -o ${user} ${agorakitEnv} "${cfg.dataDir}/.env"
          ${secretReplacements}
          if ! grep 'APP_KEY=base64:' "${cfg.dataDir}/.env" >/dev/null; then
            sed -i 's/APP_KEY=/APP_KEY=base64:/' "${cfg.dataDir}/.env"
          fi

          # migrate & seed db
          ${pkgs.php}/bin/php artisan key:generate --force
          ${pkgs.php}/bin/php artisan migrate --force
          ${pkgs.php}/bin/php artisan config:cache
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
      users = mkIf (user == "agorakit") {
        agorakit = {
          inherit group;
          isSystemUser = true;
        };
        "${config.services.nginx.user}".extraGroups = [ group ];
      };
      groups = mkIf (group == "agorakit") { agorakit = { }; };
    };
  };
}
