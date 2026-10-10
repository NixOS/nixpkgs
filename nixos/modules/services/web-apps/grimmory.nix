{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    literalExpression
    mkIf
    mkDefault
    mkOption
    mkEnableOption
    mkMerge
    mkPackageOption
    optional
    types
    ;
  cfg = config.services.grimmory;
in
{
  options.services.grimmory = {
    enable = mkEnableOption "Whether to enable Grimmory Server.";

    package = mkPackageOption pkgs "grimmory" { };

    host = mkOption {
      description = "Listen address which Grimmory should listen on. (`SERVER_ADDRESS`)";
      default = "localhost";
      type = types.str;
    };

    port = mkOption {
      description = "Port on which Grimmory should listen on. (`BOOKLORE_PORT`)";
      default = 6060;
      type = types.port;
    };

    user = mkOption {
      description = "User account under which Grimmory runs.";
      default = "grimmory";
      type = types.str;
      example = "media";
    };

    group = mkOption {
      description = "Group under which Grimmory runs.";
      default = "grimmory";
      type = types.str;
      example = "media";
    };

    stateDir = mkOption {
      description = "State and configuration directory Grimmory will use. (`APP_PATH_CONFIG`)";
      default = "/var/lib/grimmory";
      type = types.str;
      example = "/grimmory";
    };

    booksDir = mkOption {
      description = "Path to root directory of book library.";
      default = "${cfg.stateDir}/books";
      defaultText = "\${cfg.stateDir}/books";
      type = types.str;
      example = "/books";
    };

    bookdropDir = mkOption {
      description = "Path to directory where Grimmory watches for books to import. (`APP_BOOKDROP_FOLDER`)";
      default = "${cfg.stateDir}/bookdrop";
      defaultText = "\${cfg.stateDir}/bookdrop";
      type = types.str;
      example = "/bookdrop";
    };

    database = {
      createLocally = mkOption {
        description = "Create a local MariaDB database and user for Grimmory via `services.mysql`.";
        default = true;
        type = types.bool;
      };

      name = mkOption {
        description = "MySQL database name that holds Grimmory's data. (`DATABASE_NAME`)";
        default = "grimmory";
        type = types.str;
        example = "booklore";
      };

      host = mkOption {
        description = "MySQL Database host (`DATABASE_HOST`)";
        default = "localhost";
        type = types.str;
      };

      port = mkOption {
        description = "MySQL Database port (`DATABASE_PORT`)";
        default = 3306;
        type = types.port;
      };

      user = mkOption {
        description = ''
          Name of the user with all permissions to the Grimmory MySQL database. (`DATABASE_USERNAME`)
        '';
        default = "grimmory";
        type = types.str;
        example = "booklore";
      };

      passwordFile = mkOption {
        description = ''
          A file containing the password for the database named {option}`database.name`.

          > A password file is currently required, but should be avoidable in a future release
        '';
        default = null;
        type = types.nullOr types.path;
        example = "/run/keys/grimmory-db-password";
      };
    };

    environment = mkOption {
      description = ''
        Environment variables passed passed into the backend server.

        Some variables are defined here: <https://grimmory.org/docs/installation>
      '';
      default = { };
      type = types.attrsOf types.str;
      example = {
        FORCE_DISABLE_OIDC = "true";
      };
    };

    environmentFile = mkOption {
      description = "Optional path to an `EnvironmentFile` to configure or add secrets to Grimmory service.";
      default = null;
      type = types.nullOr types.path;
    };

    extraArgs = mkOption {
      description = ''
        Additional command-line arguments passed verbatim to grimmory after -jar grimmory.jar
      '';
      default = [ ];
      type = types.listOf types.str;
      example = [ "--debug" ];
    };

    domain = mkOption {
      description = "Domain to use for the virtualhost to serve Grimmory at.";
      type = types.str;
      example = literalExpression "grimmory.\${config.networking.domain}";
    };

    caddy = {
      enable = mkEnableOption "a virtualhost to serve Grimmory through caddy";
      virtualHost = mkOption {
        description = "Extra configuration for the caddy virtualhost for Grimmory.";
        type = types.submodule (
          import ../web-servers/caddy/vhost-options.nix { cfg = config.services.caddy; }
        );
        default = { };
        example = literalExpression ''
          {
            serverAliases = [ "grimmory.''${config.networking.domain}" ];
          }
        '';
      };
    };

    nginx = {
      enable = mkEnableOption "a virtualhost to serve Grimmory through nginx";
      virtualHost = mkOption {
        description = "Extra configuration for the nginx virtualhost for Grimmory.";
        type = types.submodule (import ../web-servers/nginx/vhost-options.nix { inherit config lib; });
        default = { };
        example = literalExpression ''
          {
            serverAliases = [ "grimmory.''${config.networking.domain}" ];
          }
        '';
      };
    };

  };

  config = mkIf cfg.enable {

    services.grimmory.environment = {
      SERVER_ADDRESS = mkDefault cfg.host;
      BOOKLORE_PORT = mkDefault (toString cfg.port);
      APP_PATH_CONFIG = mkDefault cfg.stateDir;
      APP_BOOKDROP_FOLDER = mkDefault cfg.bookdropDir;
      DATABASE_HOST = mkDefault cfg.database.host;
      DATABASE_PORT = mkDefault (toString cfg.database.port);
      DATABASE_NAME = mkDefault cfg.database.name;
      DATABASE_USERNAME = mkDefault cfg.database.user;
    };

    users.groups = mkIf (cfg.group == "grimmory") { grimmory = { }; };

    users.users = mkIf (cfg.user == "grimmory") {
      grimmory = {
        group = cfg.group;
        home = cfg.stateDir;
        description = "Grimmory Daemon user";
        isSystemUser = true;
      };
    };

    systemd.services.grimmory = {
      description = "Grimmory is a self-hosted library for your ebooks, comics and audiobooks.";

      wantedBy = [ "multi-user.target" ];
      wants = [
        "network-online.target"
        "mysql.service"
      ];
      after = [
        "network-online.target"
        "mysql.service"
      ];

      environment = cfg.environment;

      script =
        if cfg.database.passwordFile != null then
          ''
            DATABASE_PASSWORD="$(cat ''${CREDENTIALS_DIRECTORY}/db-password)" ${lib.getExe cfg.package} ${lib.escapeShellArgs cfg.extraArgs}
          ''
        else
          ''
            ${lib.getExe cfg.package} ${lib.escapeShellArgs cfg.extraArgs}
          '';

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;

        Type = "simple";
        Restart = "on-failure";

        EnvironmentFile = mkIf (cfg.environmentFile != null) cfg.environmentFile;

        LoadCredential = mkIf (cfg.database.passwordFile != null) [
          "db-password:${cfg.database.passwordFile}"
        ];

        ExecStartPre = mkIf cfg.database.createLocally "+${pkgs.writeShellScript "update-grimmory-password" ''
          ${lib.optionalString (cfg.database.passwordFile != null) ''
            DATABASE_PASSWORD="$(cat ''${CREDENTIALS_DIRECTORY}/db-password)"
          ''}

          if [ -z "$DATABASE_PASSWORD" ]; then
            echo "DATABASE_PASSWORD is empty or unset; add a password file with services.grimmory.database.passwordFile or add DATABASE_PASSWORD to services.grimmory.environmentFile" >&2
            exit 1
          fi

          escaped_password="$(printf '%s' "$DATABASE_PASSWORD" | sed "s/'/'''/g")"

          ${lib.getExe' config.services.mysql.package "mysql"} <<EOF
          SET sql_mode = 'NO_BACKSLASH_ESCAPES';
          ALTER USER '${cfg.database.user}'@'localhost' IDENTIFIED BY '$escaped_password';
          FLUSH PRIVILEGES;
          EOF
        ''}";

        StateDirectory = mkIf (cfg.stateDir == "/var/lib/grimmory") "grimmory";

        # Make paths writable if not in the state directory
        ReadWritePaths =
          [ ]
          ++ (optional (cfg.stateDir != "/var/lib/grimmory") cfg.stateDir)
          ++ (optional (!(lib.hasPrefix cfg.stateDir cfg.bookdropDir)) cfg.bookdropDir)
          ++ (optional (!(lib.hasPrefix cfg.stateDir cfg.booksDir)) cfg.booksDir);

        # Hardening
        CapabilityBoundingSet = "";
        LockPersonality = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProcSubset = "all";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "full";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [ "@system-service" ];
      };
    };

    services.mysql = mkIf cfg.database.createLocally {
      enable = true;
      package = mkDefault pkgs.mariadb;
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

    services.caddy = mkIf cfg.caddy.enable {
      enable = lib.mkDefault true;
      virtualHosts.${cfg.domain} = mkMerge [
        cfg.caddy.virtualHost
        {
          hostName = lib.mkForce cfg.domain;
          extraConfig = ''
            reverse_proxy ${cfg.host}:${toString cfg.port}
          '';
        }
      ];
    };

    services.nginx = mkIf cfg.nginx.enable {
      enable = lib.mkDefault true;
      virtualHosts.${cfg.domain} = mkMerge [
        cfg.nginx.virtualHost
        {
          locations."/" = {
            proxyPass = "http://${cfg.host}:${toString cfg.port}";
            proxyWebsockets = true;
            recommendedProxySettings = true;
          };
        }
      ];
    };
  };

  meta.maintainers = with lib.maintainers; [ kraftnix ];
}
