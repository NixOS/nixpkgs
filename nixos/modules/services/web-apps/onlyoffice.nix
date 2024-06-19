{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.services.onlyoffice;
in
{
  options.services.onlyoffice = {
    enable = mkEnableOption "OnlyOffice DocumentServer";

    enableExampleServer = mkEnableOption "OnlyOffice example server";

    hostname = mkOption {
      type = types.str;
      default = "localhost";
      description = "FQDN for the onlyoffice instance.";
    };

    jwtSecretFile = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        Path to a file that contains the secret to sign web requests using JSON Web Tokens.
        If left at the default value null signing is disabled.
      '';
    };

    package = mkPackageOption pkgs "onlyoffice-documentserver" { };

    port = mkOption {
      type = types.port;
      default = 8000;
      description = "Port the OnlyOffice DocumentServer should listens on.";
    };

    examplePort = mkOption {
      type = types.port;
      default = null;
      description = "Port the OnlyOffice Example server should listens on.";
    };

    postgresHost = mkOption {
      type = types.str;
      default = "/run/postgresql";
      description = "The Postgresql hostname or socket path OnlyOffice should connect to.";
    };

    postgresName = mkOption {
      type = types.str;
      default = "onlyoffice";
      description = "The name of database OnlyOffice should user.";
    };

    postgresPasswordFile = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        Path to a file that contains the password OnlyOffice should use to connect to Postgresql.
        Unused when using socket authentication.
      '';
    };

    postgresUser = mkOption {
      type = types.str;
      default = "onlyoffice";
      description = ''
        The username OnlyOffice should use to connect to Postgresql.
        Unused when using socket authentication.
      '';
    };

    rabbitmqUrl = mkOption {
      type = types.str;
      default = "amqp://guest:guest@localhost:5672";
      description = "The Rabbitmq in amqp URI style OnlyOffice should connect to.";
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      nginx = {
        enable = mkDefault true;
        # misses text/csv, font/ttf, application/x-font-ttf, application/rtf, application/wasm
        recommendedGzipSettings = mkDefault true;
        recommendedProxySettings = mkDefault true;

        upstreams = {
          # /etc/nginx/includes/http-common.conf
          onlyoffice-docservice = {
            servers = { "localhost:${toString cfg.port}" = { }; };
          };
          onlyoffice-example = lib.mkIf cfg.enableExampleServer {
            servers = { "localhost:${toString cfg.examplePort}" = { }; };
          };
        };

        virtualHosts.${cfg.hostname} = {
          locations = {
            # /etc/nginx/includes/ds-docservice.conf
            "~ ^(\/[\d]+\.[\d]+\.[\d]+[\.|-][\d]+)?\/(web-apps\/apps\/api\/documents\/api\.js)$".extraConfig = ''
              expires -1;
              alias ${cfg.package}/var/www/onlyoffice/documentserver/$2;
            '';
            "~ ^(\/[\d]+\.[\d]+\.[\d]+[\.|-][\d]+)?\/(web-apps)(\/.*\.json)$".extraConfig = ''
              expires 365d;
              error_log /dev/null crit;
              alias ${cfg.package}/var/www/onlyoffice/documentserver/$2$3;
            '';
            "~ ^(\/[\d]+\.[\d]+\.[\d]+[\.|-][\d]+)?\/(sdkjs-plugins)(\/.*\.json)$".extraConfig = ''
              expires 365d;
              error_log /dev/null crit;
              alias ${cfg.package}/var/www/onlyoffice/documentserver/$2$3;
            '';
            "~ ^(\/[\d]+\.[\d]+\.[\d]+[\.|-][\d]+)?\/(web-apps|sdkjs|sdkjs-plugins|fonts)(\/.*)$".extraConfig = ''
              expires 365d;
              alias ${cfg.package}/var/www/onlyoffice/documentserver/$2$3;
            '';
            "~* ^(\/cache\/files.*)(\/.*)".extraConfig = ''
              alias /var/lib/onlyoffice/documentserver/App_Data$1;
              add_header Content-Disposition "attachment; filename*=UTF-8''$arg_filename";

              set $secret_string verysecretstring;
              secure_link $arg_md5,$arg_expires;
              secure_link_md5 "$secure_link_expires$uri$secret_string";

              if ($secure_link = "") {
                return 403;
              }

              if ($secure_link = "0") {
                return 410;
              }
            '';
            "~* ^(\/[\d]+\.[\d]+\.[\d]+[\.|-][\d]+)?\/(internal)(\/.*)$".extraConfig = ''
              allow 127.0.0.1;
              deny all;
              proxy_pass http://onlyoffice-docservice/$2$3;
            '';
            "~* ^(\/[\d]+\.[\d]+\.[\d]+[\.|-][\d]+)?\/(info)(\/.*)$".extraConfig = ''
              allow 127.0.0.1;
              deny all;
              proxy_pass http://onlyoffice-docservice/$2$3;
            '';
            "/".extraConfig = ''
              proxy_pass http://onlyoffice-docservice;
            '';
            "~ ^(\/[\d]+\.[\d]+\.[\d]+[\.|-][\d]+)?(\/doc\/.*)".extraConfig = ''
              proxy_pass http://onlyoffice-docservice$2;
              proxy_http_version 1.1;
            '';
            "/${cfg.package.version}/".extraConfig = ''
              proxy_pass http://onlyoffice-docservice/;
            '';
            "~ ^(\/[\d]+\.[\d]+\.[\d]+[\.|-][\d]+)?\/(dictionaries)(\/.*)$".extraConfig = ''
              expires 365d;
              alias ${cfg.package}/var/www/onlyoffice/documentserver/$2$3;
            '';
            # /etc/nginx/includes/ds-example.conf
            "~ ^(\/welcome\/.*)$".extraConfig = ''
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
        ensureUsers = [{
          name = "onlyoffice";
          ensureDBOwnership = true;
        }];
      };
    };

    systemd.services = {
      onlyoffice-converter = {
        description = "onlyoffice converter";
        after = [ "network.target" "onlyoffice-docservice.service" "postgresql.service" ];
        requires = [ "network.target" "onlyoffice-docservice.service" "postgresql.service" ];
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
            PATH=$PATH:${lib.makeBinPath (with pkgs; [ jq moreutils config.services.postgresql.package ])}
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
          after = [ "network.target" "postgresql.service" ];
          requires = [ "postgresql.service" ];
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
