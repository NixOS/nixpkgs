{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.services.onlyoffice;
in
{
  options.services.onlyoffice = {
    enable = lib.mkEnableOption "OnlyOffice DocumentServer";

    enableExampleServer = lib.mkEnableOption "OnlyOffice example server";

    hostname = lib.mkOption {
      type = lib.types.str;
      default = "localhost";
      description = "FQDN for the OnlyOffice instance.";
    };

    jwtSecretFile = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        Path to a file that contains the secret to sign web requests using JSON Web Tokens.
        If left at the default value null signing is disabled.
      '';
    };

    package = lib.mkPackageOption pkgs "onlyoffice-documentserver" { };

    x2t = lib.mkPackageOption pkgs "x2t" { };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8000;
      description = "Port the OnlyOffice document server should listen on.";
    };

    examplePort = lib.mkOption {
      type = lib.types.port;
      default = null;
      description = "Port the OnlyOffice example server should listen on.";
    };

    postgresHost = lib.mkOption {
      type = lib.types.str;
      default = "/run/postgresql";
      description = "The Postgresql hostname or socket path OnlyOffice should connect to.";
    };

    postgresName = lib.mkOption {
      type = lib.types.str;
      default = "onlyoffice";
      description = "The name of database OnlyOffice should use.";
    };

    postgresPasswordFile = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        Path to a file that contains the password OnlyOffice should use to connect to Postgresql.
        Unused when using socket authentication.
      '';
    };

    postgresUser = lib.mkOption {
      type = lib.types.str;
      default = "onlyoffice";
      description = ''
        The username OnlyOffice should use to connect to Postgresql.
        Unused when using socket authentication.
      '';
    };

    rabbitmqUrl = lib.mkOption {
      type = lib.types.str;
      default = "amqp://guest:guest@localhost:5672";
      description = "The Rabbitmq in amqp URI style OnlyOffice should connect to.";
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      nginx = {
        enable = lib.mkDefault true;
        # misses text/csv, font/ttf, application/x-font-ttf, application/rtf, application/wasm
        recommendedGzipSettings = lib.mkDefault true;
        recommendedProxySettings = lib.mkDefault true;

        upstreams = {
          # /etc/nginx/includes/http-common.conf
          onlyoffice-docservice = {
            servers = {
              "localhost:${toString cfg.port}" = { };
            };
          };
          onlyoffice-example = lib.mkIf cfg.enableExampleServer {
            servers = {
              "localhost:${toString cfg.examplePort}" = { };
            };
          };
        };

        virtualHosts.${cfg.hostname} = {
          locations = {
            # resources that are generated and thus cannot be taken from the cfg.package yet:
            "~ ^(\\/[\\d]+\\.[\\d]+\\.[\\d]+[\\.|-][\\w]+)?\\/(sdkjs/common/AllFonts.js)$".extraConfig = ''
              proxy_pass http://onlyoffice-docservice/$2$3;
            '';
            "~ ^(\\/[\\d]+\\.[\\d]+\\.[\\d]+[\\.|-][\\w]+)?\\/(fonts/.*)$".extraConfig = ''
              proxy_pass http://onlyoffice-docservice/$2$3;
            '';
            # /etc/nginx/includes/ds-docservice.conf
            # disable caching for api.js
            "~ ^(\\/[\\d]+\\.[\\d]+\\.[\\d]+[\\.|-][\\w]+)?\\/(web-apps\\/apps\\/api\\/documents\\/api\\.js)$".extraConfig =
              ''
                expires -1;
                # gzip_static on;
                alias ${cfg.package}/var/www/onlyoffice/documentserver/$2;
              '';
            "~ ^(\\/[\\d]+\\.[\\d]+\\.[\\d]+[\\.|-][\\w]+)?\\/(document_editor_service_worker\\.js)$".extraConfig =
              ''
                expires 365d;
                alias ${cfg.package}/var/www/onlyoffice/documentserver/sdkjs/common/serviceworker/$2;
              '';
            # suppress logging the unsupported locale error in web-apps
            "~ ^(\\/[\\d]+\\.[\\d]+\\.[\\d]+[\\.|-][\\w]+)?\\/(web-apps)(\\/.*\\.json)$".extraConfig = ''
              expires 365d;
              error_log /dev/null crit;
              alias ${cfg.package}/var/www/onlyoffice/documentserver/$2$3;
            '';
            # suppress logging the unsupported locale error in plugins
            "~ ^(\\/[\\d]+\\.[\\d]+\\.[\\d]+[\\.|-][\\w]+)?\\/(sdkjs-plugins)(\\/.*\\.json)$".extraConfig = ''
              expires 365d;
              error_log /dev/null crit;
              alias ${cfg.package}/var/www/onlyoffice/documentserver/$2$3;
            '';
            "~ ^(\\/[\\d]+\\.[\\d]+\\.[\\d]+[\\.|-][\\w]+)?\\/(web-apps|sdkjs|sdkjs-plugins|fonts|dictionaries)(\\/.*)$".extraConfig =
              ''
                expires 365d;
                alias ${cfg.package}/var/www/onlyoffice/documentserver/$2$3;
              '';
            "~* ^(\\/cache\\/files.*)(\\/.*)".extraConfig = ''
              alias /var/lib/onlyoffice/documentserver/App_Data$1;
              more_set_headers "Content-Disposition: attachment; filename*=UTF-8''$arg_filename";

              set $secure_link_secret verysecretstring;
              secure_link $arg_md5,$arg_expires;
              secure_link_md5 "$secure_link_expires$uri$secure_link_secret";

              if ($secure_link = "") {
                return 403;
              }

              if ($secure_link = "0") {
                return 410;
              }
            '';
            # Allow "/internal" interface only from 127.0.0.1
            # Don't comment out the section below for the security reason!
            "~* ^(\\/[\\d]+\\.[\\d]+\\.[\\d]+[\\.|-][\\w]+)?\\/(internal)(\\/.*)$".extraConfig = ''
              allow 127.0.0.1;
              deny all;
              proxy_pass http://onlyoffice-docservice/$2$3;
            '';
            # Allow "/info" interface only from 127.0.0.1 by default
            # Comment out lines allow 127.0.0.1; and deny all;
            # of below section to turn on the info page
            "~* ^(\\/[\\d]+\\.[\\d]+\\.[\\d]+[\\.|-][\\w]+)?\\/(info)(\\/.*)$".extraConfig = ''
              allow 127.0.0.1;
              deny all;
              proxy_pass http://onlyoffice-docservice/$2$3;
            '';
            "/".extraConfig = ''
              proxy_pass http://onlyoffice-docservice;
            '';
            "~ ^(\\/[\\d]+\\.[\\d]+\\.[\\d]+[\\.|-][\\w]+)?(\\/(doc|downloadas)\\/.*)".extraConfig = ''
              proxy_pass http://onlyoffice-docservice$2$is_args$args;
              proxy_http_version 1.1;
            '';
            # end of /etc/nginx/includes/ds-docservice.conf
            "/${cfg.package.version}/".extraConfig = ''
              proxy_pass http://onlyoffice-docservice/;
            '';
            # /etc/nginx/includes/ds-example.conf
            "~ ^(\\/welcome\\/.*)$".extraConfig = lib.mkIf cfg.enableExampleServer ''
              expires 365d;
              alias ${cfg.package}/var/www/onlyoffice/documentserver-example$1;
              index docker.html;
            '';
            "/example/".extraConfig = lib.mkIf cfg.enableExampleServer ''
              proxy_pass http://onlyoffice-example/;
              proxy_set_header X-Forwarded-Path /example;
            '';
          };
          extraConfig = ''
            rewrite ^/$ /welcome/ redirect;
            rewrite ^\/OfficeWeb(\/apps\/.*)$ /${cfg.package.version}/web-apps$1 redirect;
            rewrite ^(\/web-apps\/apps\/(?!api\/).*)$ /${cfg.package.version}$1 redirect;

            # based on https://github.com/ONLYOFFICE/document-server-package/blob/master/common/documentserver/nginx/includes/http-common.conf.m4#L29-L34
            # without variable indirection and correct variable names
            proxy_set_header Host $host;
            proxy_set_header X-Forwarded-Host $host;
            proxy_set_header X-Forwarded-Proto $scheme;
            # required for CSP to take effect
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            # required for websocket
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection $connection_upgrade;
          '';
        };
      };

      rabbitmq.enable = lib.mkDefault true;

      postgresql = {
        enable = lib.mkDefault true;
        ensureDatabases = [ "onlyoffice" ];
        ensureUsers = [
          {
            name = "onlyoffice";
            ensureDBOwnership = true;
          }
        ];
      };
    };

    systemd.services = {
      onlyoffice-converter = {
        description = "onlyoffice converter";
        after = [
          "network.target"
          "onlyoffice-docservice.service"
          "postgresql.target"
        ];
        requires = [
          "network.target"
          "onlyoffice-docservice.service"
          "postgresql.target"
        ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          ExecStart = "${cfg.package.fhs}/bin/onlyoffice-wrapper FileConverter/converter /run/onlyoffice/config";
          Group = "onlyoffice";
          Restart = "always";
          RuntimeDirectory = "onlyoffice";
          StateDirectory = "onlyoffice";
          Type = "simple";
          User = "onlyoffice";
        };
      };

      onlyoffice-docservice =
        let
          onlyoffice-prestart = pkgs.writeShellScript "onlyoffice-prestart" ''
            PATH=$PATH:${
              lib.makeBinPath (
                with pkgs;
                [
                  jq
                  moreutils
                  config.services.postgresql.package
                ]
              )
            }
            umask 077
            mkdir -p /run/onlyoffice/config/ /var/lib/onlyoffice/documentserver/sdkjs/{slide/themes,common}/ /var/lib/onlyoffice/documentserver/{fonts,server/FileConverter/bin}/
            cp -r ${cfg.package}/etc/onlyoffice/documentserver/* /run/onlyoffice/config/
            chmod u+w /run/onlyoffice/config/default.json

            # Allow members of the onlyoffice group to serve files under /var/lib/onlyoffice/documentserver/App_Data
            chmod g+x /var/lib/onlyoffice/documentserver

            cp /run/onlyoffice/config/default.json{,.orig}

            # for a mapping of environment variables from the docker container to json options see
            # https://github.com/ONLYOFFICE/Docker-DocumentServer/blob/master/run-document-server.sh
            jq '
              .services.CoAuthoring.server.port = ${toString cfg.port} |
              .services.CoAuthoring.sql.dbHost = "${cfg.postgresHost}" |
              .services.CoAuthoring.sql.dbName = "${cfg.postgresName}" |
            ${lib.optionalString (cfg.postgresPasswordFile != null) ''
              .services.CoAuthoring.sql.dbPass = "'"$(cat ${cfg.postgresPasswordFile})"'" |
            ''}
              .services.CoAuthoring.sql.dbUser = "${cfg.postgresUser}" |
            ${lib.optionalString (cfg.jwtSecretFile != null) ''
              .services.CoAuthoring.token.enable.browser = true |
              .services.CoAuthoring.token.enable.request.inbox = true |
              .services.CoAuthoring.token.enable.request.outbox = true |
              .services.CoAuthoring.secret.inbox.string = "'"$(cat ${cfg.jwtSecretFile})"'" |
              .services.CoAuthoring.secret.outbox.string = "'"$(cat ${cfg.jwtSecretFile})"'" |
              .services.CoAuthoring.secret.session.string = "'"$(cat ${cfg.jwtSecretFile})"'" |
            ''}
              .rabbitmq.url = "${cfg.rabbitmqUrl}"
              ' /run/onlyoffice/config/default.json | sponge /run/onlyoffice/config/default.json

            chmod u+w /run/onlyoffice/config/production-linux.json
            jq '.FileConverter.converter.x2tPath = "${cfg.x2t}/bin/x2t"' \
              /run/onlyoffice/config/production-linux.json | sponge /run/onlyoffice/config/production-linux.json

            if psql -d onlyoffice -c "SELECT 'task_result'::regclass;" >/dev/null; then
              psql -f ${cfg.package}/var/www/onlyoffice/documentserver/server/schema/postgresql/removetbl.sql
              psql -f ${cfg.package}/var/www/onlyoffice/documentserver/server/schema/postgresql/createdb.sql
            else
              psql -f ${cfg.package}/var/www/onlyoffice/documentserver/server/schema/postgresql/createdb.sql
            fi
          '';
        in
        {
          description = "onlyoffice documentserver";
          after = [
            "network.target"
            "postgresql.target"
          ];
          requires = [ "postgresql.target" ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            ExecStart = "${cfg.package.fhs}/bin/onlyoffice-wrapper DocService/docservice /run/onlyoffice/config";
            ExecStartPre = [ onlyoffice-prestart ];
            Group = "onlyoffice";
            Restart = "always";
            RuntimeDirectory = "onlyoffice";
            StateDirectory = "onlyoffice";
            Type = "simple";
            User = "onlyoffice";
          };
        };
    };

    users.users = {
      onlyoffice = {
        description = "OnlyOffice Service";
        group = "onlyoffice";
        isSystemUser = true;
      };

      nginx.extraGroups = [ "onlyoffice" ];
    };

    users.groups.onlyoffice = { };
  };
}
