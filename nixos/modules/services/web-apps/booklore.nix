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
    pkgs.writeScript "booklore-env" ''
      #!${lib.getExe pkgs.bash}
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
          type = types.nullOr types.str;
          default = null;
          description = "Hostname or address of the mariadb server.";
        };
        port = mkOption {
          type = types.nullOr types.port;
          default = null;
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
          Refer to the [documentation](https://github.com/adityachandelgit/BookLore?tab=readme-ov-file#-remote-authentication-trusted-header-sso-forward-auth) for options.
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
          Refer to the [documentation](https://github.com/adityachandelgit/BookLore?tab=readme-ov-file#-remote-authentication-trusted-header-sso-forward-auth) for options.
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
      DATABASE_HOST = if cfg.database.host != null then cfg.database.host else "127.0.0.1";
      DATABASE_PORT = if cfg.database.port != null then toString cfg.database.port else "3306";
      DATABASE_USERNAME = cfg.database.user;
      SERVER_PORT = toString cfg.api.port;
    };

    services.nginx = lib.mkIf cfg.nginx.enable {
      enable = true;
      virtualHosts.${cfg.nginx.virtualHost} = {
        listen = [
          {
            addr = cfg.host;
            port = cfg.port;
          }
        ];

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
          };

          "/ws" = {
            proxyPass = "http://localhost:${toString cfg.api.port}/ws";
            recommendedProxySettings = lib.mkDefault true;
            extraConfig = ''
              proxy_http_version 1.1;  # Ensure HTTP 1.1 is used for WebSocket connection
              proxy_set_header Upgrade $http_upgrade;  # Pass the upgrade header
              proxy_set_header Connection 'upgrade';  # Pass the connection header
            '';
          };
        };
      };
    };

    services.mysql = lib.mkIf cfg.database.createLocally {
      enable = true;

      settings = {
        bind_address = lib.mkIf (cfg.database.host != null) cfg.database.host;
        port = lib.mkIf (cfg.database.port != null) cfg.database.port;
      };

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
