{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.services.piped;
in {
  options.services.piped = {
    frontend = {
      enable = lib.mkEnableOption "Piped Frontend";

      package = lib.mkPackageOption pkgs "piped" {};

      domain = lib.mkOption {
        type = lib.types.str;
        description = ''
          The domain Piped Frontend is reachable on.
        '';
      };

      externalUrl = lib.mkOption {
        type = lib.types.str;
        example = "https://piped.example.com";
        description = ''
          The external URL of Piped Frontend.
        '';
      };
    };

    backend = {
      enable = lib.mkEnableOption "Piped Backend";

      package = lib.mkPackageOption pkgs "piped-backend" {};

      database = {
        createLocally = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = ''
            Whether to create a local database with PostgreSQL.
          '';
        };

        host = lib.mkOption {
          type = lib.types.str;
          default = "127.0.0.1";
          description = ''
            The database host Piped should use.
          '';
        };

        port = lib.mkOption {
          type = lib.types.port;
          default = config.services.postgresql.settings.port;
          defaultText = lib.literalExpression "config.services.postgresql.settings.port";
          description = ''
            The database port Piped should use.

            Defaults to the the default postgresql port.
          '';
        };

        database = lib.mkOption {
          type = lib.types.str;
          default = "piped";
          description = ''
            The database Piped should use.
          '';
        };

        username = lib.mkOption {
          type = lib.types.str;
          default = "piped";
          description = ''
            The database username Piped should use.
          '';
        };

        passwordFile = lib.mkOption {
          type = lib.types.str;
          example = "/run/keys/db_password";
          description = ''
            Path to file containing the database password.
          '';
        };
      };

      port = lib.mkOption {
        type = lib.types.port;
        example = 8000;
        description = ''
          The port Piped Backend should listen on.

          To allow access from outside,
          you can use either {option}`services.piped.backend.nginx`
          or add `config.services.piped.backend.port` to {option}`networking.firewall.allowedTCPPorts`.
        '';
      };

      settings = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        description = ''
          The settings Piped Backend should use.

          See [config.properties](https://github.com/TeamPiped/Piped-Backend/blob/master/config.properties) for a list of all possible options.
        '';
      };

      externalUrl = lib.mkOption {
        type = lib.types.str;
        example = "https://pipedapi.example.com";
        description = ''
          The external URL of Piped Backend.
        '';
      };

      nginx = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            Whether to configure nginx as a reverse proxy for Piped Backend.
          '';
        };

        domain = lib.mkOption {
          type = lib.types.str;
          description = ''
            The domain Piped Backend is reachable on.
          '';
        };

        pubsubExtraConfig = lib.mkOption {
          type = lib.types.str;
          default = "";
          example = "allow all;";
          description = ''
            Nginx extra config for the `/webhooks/pubsub` route.
          '';
        };
      };
    };

    proxy = {
      enable = lib.mkEnableOption "Piped Proxy";

      package = lib.mkPackageOption pkgs "piped-proxy" {};

      address = lib.mkOption {
        type = lib.types.str;
        default =
          if cfg.proxy.nginx.enable
          then "127.0.0.1"
          else "0.0.0.0";
        defaultText = lib.literalExpression ''if config.services.piped.proxy.nginx.enable then "127.0.0.1" else "0.0.0.0"'';
        description = ''
          The IP address Piped Proxy should bind to.
        '';
      };

      port = lib.mkOption {
        type = lib.types.port;
        example = 8001;
        description = ''
          The port Piped Proxy should listen on.

          To allow access from outside,
          you can use either {option}`services.piped.proxy.nginx`
          or add `config.services.piped.proxy.port` to {option}`networking.firewall.allowedTCPPorts`.
        '';
      };

      externalUrl = lib.mkOption {
        type = lib.types.str;
        example = "https://pipedproxy.example.com";
        description = ''
          The external URL of Piped Proxy.
        '';
      };

      nginx = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            Whether to configure nginx as a reverse proxy for Piped Proxy.
          '';
        };

        domain = lib.mkOption {
          type = lib.types.str;
          description = ''
            The domain Piped Proxy is reachable on.
          '';
        };
      };
    };
  };

  config = let
    frontendConfig = lib.mkIf cfg.frontend.enable {
      services.piped.frontend.externalUrl = lib.mkDefault "https://${cfg.frontend.domain}";

      services.nginx = {
        enable = true;
        virtualHosts.${cfg.frontend.domain} = {
          locations."/" = {
            root = pkgs.runCommand "piped-frontend-patched" {} ''
              cp -r ${cfg.frontend.package} $out
              chmod -R +w $out
              ${pkgs.gnused}/bin/sed -i 's|https://pipedapi.kavin.rocks|${cfg.backend.externalUrl}|g' $out/{opensearch.xml,assets/*}
            '';
            tryFiles = "$uri /index.html";
          };
        };
      };
    };

    backendConfig = lib.mkIf cfg.backend.enable {
      services.piped.backend = {
        externalUrl = lib.mkIf cfg.backend.nginx.enable (lib.mkDefault "https://${cfg.backend.nginx.domain}");

        settings = {
          PORT = toString cfg.backend.port;
          PROXY_PART = cfg.proxy.externalUrl;
          API_URL = cfg.backend.externalUrl;
          FRONTEND_URL = cfg.frontend.externalUrl;
        };
      };

      services.postgresql = lib.mkIf cfg.backend.database.createLocally {
        enable = true;
        enableTCPIP = true;
      };

      systemd.services.pipedPostgreSQLInit = lib.mkIf cfg.backend.database.createLocally {
        after = ["postgresql.service"];
        before = ["piped-backend.service"];
        bindsTo = ["postgresql.service"];
        path = [config.services.postgresql.package];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          User = "postgres";
          Group = "postgres";
          LoadCredential = ["databasePassword:${cfg.backend.database.passwordFile}"];
        };
        script = ''
          set -o errexit -o pipefail -o nounset -o errtrace
          shopt -s inherit_errexit

          create_role="$(mktemp)"
          trap 'rm -f "$create_role"' EXIT

          # Read the password from the credentials directory and
          # escape any single quotes by adding additional single
          # quotes after them, following the rules laid out here:
          # https://www.postgresql.org/docs/current/sql-syntax-lexical.html#SQL-SYNTAX-CONSTANTS
          db_password="$(<"$CREDENTIALS_DIRECTORY/databasePassword")"
          db_password="''${db_password//\'/\'\'}"

          echo "CREATE ROLE \"${cfg.backend.database.username}\" WITH LOGIN PASSWORD '$db_password' CREATEDB" > "$create_role"
          psql -tAc "SELECT 1 FROM pg_roles WHERE rolname='${cfg.backend.database.username}'" | grep -q 1 || psql -tA --file="$create_role"
          psql -tAc "SELECT 1 FROM pg_database WHERE datname = '${cfg.backend.database.database}'" | grep -q 1 || psql -tAc 'CREATE DATABASE "${cfg.backend.database.database}" OWNER "${cfg.backend.database.username}"'
        '';
      };

      systemd.services.piped-backend = let
        databaseServices = lib.optionals cfg.backend.database.createLocally [
          "pipedPostgreSQLInit.service"
          "postgresql.service"
        ];
      in {
        after = databaseServices;
        bindsTo = databaseServices;
        wantedBy = ["multi-user.target"];
        serviceConfig = {
          User = "piped-backend";
          Group = "piped-backend";
          DynamicUser = true;
          RuntimeDirectory = "piped-backend";
          WorkingDirectory = "/run/piped-backend";
          LoadCredential = ["databasePassword:${cfg.backend.database.passwordFile}"];
        };
        environment = cfg.backend.settings;
        preStart = ''
          cat << EOF > config.properties
          hibernate.connection.url: jdbc:postgresql://${cfg.backend.database.host}:${toString cfg.backend.database.port}/${cfg.backend.database.database}
          hibernate.connection.driver_class: org.postgresql.Driver
          hibernate.dialect: org.hibernate.dialect.PostgreSQLDialect
          hibernate.connection.username: ${cfg.backend.database.username}
          hibernate.connection.password: $(cat $CREDENTIALS_DIRECTORY/databasePassword)
          EOF
        '';
        script = ''
          ${cfg.backend.package}/bin/piped-backend
        '';
      };

      services.nginx = lib.mkIf cfg.backend.nginx.enable {
        enable = true;
        appendHttpConfig = ''
          proxy_cache_path /tmp/pipedapi_cache levels=1:2 keys_zone=pipedapi:4m max_size=2g inactive=60m use_temp_path=off;
        '';
        virtualHosts.${cfg.backend.nginx.domain} = {
          locations."/" = {
            proxyPass = "http://127.0.0.1:${toString cfg.backend.port}";
            extraConfig = ''
              proxy_cache pipedapi;
            '';
          };
          locations."/webhooks/pubsub" = {
            proxyPass = "http://127.0.0.1:${toString cfg.backend.port}";
            extraConfig = ''
              proxy_cache pipedapi;
              ${cfg.backend.nginx.pubsubExtraConfig}
            '';
          };
        };
      };
    };

    proxyConfig = lib.mkIf cfg.proxy.enable {
      services.piped.proxy.externalUrl = lib.mkIf cfg.proxy.nginx.enable (lib.mkDefault "https://${cfg.proxy.nginx.domain}");

      systemd.services.piped-proxy = {
        wantedBy = ["multi-user.target"];
        serviceConfig = {
          User = "piped-proxy";
          Group = "piped-proxy";
          DynamicUser = true;
        };
        environment = {
          BIND = "${cfg.proxy.address}:${toString cfg.proxy.port}";
        };
        script = ''
          ${cfg.proxy.package}/bin/piped-proxy
        '';
      };

      services.nginx = lib.mkIf cfg.proxy.nginx.enable {
        enable = true;
        virtualHosts.${cfg.proxy.nginx.domain} = let
          ytproxy = ''
            proxy_buffering on;
            proxy_buffers 1024 16k;
            proxy_set_header X-Forwarded-For "";
            proxy_set_header CF-Connecting-IP "";
            proxy_hide_header "alt-svc";
            sendfile on;
            sendfile_max_chunk 512k;
            tcp_nopush on;
            aio threads=default;
            aio_write on;
            directio 16m;
            proxy_hide_header Cache-Control;
            proxy_hide_header etag;
            proxy_http_version 1.1;
            proxy_set_header Connection keep-alive;
            proxy_max_temp_file_size 32m;
            access_log off;
          '';
        in {
          locations."/" = {
            proxyPass = "http://${cfg.proxy.address}:${toString cfg.proxy.port}";
            extraConfig = ''
              ${ytproxy}
              add_header Cache-Control "public, max-age=604800";
            '';
          };
          locations."~ (/videoplayback|/api/v4/|/api/manifest/)" = {
            proxyPass = "http://${cfg.proxy.address}:${toString cfg.proxy.port}";
            extraConfig = ''
              ${ytproxy}
              add_header Cache-Control private always;
            '';
          };
        };
      };
    };
  in
    lib.mkMerge [frontendConfig backendConfig proxyConfig];

  meta.maintainers = with lib.maintainers; [defelo];
}
