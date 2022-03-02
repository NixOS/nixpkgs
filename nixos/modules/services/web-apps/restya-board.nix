{ config, lib, pkgs, ... }:

with lib;

# TODO: are these php-packages needed?
#imagick
#php-geoip -> php.ini: extension = geoip.so
#expat

let
  cfg = config.services.restya-board;
  fpm = config.services.phpfpm.pools.${poolName};

  runDir = "/run/restya-board";

  poolName = "restya-board";

in

{

  ###### interface

  options = {

    services.restya-board = {

      enable = mkEnableOption "restya-board";

      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/restya-board";
        description = ''
          Data of the application.
        '';
      };

      user = mkOption {
        type = types.str;
        default = "restya-board";
        description = ''
          User account under which the web-application runs.
        '';
      };

      group = mkOption {
        type = types.str;
        default = "nginx";
        description = ''
          Group account under which the web-application runs.
        '';
      };

      virtualHost = {
        serverName = mkOption {
          type = types.str;
          default = "restya.board";
          description = ''
            Name of the nginx virtualhost to use.
          '';
        };

        listenHost = mkOption {
          type = types.str;
          default = "localhost";
          description = ''
            Listen address for the virtualhost to use.
          '';
        };

        listenPort = mkOption {
          type = types.int;
          default = 3000;
          description = ''
            Listen port for the virtualhost to use.
          '';
        };
      };

      database = {
        host = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
            Host of the database. Leave 'null' to use a local PostgreSQL database.
            A local PostgreSQL database is initialized automatically.
          '';
        };

        port = mkOption {
          type = types.nullOr types.int;
          default = 5432;
          description = ''
            The database's port.
          '';
        };

        name = mkOption {
          type = types.str;
          default = "restya_board";
          description = ''
            Name of the database. The database must exist.
          '';
        };

        user = mkOption {
          type = types.str;
          default = "restya_board";
          description = ''
            The database user. The user must exist and have access to
            the specified database.
          '';
        };

        passwordFile = mkOption {
          type = types.nullOr types.path;
          default = null;
          description = ''
            The database user's password. 'null' if no password is set.
          '';
        };
      };

      email = {
        server = mkOption {
          type = types.nullOr types.str;
          default = null;
          example = "localhost";
          description = ''
            Hostname to send outgoing mail. Null to use the system MTA.
          '';
        };

        port = mkOption {
          type = types.int;
          default = 25;
          description = ''
            Port used to connect to SMTP server.
          '';
        };

        login = mkOption {
          type = types.str;
          default = "";
          description = ''
            SMTP authentication login used when sending outgoing mail.
          '';
        };

        password = mkOption {
          type = types.str;
          default = "";
          description = ''
            SMTP authentication password used when sending outgoing mail.

            ATTENTION: The password is stored world-readable in the nix-store!
          '';
        };
      };

      timezone = mkOption {
        type = types.lines;
        default = "GMT";
        description = ''
          Timezone the web-app runs in.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    services.phpfpm.pools = {
      ${poolName} = {
        inherit (cfg) user group;

        phpOptions = ''
          date.timezone = "CET"

          ${optionalString (cfg.email.server != null) ''
            SMTP = ${cfg.email.server}
            smtp_port = ${toString cfg.email.port}
            auth_username = ${cfg.email.login}
            auth_password = ${cfg.email.password}
          ''}
        '';
        settings = mapAttrs (name: mkDefault) {
          "listen.owner" = "nginx";
          "listen.group" = "nginx";
          "listen.mode" = "0600";
          "pm" = "dynamic";
          "pm.max_children" = 75;
          "pm.start_servers" = 10;
          "pm.min_spare_servers" = 5;
          "pm.max_spare_servers" = 20;
          "pm.max_requests" = 500;
          "catch_workers_output" = 1;
        };
      };
    };

    services.nginx.enable = true;
    services.nginx.virtualHosts.${cfg.virtualHost.serverName} = {
      listen = [ { addr = cfg.virtualHost.listenHost; port = cfg.virtualHost.listenPort; } ];
      serverName = cfg.virtualHost.serverName;
      root = runDir;
      extraConfig = ''
        index index.html index.php;

        gzip on;

        gzip_comp_level 6;
        gzip_min_length  1100;
        gzip_buffers 16 8k;
        gzip_proxied any;
        gzip_types text/plain application/xml text/css text/js text/xml application/x-javascript text/javascript application/json application/xml+rss;

        client_max_body_size 300M;

        rewrite ^/oauth/authorize$ /server/php/authorize.php last;
        rewrite ^/oauth_callback/([a-zA-Z0-9_\.]*)/([a-zA-Z0-9_\.]*)$ /server/php/oauth_callback.php?plugin=$1&code=$2 last;
        rewrite ^/download/([0-9]*)/([a-zA-Z0-9_\.]*)$ /server/php/download.php?id=$1&hash=$2 last;
        rewrite ^/ical/([0-9]*)/([0-9]*)/([a-z0-9]*).ics$ /server/php/ical.php?board_id=$1&user_id=$2&hash=$3 last;
        rewrite ^/api/(.*)$ /server/php/R/r.php?_url=$1&$args last;
        rewrite ^/api_explorer/api-docs/$ /client/api_explorer/api-docs/index.php last;
      '';

      locations."/".root = "${runDir}/client";

      locations."~ \\.php$" = {
        tryFiles = "$uri =404";
        extraConfig = ''
          include ${config.services.nginx.package}/conf/fastcgi_params;
          fastcgi_pass    unix:${fpm.socket};
          fastcgi_index   index.php;
          fastcgi_param   SCRIPT_FILENAME $document_root$fastcgi_script_name;
          fastcgi_param   PHP_VALUE "upload_max_filesize=9G \n post_max_size=9G \n max_execution_time=200 \n max_input_time=200 \n memory_limit=256M";
        '';
      };

      locations."~* \\.(css|js|less|html|ttf|woff|jpg|jpeg|gif|png|bmp|ico)" = {
        root = "${runDir}/client";
        extraConfig = ''
          if (-f $request_filename) {
                  break;
          }
          rewrite ^/img/([a-zA-Z_]*)/([a-zA-Z_]*)/([a-zA-Z0-9_\.]*)$ /server/php/image.php?size=$1&model=$2&filename=$3 last;
          add_header        Cache-Control public;
          add_header        Cache-Control must-revalidate;
          expires           7d;
        '';
      };
    };

    systemd.services.restya-board-init = {
      description = "Restya board initialization";
      serviceConfig.Type = "oneshot";
      serviceConfig.RemainAfterExit = true;

      wantedBy = [ "multi-user.target" ];
      requires = [ "postgresql.service" ];
      after = [ "network.target" "postgresql.service" ];

      script = ''
        rm -rf "${runDir}"
        mkdir -m 750 -p "${runDir}"
        cp -r "${pkgs.restya-board}/"* "${runDir}"
        sed -i "s/@restya.com/@${cfg.virtualHost.serverName}/g" "${runDir}/sql/restyaboard_with_empty_data.sql"
        rm -rf "${runDir}/media"
        rm -rf "${runDir}/client/img"
        chmod -R 0750 "${runDir}"

        sed -i "s@^php@${config.services.phpfpm.phpPackage}/bin/php@" "${runDir}/server/php/shell/"*.sh

        ${if (cfg.database.host == null) then ''
          sed -i "s/^.*'R_DB_HOST'.*$/define('R_DB_HOST', 'localhost');/g" "${runDir}/server/php/config.inc.php"
          sed -i "s/^.*'R_DB_PASSWORD'.*$/define('R_DB_PASSWORD', 'restya');/g" "${runDir}/server/php/config.inc.php"
        '' else ''
          sed -i "s/^.*'R_DB_HOST'.*$/define('R_DB_HOST', '${cfg.database.host}');/g" "${runDir}/server/php/config.inc.php"
          sed -i "s/^.*'R_DB_PASSWORD'.*$/define('R_DB_PASSWORD', ${if cfg.database.passwordFile == null then "''" else "'file_get_contents(${cfg.database.passwordFile})'"});/g" "${runDir}/server/php/config.inc.php
        ''}
        sed -i "s/^.*'R_DB_PORT'.*$/define('R_DB_PORT', '${toString cfg.database.port}');/g" "${runDir}/server/php/config.inc.php"
        sed -i "s/^.*'R_DB_NAME'.*$/define('R_DB_NAME', '${cfg.database.name}');/g" "${runDir}/server/php/config.inc.php"
        sed -i "s/^.*'R_DB_USER'.*$/define('R_DB_USER', '${cfg.database.user}');/g" "${runDir}/server/php/config.inc.php"

        chmod 0400 "${runDir}/server/php/config.inc.php"

        ln -sf "${cfg.dataDir}/media" "${runDir}/media"
        ln -sf "${cfg.dataDir}/client/img" "${runDir}/client/img"

        chmod g+w "${runDir}/tmp/cache"
        chown -R "${cfg.user}"."${cfg.group}" "${runDir}"


        mkdir -m 0750 -p "${cfg.dataDir}"
        mkdir -m 0750 -p "${cfg.dataDir}/media"
        mkdir -m 0750 -p "${cfg.dataDir}/client/img"
        cp -r "${pkgs.restya-board}/media/"* "${cfg.dataDir}/media"
        cp -r "${pkgs.restya-board}/client/img/"* "${cfg.dataDir}/client/img"
        chown "${cfg.user}"."${cfg.group}" "${cfg.dataDir}"
        chown -R "${cfg.user}"."${cfg.group}" "${cfg.dataDir}/media"
        chown -R "${cfg.user}"."${cfg.group}" "${cfg.dataDir}/client/img"

        ${optionalString (cfg.database.host == null) ''
          if ! [ -e "${cfg.dataDir}/.db-initialized" ]; then
            ${pkgs.sudo}/bin/sudo -u ${config.services.postgresql.superUser} \
              ${config.services.postgresql.package}/bin/psql -U ${config.services.postgresql.superUser} \
              -c "CREATE USER ${cfg.database.user} WITH ENCRYPTED PASSWORD 'restya'"

            ${pkgs.sudo}/bin/sudo -u ${config.services.postgresql.superUser} \
              ${config.services.postgresql.package}/bin/psql -U ${config.services.postgresql.superUser} \
              -c "CREATE DATABASE ${cfg.database.name} OWNER ${cfg.database.user} ENCODING 'UTF8' TEMPLATE template0"

            ${pkgs.sudo}/bin/sudo -u ${cfg.user} \
              ${config.services.postgresql.package}/bin/psql -U ${cfg.database.user} \
              -d ${cfg.database.name} -f "${runDir}/sql/restyaboard_with_empty_data.sql"

            touch "${cfg.dataDir}/.db-initialized"
          fi
        ''}
      '';
    };

    systemd.timers.restya-board = {
      description = "restya-board scripts for e.g. email notification";
      wantedBy = [ "timers.target" ];
      after = [ "restya-board-init.service" ];
      requires = [ "restya-board-init.service" ];
      timerConfig = {
        OnUnitInactiveSec = "60s";
        Unit = "restya-board-timers.service";
      };
    };

    systemd.services.restya-board-timers = {
      description = "restya-board scripts for e.g. email notification";
      serviceConfig.Type = "oneshot";
      serviceConfig.User = cfg.user;

      after = [ "restya-board-init.service" ];
      requires = [ "restya-board-init.service" ];

      script = ''
        /bin/sh ${runDir}/server/php/shell/instant_email_notification.sh 2> /dev/null || true
        /bin/sh ${runDir}/server/php/shell/periodic_email_notification.sh 2> /dev/null || true
        /bin/sh ${runDir}/server/php/shell/imap.sh 2> /dev/null || true
        /bin/sh ${runDir}/server/php/shell/webhook.sh 2> /dev/null || true
        /bin/sh ${runDir}/server/php/shell/card_due_notification.sh 2> /dev/null || true
      '';
    };

    users.users.restya-board = {
      isSystemUser = true;
      createHome = false;
      home = runDir;
      group  = "restya-board";
    };
    users.groups.restya-board = {};

    services.postgresql.enable = mkIf (cfg.database.host == null) true;

    services.postgresql.identMap = optionalString (cfg.database.host == null)
      ''
        restya-board-users restya-board restya_board
      '';

    services.postgresql.authentication = optionalString (cfg.database.host == null)
      ''
        local restya_board all ident map=restya-board-users
      '';

  };

}

