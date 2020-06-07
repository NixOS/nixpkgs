{ config, lib, pkgs, ... }:

with lib;

let
  name = "pterodactyl-panel";
  cfg = config.services.${name};

  user = "pterodactyl";
  nginxUser = config.services.nginx.user;

  panelDir = cfg.dataDir + "/panel";

  artisan = "${pkgs.php}/bin/php ${panelDir}/artisan";

  environment = {
    DATA_DIR = panelDir;

    LOG_CHANNEL = cfg.logChannel;
    CACHE_DRIVER = cfg.cacheDriver;
    SESSION_DRIVER = cfg.sessionDriver;
    QUEUE_CONNECTION = cfg.queueDriver;

    REDIS_HOST = cfg.redis.host;
    REDIS_PORT = toString cfg.redis.port;
    REDIS_PASSWORD = cfg.redis.password;

    APP_ENV = "production";
    APP_ENVIRONMENT_ONLY = "false";
    APP_DEBUG = if cfg.app.debug then "true" else "false";
    APP_THEME = cfg.app.theme;
    APP_TIMEZONE = cfg.app.timezone;
    APP_CLEAR_TASKLOG = toString cfg.app.clearTaskLog;
    APP_DELETE_MINUTES = toString cfg.app.deleteMinutes;
    APP_LOCALE = cfg.app.locale;
    APP_SERVICE_AUTHOR = cfg.app.serviceAuthor;
    APP_URL = cfg.app.url;

    DB_HOST = cfg.database.host;
    DB_PORT = toString cfg.database.port;
    DB_DATABASE = cfg.database.name;
    DB_USERNAME = cfg.database.username;
    DB_PASSWORD = cfg.database.password;

    MAIL_DRIVER = cfg.mail.driver;
    MAIL_HOST = cfg.mail.host;
    MAIL_PORT = toString cfg.mail.port;
    MAIL_USERNAME = cfg.mail.username;
    MAIL_PASSWORD = cfg.mail.password;
    MAIL_ENCRYPTION = cfg.mail.encryption;
    MAIL_FROM = cfg.mail.fromAddress;
    MAIL_FROM_NAME = cfg.mail.fromName;

    MAILGUN_DOMAIN = cfg.mail.mailgunDomain;
    MAILGUN_SECRET = cfg.mail.mailgunSecret;
    MANDRILL_SECRET = cfg.mail.mandrillSecret;

    QUEUE_HIGH = cfg.queue.high;
    QUEUE_STANDARD = cfg.queue.standard;
    QUEUE_LOW = cfg.queue.low;

  };
in {
  options = {
    services.${name} = {
      enable = mkEnableOption ''
        Open-source game server management panel built with PHP7, Nodejs, and Go
      '';

      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/pterodactyl";
        description = ''
          The directory in which the panel data is stored.
          This does not have to be the same as the daemon directory.
        '';
      };

      cacheDriver = mkOption {
        type = types.enum [ "redis" "memcached" "file" ];
        default = "redis";
        description =
          "The driver to use for storing cache files. Redis is recommended.";
      };

      sessionDriver = mkOption {
        type = types.enum [ "redis" "memcached" "database" "file" "cookie" ];
        default = "redis";
        description =
          "The driver to use for user sessions. Redis is recommended.";
      };

      queueDriver = mkOption {
        type = types.enum [ "redis" "database" "sync" ];
        default = "redis";
        description = "The driver to use for job queues. Redis is recommended.";
      };

      logChannel = mkOption {
        type = types.enum [
          "stack"
          "single"
          "daily"
          "slack"
          "papertrail"
          "syslog"
          "errorlog"
          "monolog"
        ];
        default = "daily";
        description = "The log rotation interval";
      };

      app = mkOption {
        description = "General app settings";
        type = types.submodule {
          options = {
            debug = mkOption {
              type = types.bool;
              default = false;
              description = "Enables debug output";
            };

            theme = mkOption {
              type = types.str;
              default = "pterodactyl";
              description = "The UI theme";
            };

            timezone = mkOption {
              type = types.str;
              description = "The IANA timezone database name";
              default = toString config.time.timeZone;
              example = "Europe/London";
            };

            clearTaskLog = mkOption {
              type = types.ints.positive;
              default = 720;
            };

            deleteMinutes = mkOption {
              type = types.ints.positive;
              default = 10;
            };

            serviceAuthor = mkOption {
              type = types.str;
              description = "The webadmin email address";
              example = "mail@example.com";
            };

            url = mkOption {
              type = types.str;
              description = "The web interface address";
              default = "http://localhost";
              example = "https://example.com";
            };

            locale = mkOption {
              type = types.str;
              default = "en";
              description = "The short code for the interface language";
            };
          };
        };
      };

      database = mkOption {
        description = "MySQL database connection settings";
        type = types.submodule {
          options = {
            host = mkOption {
              type = types.str;
              description = "MySQL server address";
              default = "localhost";
            };

            port = mkOption {
              type = types.port;
              description = "MySQL server port";
              default = 3306;
            };

            name = mkOption {
              type = types.str;
              description = "MySQL database name";
              default = "panel";
            };

            username = mkOption {
              type = types.str;
              description = "MySQL server username";
              example = "pterodactyl";
            };

            password = mkOption {
              type = types.str;
              description = "MySQL server password";
            };
          };
        };
      };

      redis = mkOption {
        description = "Redis database connection settings";

        default = {
          host = "localhost";
          port = 6379;
          password = "";
        };

        type = types.submodule {
          options = {
            host = mkOption {
              type = types.str;
              description = "Redis server address";
              default = "localhost";
            };

            port = mkOption {
              type = types.port;
              description = "Redis server port";
              default = 6379;
            };

            password = mkOption {
              type = types.str;
              description = "Redis server password";
            };
          };
        };
      };

      mail = mkOption {
        description = ''
          Outgoing mail server settings. This support a variety of drivers, and the required settings will vary on the one selected.

          To use PHP's internal mail sending (not recommended), select "mail". To use a custom SMTP server, select "smtp".
        '';

        default = {
          driver = "mail";
          host = "";
          port = 587;
          username = "";
          password = "";
          encryption = "tls";
          fromAddress = "";
          fromName = "Pterodactyl Panel";

          mailgunDomain = "";
          mailgunSecret = "";
          mandrillSecret = "";
        };

        type = types.submodule {
          options = {
            driver = mkOption {
              type = types.enum [ "smtp" "mail" "mailgun" "mandrill" ];
              default = "mail";
              description =
                "The PHP mail driver to use. For Postmark, use 'smtp'.";
            };

            host = mkOption {
              type = types.str;
              default = "";
              description =
                "The mail server address. This is required for SMTP; for Postmark, use 'smtp.postmarkapp.com'.";
            };

            port = mkOption {
              type = types.port;
              default = 587;
              description = "The mail server port. This is required for SMTP.";
            };

            username = mkOption {
              type = types.str;
              default = "";
              description =
                "The mail server username. This is required for SMTP.";
            };

            password = mkOption {
              type = types.str;
              default = "";
              description =
                "The mail server password. This is required for SMTP.";
            };

            encryption = mkOption {
              type = types.enum [ "tls" "ssl" null ];
              default = "tls";
              description = "The encryption method to use when sending mail.";
            };

            fromAddress = mkOption {
              type = types.str;
              description =
                "The email address to show mail is sent from. This is required by all drivers.";
              example = "mail@example.com";
            };

            fromName = mkOption {
              type = types.str;
              description = "The name to show mail is sent from.";
              default = "Pterodactyl Panel";
              example = "Joe Bloggs";
            };

            # driver specifics
            mailgunDomain = mkOption {
              type = types.str;
              description =
                "The Mailgun server domain. This is required for Mailgun.";
              default = "";
            };

            mailgunSecret = mkOption {
              type = types.str;
              description =
                "The Mailgun server secret. This is required for Mailgun.";
              default = "";
            };

            mandrillSecret = mkOption {
              type = types.str;
              description =
                "The Mandrill server secret. This is required for Mandrill.";
              default = "";
            };
          };
        };
      };

      queue = mkOption {
        description =
          "Job queue priority settings. In most cases, these can be left alone.";

        default = {
          high = "high";
          standard = "standard";
          low = "low";
        };

        type = types.submodule {
          options = {
            high = mkOption {
              type = types.enum [ "high" "standard" "low" ];
              default = "high";
              description = "The queue priority to use for high-priority jobs";
            };

            standard = mkOption {
              type = types.enum [ "high" "standard" "low" ];
              default = "standard";
              description =
                "The queue priority to use for standard-priority jobs";
            };

            low = mkOption {
              type = types.enum [ "high" "standard" "low" ];
              default = "low";
              description = "The queue priority to use for low-priority jobs";
            };
          };
        };
      };

      ensureUsers = mkOption {
        description = ''
          Specifies a list of users to be created if they do not exist.
          These are admin by default, and Nix will not update them once created.
        '';

        default = [ ];
        type = types.listOf (types.submodule {
          options = {
            firstName = mkOption {
              type = types.str;
              description = "The user's first name";
              example = "Joe";
            };

            lastName = mkOption {
              type = types.str;
              description = "The user's last name";
              example = "Bloggs";
            };

            username = mkOption {
              type = types.str;
              description = "The login username";
            };

            email = mkOption {
              type = types.str;
              description = "The user's email address";
              example = "mail@example.com";
            };

            password = mkOption {
              type = types.str;
              description = "The user's login password";
            };

            isAdmin = mkOption {
              type = types.bool;
              default = true;
              description = "Whether the user should be given admin privileges";
            };
          };
        });
      };
    };
  };

  config = mkIf cfg.enable {
    users.groups.${user} = { };
    users.users.${user} = {
      description = "Pterodactyl service user";
      home = cfg.dataDir;
      createHome = true;
      extraGroups = [ nginxUser ];
    };

    systemd.services."${name}-setup" = {

      wantedBy = [ "multi-user.target" ];
      before = [ "${name}.service" ];
      serviceConfig.Type = "oneshot";

      environment = environment // { APP_ENV = "development"; };

      script = ''
        mkdir -p ${cfg.dataDir}
        chmod +x ${cfg.dataDir} 

        # create required directories
        mkdir -p ${panelDir + "/storage/app/packs"}
        mkdir -p ${panelDir + "/storage/debugbar"}
        mkdir -p ${panelDir + "/storage/framework/{cache/data,sessions,views}"}
        mkdir -p ${panelDir + "/storage/logs"}
        mkdir -p ${panelDir + "/bootstrap/cache"}

        # TODO: Check if this is necessary
        cp -r ${pkgs.pterodactyl-panel}/public ${panelDir}

        ln -sfn ${pkgs.pterodactyl-panel}/vendor ${panelDir}/vendor
        ln -sf ${pkgs.pterodactyl-panel}/bootstrap/app.php ${panelDir}/bootstrap/app.php
        cp ${pkgs.pterodactyl-panel}/artisan ${panelDir}/artisan

        # Copy the example .env filw
        # This will contain the environment variables that are not configured, such as the app key.
        if [ ! -f ${panelDir}/.env ]; then
          echo "Creating .env file"
          cp ${pkgs.pterodactyl-panel}/.env.example ${panelDir}/.env
        fi

        # From the docs:
        # Only run the command below if you are installing this Panel for
        # the first time and do not have any Pterodactyl Panel data in the database.
        if ! egrep -q -Eo 'APP_KEY=.{1,}' ${panelDir}/.env; then 
          # TODO: Investigate why this fails sometimes
          echo "Generating app key"
          ${artisan} key:generate --force
        fi

        echo "Performing database migration"
        ${artisan} migrate

        echo "Seeding the database"
        ${artisan} db:seed

        echo "Creating user accounts"
        ${concatMapStrings (user: ''
          if [ ! -z $(echo "SELECT username FROM ${cfg.database.name}.users WHERE username='${user.username}';" | mysql -h ${cfg.database.host} -u ${cfg.database.username} -p${cfg.database.password} -N) ]; then
            ${artisan} p:user:make --name-first ${user.firstName} --name-last ${user.lastName} --username ${user.username} --email ${user.email} --password ${user.password} --admin ${
              if user.isAdmin then toString 1 else toString 0
            }
          fi
        '') cfg.ensureUsers}

        # Set permissions so pterodactl and nginx can read/write
        chown -R ${nginxUser}:${nginxUser} ${panelDir}
        chown -R ${user}:${user} ${panelDir}/bootstrap

        chmod +x ${panelDir}/public/index.php

        # Fix log permissions
        chown -R ${nginxUser}:${nginxUser} ${panelDir}/storage/logs
        chmod -R 775 ${panelDir}/storage/logs
      '';
    };

    systemd.services.${name} = {
      inherit environment;

      description =
        "Open-source game server management panel built with PHP7, Nodejs, and Go";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        User = "${user}";
        Restart = "on-failure";
        ExecStart =
          "${artisan} queue:work --queue=high,standard,low --sleep=3 --tries=3";
        WorkingDirectory = panelDir;
      };
    };

    systemd.timers."${name}-schedule" = {
      wantedBy = [ "timers.target" ];
      partOf = [ "${name}-schedule.service" ];
      timerConfig.OnCalendar = "minutely";
    };

    systemd.services."${name}-schedule" = {
      inherit environment;

      serviceConfig.Type = "oneshot";
      script = "${artisan} schedule:run >> /dev/null 2>&1";
    };

    services.nginx = {
      enable = true;
      virtualHosts."pterodactyl.lan" = {
        default = true;
        root = panelDir + "/public";
        extraConfig = ''
          index index.html index.htm index.php;
          charset utf-8;

          location / {
              try_files $uri $uri/ /index.php?$query_string;
          }

          location = /favicon.ico { access_log off; log_not_found off; }
          location = /robots.txt  { access_log off; log_not_found off; }

          # access_log off;
          # error_log  /var/log/nginx/pterodactyl.app-error.log error;

          # allow larger file uploads and longer script runtimes
          client_max_body_size 100m;
          client_body_timeout 120s;

          sendfile off;

          location ~ \.php$ {
              fastcgi_split_path_info ^(.+\.php)(/.+)$;
              fastcgi_pass unix:${config.services.phpfpm.pools.${name}.socket};
              include ${pkgs.nginx}/conf/fastcgi_params;
              include ${pkgs.nginx}/conf/fastcgi.conf;
              fastcgi_index index.php;
              fastcgi_param PHP_VALUE "upload_max_filesize = 100M \n post_max_size=100M";
              fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
              fastcgi_param HTTP_PROXY "";
              fastcgi_intercept_errors off;
              fastcgi_buffer_size 16k;
              fastcgi_buffers 4 16k;
              fastcgi_connect_timeout 300;
              fastcgi_send_timeout 300;
              fastcgi_read_timeout 300;
          }

          location ~ /\.ht {
              deny all;
          }
        '';
      };
    };

    services.phpfpm.pools.${name} = {
      user = nginxUser;
      group = nginxUser;
      settings = {
        "listen.owner" = nginxUser;
        "pm" = "dynamic";
        "pm.max_children" = 32;
        "pm.max_requests" = 500;
        "pm.start_servers" = 2;
        "pm.min_spare_servers" = 2;
        "pm.max_spare_servers" = 5;
        "php_admin_value[error_log]" = "stderr";
        "php_admin_flag[log_errors]" = true;
        "catch_workers_output" = true;
      };

      # PHP FPM complains about empty keys or keys set to false.
      # Luckily we can safely filter these out.
      phpEnv = (filterAttrs (k: v: v != "false" && v != "") environment) // {
        PATH = lib.makeBinPath [ pkgs.php ];
      };
    };
  };
}
