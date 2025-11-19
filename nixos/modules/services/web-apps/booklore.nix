{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.booklore;

  secret = types.nullOr (
    types.str
    // {
      # We don't want users to be able to pass a path literal here but
      # it should look like a path.
      check = it: lib.isString it && lib.types.path.check it;
    }
  );

  startupScript =
    cmd:
    pkgs.writeShellScript "booklore-env" ''
      set -eou pipefail
      ${lib.concatMapAttrsStringSep "\n" (key: path: "export ${key}=$(cat \"${path}\")") cfg.secretFiles}
      ${cmd}
    '';

  inherit (lib)
    mkEnableOption
    mkPackageOption
    mkOption
    types
    ;
in
{
  options = {
    services.booklore = {
      enable = mkEnableOption "BookLore, self-hosted service to manage and explore books.";

      database = {
        createLocally =
          mkEnableOption "the mariadb database for use with BookLore. See {option}`services.mysql`"
          // {
            default = true;
          };

        name = mkOption {
          type = types.str;
          default = "booklore";
          description = "The name of the BookLore database.";
        };
        host = mkOption {
          type = types.str;
          default = "127.0.0.1";
          description = "Hostname or address of the mariadb server.";
        };
        port = mkOption {
          type = types.port;
          default = 3306;
          description = "Port of the mariadb server.";
        };
        user = mkOption {
          type = types.str;
          default = "booklore";
          description = "The database user for BookLore.";
        };
      };

      api = {
        port = mkOption {
          description = "The port that the BookLore api will listen on.";
          type = types.port;
          defaultText = "cfg.port + 1";
          default = cfg.port + 1;
        };
      };

      nginx = {
        enable =
          mkEnableOption "the hosting of the user interface of BookLore. Disabling this will result in only the API being available"
          // {
            default = true;
          };

        virtualHost = mkOption {
          description = "The virtual host for the BookLore user interface and api.";
          default = "localhost";
          type = types.str;
        };

        forceSSL = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Whether or not to force the use of SSL.";
        };

        useACMEHost = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          example = "example.com";
          description = "A host of an existing Let's Encrypt certificate to use.";
        };
      };

      package = mkPackageOption pkgs "booklore" { };

      dataDir = mkOption {
        description = "Storage path of the BookLore data. Needs to exists already if not using the default path.";
        default = "/var/lib/booklore/data";
        type = types.str;
      };

      bookdropDir = mkOption {
        description = "Path to folder that BookLore uses to automatically add books to the library. Needs to exists already if not using the default path.";
        default = "/var/lib/booklore/bookdrop";
        type = types.str;
      };

      settings.maxBodySize = mkOption {
        description = "Maximum upload size for the web interface";
        default = "1000M";
        type = types.str;
      };

      environment = mkOption {
        description = "Environment variables to set for BookLore.";
        default = { };
        type = types.attrsOf types.str;
      };

      environmentFile = mkOption {
        type = secret;
        example = "/run/secrets/booklore";
        default = null;
        description = ''
          Path of a file with extra environment variables to be loaded from disk.
          This file is not added to the nix store, so it can be used to pass secrets to BookLore.
          Refer to the [documentation](https://booklore-app.github.io/booklore-docs/docs/installation#create-environment-file) for options.
          To set a database password use DATABASE_PASSWORD
          ```
          DATABASE_PASSWORD=<pass>
          ```
        '';
      };

      secretFiles = mkOption {
        type = types.attrsOf secret;
        example = {
          DATABASE_PASSWORD = "/run/secrets/booklore_database_passwd";
        };
        default = { };
        description = ''
          Attribute set containing paths to files to add to the environment of BookLore.
          The files are not added to the nix store, so they can be used to pass secrets to BookLore.
          Refer to the [documentation](https://booklore-app.github.io/booklore-docs/docs/installation#create-environment-file) for options.
          To set a database password use DATABASE_PASSWORD:
          ```
          { DATABASE_PASSWORD = "/path/to/secret/containing/password"; }
          ```
        '';
      };

      host = mkOption {
        description = "The host BookLore binds to.";
        default = "localhost";
        example = "0.0.0.0";
        type = types.str;
      };

      port = mkOption {
        description = "The TCP port BookLore will listen on.";
        default = 8080;
        type = types.port;
      };

      user = mkOption {
        description = "User account under which BookLore runs.";
        default = "booklore";
        type = types.str;
      };

      group = mkOption {
        description = "Group under which BookLore runs.";
        default = "booklore";
        type = types.str;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.booklore = {
      description = "BookLore is a web app for hosting, managing, and exploring books, with support for PDFs, eBooks, reading progress, metadata, and stats.";

      after = [ "network.target" ] ++ lib.optionals cfg.database.createLocally [ "mysql.service" ];
      wantedBy = [ "multi-user.target" ] ++ lib.optionals cfg.database.createLocally [ "mysql.service" ];

      environment = cfg.environment;

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        StateDirectory = "booklore";
        ExecStartPre = "+${startupScript ''
          echo "ALTER USER '${cfg.database.user}'@'localhost' IDENTIFIED BY '$DATABASE_PASSWORD';" | ${pkgs.mariadb}/bin/mariadb
        ''}";
        ExecStart = startupScript (lib.getExe cfg.package);

        Restart = "on-failure";
        EnvironmentFile = cfg.environmentFile;

        # Hardening
        CapabilityBoundingSet = "";
        NoNewPrivileges = true;
        PrivateUsers = true;
        PrivateTmp = true;
        PrivateDevices = true;
        PrivateMounts = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
      };
    };

    services.booklore.environment = {
      BOOKLORE_DATA_DIR = cfg.dataDir;
      BOOKLORE_BOOKDROP_DIR = cfg.bookdropDir;
      DATABASE_HOST = cfg.database.host;
      DATABASE_PORT = toString cfg.database.port;
      DATABASE_USERNAME = cfg.database.user;
      SERVER_PORT = toString cfg.api.port;
    };

    services.nginx = lib.mkIf cfg.nginx.enable {
      enable = true;

      appendHttpConfig = ''
        large_client_header_buffers 8 32k;
      '';

      virtualHosts.${cfg.nginx.virtualHost} = {
        listen = [
          {
            addr = cfg.host;
            port = cfg.port;
          }
        ];

        forceSSL = cfg.nginx.forceSSL;
        enableACME = lib.mkDefault (cfg.nginx.forceSSL && cfg.nginx.useACMEHost == null);
        useACMEHost = cfg.nginx.useACMEHost;

        root = "${cfg.package}/share/booklore-ui";

        extraConfig = ''
          client_max_body_size ${cfg.settings.maxBodySize};
        '';

        locations = {
          "/" = {
            tryFiles = "$uri $uri/ /index.html =404";
            extraConfig = ''
              location ~* \.mjs$ {
                types {
                    text/javascript mjs;
                }
              }
            '';
          };

          "/api/" = {
            proxyPass = "http://localhost:${toString cfg.api.port}";
            recommendedProxySettings = lib.mkDefault true;
            extraConfig = ''
              proxy_set_header X-Forwarded-Port $server_port;
              proxy_buffer_size 128k;
              proxy_buffers 4 256k;
              proxy_busy_buffers_size 256k;
            '';
          };

          "/ws" = {
            proxyPass = "http://localhost:${toString cfg.api.port}/ws";
            recommendedProxySettings = lib.mkDefault true;
            proxyWebsockets = true;
          };
        };
      };
    };

    services.mysql = lib.mkIf cfg.database.createLocally {
      enable = true;

      package = lib.mkDefault pkgs.mariadb;
      ensureDatabases = [ cfg.database.name ];
      ensureUsers = [
        {
          name = cfg.database.user;
          ensurePermissions = {
            "${cfg.database.name}.*" = "ALL PRIVILEGES";
          };
        }
      ];
    };

    users.users = lib.mkIf (cfg.user == "booklore") {
      booklore = {
        isSystemUser = true;
        group = cfg.group;
      };
    };

    users.groups = lib.mkIf (cfg.group == "booklore") {
      booklore = { };
    };
  };

  meta.maintainers = with lib.maintainers; [ jvanbruegge ];
}
