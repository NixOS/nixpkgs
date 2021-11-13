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


in {
  options.services.bookstack = {

    enable = mkEnableOption "BookStack";

    user = mkOption {
      default = "bookstack";
      description = "User bookstack runs as.";
      type = types.str;
    };

    group = mkOption {
      default = "bookstack";
      description = "Group bookstack runs as.";
      type = types.str;
    };

    appKeyFile = mkOption {
      description = ''
        A file containing the AppKey.
        Used for encryption where needed. Can be generated with <code>head -c 32 /dev/urandom| base64</code> and must be prefixed with <literal>base64:</literal>.
      '';
      example = "/run/keys/bookstack-appkey";
      type = types.path;
    };

    appURL = mkOption {
      description = ''
        The root URL that you want to host BookStack on. All URLs in BookStack will be generated using this value.
        If you change this in the future you may need to run a command to update stored URLs in the database. Command example: <code>php artisan bookstack:update-url https://old.example.com https://new.example.com</code>
      '';
      example = "https://example.com";
      type = types.str;
    };

    cacheDir = mkOption {
      description = "BookStack cache directory";
      default = "/var/cache/bookstack";
      type = types.path;
    };

    dataDir = mkOption {
      description = "BookStack data directory";
      default = "/var/lib/bookstack";
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
        default = "bookstack";
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
        example = "/run/keys/bookstack-dbpassword";
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
      fromName = mkOption {
        type = types.str;
        default = "BookStack";
        description = "Mail \"from\" name.";
      };
      from = mkOption {
        type = types.str;
        default = "mail@bookstackapp.com";
        description = "Mail \"from\" email.";
      };
      user = mkOption {
        type = with types; nullOr str;
        default = null;
        example = "bookstack";
        description = "Mail username.";
      };
      passwordFile = mkOption {
        type = with types; nullOr path;
        default = null;
        example = "/run/keys/bookstack-mailpassword";
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
        Options for the bookstack PHP pool. See the documentation on <literal>php-fpm.conf</literal>
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
      description = ''
        With this option, you can customize the nginx virtualHost settings.
      '';
    };

    extraConfig = mkOption {
      type = types.nullOr types.lines;
      default = null;
      example = ''
        ALLOWED_IFRAME_HOSTS="https://example.com"
        WKHTMLTOPDF=/home/user/bins/wkhtmltopdf
      '';
      description = ''
        Lines to be appended verbatim to the BookStack configuration.
        Refer to <link xlink:href="https://www.bookstackapp.com/docs/"/> for details on supported values.
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
      virtualHosts.bookstack = mkMerge [ cfg.nginx {
        root = mkForce "${bookstack}/public";
        extraConfig = optionalString (cfg.nginx.addSSL || cfg.nginx.forceSSL || cfg.nginx.onlySSL || cfg.nginx.enableACME) "fastcgi_param HTTPS on;";
        locations = {
          "/" = {
            index = "index.php";
            extraConfig = ''try_files $uri $uri/ /index.php?$query_string;'';
          };
          "~ \.php$" = {
            extraConfig = ''
              try_files $uri $uri/ /index.php?$query_string;
              include ${pkgs.nginx}/conf/fastcgi_params;
              fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
              fastcgi_param REDIRECT_STATUS 200;
              fastcgi_pass unix:${config.services.phpfpm.pools."bookstack".socket};
              ${optionalString (cfg.nginx.addSSL || cfg.nginx.forceSSL || cfg.nginx.onlySSL || cfg.nginx.enableACME) "fastcgi_param HTTPS on;"}
            '';
          };
          "~ \.(js|css|gif|png|ico|jpg|jpeg)$" = {
            extraConfig = "expires 365d;";
          };
        };
      }];
    };

    systemd.services.bookstack-setup = {
      description = "Preperation tasks for BookStack";
      before = [ "phpfpm-bookstack.service" ];
      after = optional db.createLocally "mysql.service";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        User = user;
        WorkingDirectory = "${bookstack}";
      };
      script = ''
        # set permissions
        umask 077
        # create .env file
        echo "
        APP_KEY=base64:$(head -n1 ${cfg.appKeyFile})
        APP_URL=${cfg.appURL}
        DB_HOST=${db.host}
        DB_PORT=${toString db.port}
        DB_DATABASE=${db.name}
        DB_USERNAME=${db.user}
        MAIL_DRIVER=${mail.driver}
        MAIL_FROM_NAME=\"${mail.fromName}\"
        MAIL_FROM=${mail.from}
        MAIL_HOST=${mail.host}
        MAIL_PORT=${toString mail.port}
        ${optionalString (mail.user != null) "MAIL_USERNAME=${mail.user};"}
        ${optionalString (mail.encryption != null) "MAIL_ENCRYPTION=${mail.encryption};"}
        ${optionalString (db.passwordFile != null) "DB_PASSWORD=$(head -n1 ${db.passwordFile})"}
        ${optionalString (mail.passwordFile != null) "MAIL_PASSWORD=$(head -n1 ${mail.passwordFile})"}
        APP_SERVICES_CACHE=${cfg.cacheDir}/services.php
        APP_PACKAGES_CACHE=${cfg.cacheDir}/packages.php
        APP_CONFIG_CACHE=${cfg.cacheDir}/config.php
        APP_ROUTES_CACHE=${cfg.cacheDir}/routes-v7.php
        APP_EVENTS_CACHE=${cfg.cacheDir}/events.php
        ${optionalString (cfg.nginx.addSSL || cfg.nginx.forceSSL || cfg.nginx.onlySSL || cfg.nginx.enableACME) "SESSION_SECURE_COOKIE=true"}
        ${toString cfg.extraConfig}
        " > "${cfg.dataDir}/.env"

        # migrate db
        ${pkgs.php}/bin/php artisan migrate --force

        # clear & create caches (needed in case of update)
        ${pkgs.php}/bin/php artisan cache:clear
        ${pkgs.php}/bin/php artisan config:clear
        ${pkgs.php}/bin/php artisan view:clear
        ${pkgs.php}/bin/php artisan config:cache
        ${pkgs.php}/bin/php artisan route:cache
        ${pkgs.php}/bin/php artisan view:cache
      '';
    };

    systemd.tmpfiles.rules = [
      "d ${cfg.cacheDir}                           0700 ${user} ${group} - -"
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
