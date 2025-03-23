{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkOption
    mkIf
    mkPackageOption
    types
    ;
  cfg = config.services.archtika;
in
{
  options.services.archtika = {
    enable = mkEnableOption "Whether to enable the archtika service";

    package = mkPackageOption pkgs "archtika" { };

    user = mkOption {
      type = types.str;
      default = "archtika";
      description = "User account under which archtika runs.";
    };

    group = mkOption {
      type = types.str;
      default = "archtika";
      description = "Group under which archtika runs.";
    };

    databaseName = mkOption {
      type = types.str;
      default = "archtika";
      description = "Name of the PostgreSQL database for archtika.";
    };

    apiPort = mkOption {
      type = types.port;
      default = 5000;
      description = "Port on which the API runs.";
    };

    apiAdminPort = mkOption {
      type = types.port;
      default = 7500;
      description = "Port on which the API admin server runs.";
    };

    webAppPort = mkOption {
      type = types.port;
      default = 10000;
      description = "Port on which the web application runs.";
    };

    domain = mkOption {
      type = types.str;
      description = "Domain to use for the application.";
    };

    settings = mkOption {
      description = "Settings for the running archtika application.";
      type = types.submodule {
        options = {
          disableRegistration = mkOption {
            type = types.bool;
            default = false;
            description = "By default any user can create an account. That behavior can be disabled with this option.";
          };
          maxUserWebsites = mkOption {
            type = types.ints.positive;
            default = 2;
            description = "Maximum number of websites allowed per user by default.";
          };
          maxWebsiteStorageSize = mkOption {
            type = types.ints.positive;
            default = 50;
            description = "Maximum amount of disk space in MB allowed per user website by default.";
          };
        };
      };
    };
  };

  config = mkIf cfg.enable (
    let
      baseHardenedSystemdOptions = {
        CapabilityBoundingSet = "";
        LockPersonality = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectSystem = "strict";
        RemoveIPC = true;
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "~@resources"
        ];
        ReadWritePaths = [ "/var/www/archtika-websites" ];
      };
    in
    {
      users.users.${cfg.user} = {
        isSystemUser = true;
        group = cfg.group;
      };

      users.groups.${cfg.group} = {
        members = [
          "nginx"
          "postgres"
        ];
      };

      systemd.tmpfiles.settings."10-archtika" = {
        "/var/www" = {
          d = {
            mode = "0755";
            user = "root";
            group = "root";
          };
        };
        "/var/www/archtika-websites" = {
          d = {
            mode = "0770";
            user = cfg.user;
            group = cfg.group;
          };
        };
      };

      systemd.services.archtika-api = {
        description = "archtika API service";
        wantedBy = [ "multi-user.target" ];
        after = [
          "network.target"
          "postgresql.service"
        ];

        path = [ config.services.postgresql.package ];

        serviceConfig = baseHardenedSystemdOptions // {
          User = cfg.user;
          Group = cfg.group;
          Restart = "always";
          WorkingDirectory = "${cfg.package}/rest-api";
          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
            "AF_UNIX"
          ];
        };

        script =
          let
            dbUrl = user: "postgres://${user}@/${cfg.databaseName}?host=/var/run/postgresql";
          in
          ''
            JWT_SECRET=$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c64)

            psql ${dbUrl "postgres"} \
              -c "ALTER DATABASE ${cfg.databaseName} SET \"app.jwt_secret\" TO '$JWT_SECRET'" \
              -c "ALTER DATABASE ${cfg.databaseName} SET \"app.website_max_storage_size\" TO ${toString cfg.settings.maxWebsiteStorageSize}" \
              -c "ALTER DATABASE ${cfg.databaseName} SET \"app.website_max_number_user\" TO ${toString cfg.settings.maxUserWebsites}"

            ${lib.getExe pkgs.dbmate} --url "${dbUrl "postgres"}&sslmode=disable" --migrations-dir ${cfg.package}/rest-api/db/migrations up

            PGRST_SERVER_CORS_ALLOWED_ORIGINS="https://${cfg.domain}" \
            PGRST_ADMIN_SERVER_PORT=${toString cfg.apiAdminPort} \
            PGRST_SERVER_PORT=${toString cfg.apiPort} \
            PGRST_DB_SCHEMAS="api" \
            PGRST_DB_ANON_ROLE="anon" \
            PGRST_OPENAPI_MODE="ignore-privileges" \
            PGRST_DB_URI=${dbUrl "authenticator"} \
            PGRST_JWT_SECRET="$JWT_SECRET" \
            ${lib.getExe pkgs.postgrest}
          '';
      };

      systemd.services.archtika-web = {
        description = "archtika Web App service";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];

        serviceConfig = baseHardenedSystemdOptions // {
          User = cfg.user;
          Group = cfg.group;
          Restart = "always";
          WorkingDirectory = "${cfg.package}/web-app";
          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
          ];
        };

        environment = {
          REGISTRATION_IS_DISABLED = toString cfg.settings.disableRegistration;
          BODY_SIZE_LIMIT = "10M";
          ORIGIN = "https://${cfg.domain}";
          PORT = toString cfg.webAppPort;
        };

        script = "${lib.getExe pkgs.nodejs} ${cfg.package}/web-app";
      };

      services.postgresql = {
        enable = true;
        ensureDatabases = [ cfg.databaseName ];
        extensions = ps: with ps; [ pgjwt ];
        authentication = lib.mkOverride 11 ''
          local postgres postgres trust
          local ${cfg.databaseName} all trust
        '';
      };

      systemd.services.postgresql = {
        path = with pkgs; [
          gnutar
          gzip
        ];
        serviceConfig = {
          ReadWritePaths = [ "/var/www/archtika-websites" ];
          SystemCallFilter = [ "@system-service" ];
        };
      };

      services.nginx = {
        enable = true;
        recommendedProxySettings = true;
        recommendedTlsSettings = true;
        recommendedZstdSettings = true;
        recommendedOptimisation = true;

        appendHttpConfig = ''
          map $http_cookie $archtika_auth_header {
            default "";
            "~*session_token=([^;]+)" "Bearer $1";
          }
        '';

        virtualHosts = {
          "${cfg.domain}" = {
            useACMEHost = cfg.domain;
            forceSSL = true;
            locations = {
              "/" = {
                proxyPass = "http://127.0.0.1:${toString cfg.webAppPort}";
              };
              "/previews/" = {
                alias = "/var/www/archtika-websites/previews/";
                index = "index.html";
                tryFiles = "$uri $uri/ $uri.html =404";
              };
              "/api/rpc/export_articles_zip" = {
                proxyPass = "http://127.0.0.1:${toString cfg.apiPort}/rpc/export_articles_zip";
                extraConfig = ''
                  default_type application/json;
                  proxy_set_header Authorization $archtika_auth_header;
                '';
              };
              "/api/" = {
                proxyPass = "http://127.0.0.1:${toString cfg.apiPort}/";
                extraConfig = ''
                  default_type application/json;
                '';
              };
              "/api/rpc/register" = mkIf cfg.settings.disableRegistration {
                extraConfig = ''
                  deny all;
                '';
              };
            };
          };
          "~^(?<subdomain>.+)\\.${cfg.domain}$" = {
            useACMEHost = cfg.domain;
            forceSSL = true;
            locations = {
              "/" = {
                root = "/var/www/archtika-websites/$subdomain";
                index = "index.html";
                tryFiles = "$uri $uri/ $uri.html =404";
              };
            };
          };
        };
      };
    }
  );

  meta.maintainers = [ lib.maintainers.thiloho ];
}
