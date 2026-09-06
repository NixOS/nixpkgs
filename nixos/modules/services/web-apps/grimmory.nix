{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkDefault
    mkOption
    mkEnableOption
    types
    ;
  cfg = config.services.grimmory;
in
{
  options.services.grimmory = {
    enable = mkEnableOption "Grimmory, a self-hosted digital library for people who take their reading seriously.";

    package = mkOption {
      description = "Grimmory package to use";
      default = pkgs.grimmory;
      defaultText = "pkgs.grimmory";
      type = types.package;
    };

    port = mkOption {
      description = "Port on which Grimmory shoud listen on";
      default = 6060;
      type = types.port;
      example = 8080;
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
      description = "State and configuration directory Grimmory will use.";
      default = "/var/lib/grimmory";
      type = types.str;
      example = "/grimmory";
    };

    database = {
      name = mkOption {
        description = ''
          Name of the MySQL database that holds Grimmory's data.
        '';
        default = "grimmory";
        type = types.str;
        example = "booklore";
      };

      username = mkOption {
        description = ''
          Name of the user with all permissions to the Grimmory MySQL database.
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

    extraArgs = mkOption {
      description = ''
        Additional command-line arguments passed verbatim to grimmory after -jar grimmory.jar
      '';
      default = [ ];
      type = types.listOf types.str;
      example = [ "--debug" ];
    };

    webserver = mkOption {
      description = ''
        A proxy is required to serve the grimmory frontend, if left empty then you must configure a proxy yourself.
      '';
      default = "";
      type = types.enum [
        ""
        "caddy"
        "nginx"
      ];
      example = "caddy";
    };

    virtualHost = mkOption {
      description = ''
        virtualhost to serve the
      '';
      default = "grimmory";
      type = types.str;
      example = lib.literalExpression "grimmory.\${config.networking.domain}";
    };

  };

  config = mkIf cfg.enable {

    services.grimmory.environment = {
      BOOKLORE_PORT = mkDefault (toString cfg.port);
      DATABASE_URL = mkDefault "jdbc:mariadb://localhost:3306/${cfg.database.name}";
      DATABASE_NAME = mkDefault cfg.database.name;
      DATABASE_USERNAME = mkDefault cfg.database.username;
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
      description = "Grimmory is a self-hosted digital library for people who take their reading seriously.";

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

      script = mkIf (cfg.database.passwordFile != null) ''
        DATABASE_PASSWORD="$(cat ''${CREDENTIALS_DIRECTORY}/db-password)" ${lib.getExe cfg.package} ${lib.concatStringsSep " " cfg.extraArgs}
      '';

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;

        Type = "simple";
        Restart = "on-failure";

        ExecStart = mkIf (
          cfg.database.passwordFile == null
        ) "${lib.getExe cfg.package} ${lib.concatStringsSep " " cfg.extraArgs}";

        LoadCredential = mkIf (cfg.database.passwordFile != null) [
          "db-password:${cfg.database.passwordFile}"
        ];

        StateDirectory = mkIf (cfg.stateDir == "/var/lib/grimmory") "grimmory";

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
          "AF_NETLINK"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [ "@system-service" ];
      };
    };

    services.mysql = {
      enable = true;
      package = pkgs.mariadb;
    };

    systemd.services.mysql.serviceConfig.LoadCredential = mkIf (cfg.database.passwordFile != null) [
      "db-password:${cfg.database.passwordFile}"
    ];
    systemd.services.mysql.postStart = lib.mkAfter (
      if (cfg.database.passwordFile == null) then
        ''
          ( echo "CREATE DATABASE IF NOT EXISTS \`${cfg.database.name}\` CHARACTER SET utf8 COLLATE utf8_bin;"
            echo "CREATE USER IF NOT EXISTS '${cfg.database.username}'@'localhost' IDENTIFIED WITH unix_socket;"
            echo "GRANT ALL PRIVILEGES ON \`${cfg.database.name}\`.* TO '${cfg.database.username}'@'localhost';"
          ) | ${config.services.mysql.package}/bin/mysql -N
        ''
      else
        ''
          DATABASE_PASSWORD="$(cat ''${CREDENTIALS_DIRECTORY}/db-password)"
          ( echo "CREATE DATABASE IF NOT EXISTS \`${cfg.database.name}\` CHARACTER SET utf8 COLLATE utf8_bin;"
            echo "CREATE USER IF NOT EXISTS '${cfg.database.username}'@'localhost' IDENTIFIED BY '$DATABASE_PASSWORD';"
            echo "GRANT ALL PRIVILEGES ON \`${cfg.database.name}\`.* TO '${cfg.database.username}'@'localhost';"
          ) | ${config.services.mysql.package}/bin/mysql -N
        ''
    );

    services.caddy = mkIf (cfg.webserver == "caddy") {
      enable = true;
      virtualHosts.${cfg.virtualHost}.extraConfig = ''
        @backend path /api/* /ws
        reverse_proxy @backend localhost:${toString cfg.port}
        root * ${cfg.package.passthru.grimmory-frontend}
        file_server
      '';
    };

    services.nginx = mkIf (cfg.webserver == "nginx") {
      enable = true;
      virtualHosts.${cfg.virtualHost} = {
        root = cfg.package.passthru.grimmory-frontend;

        locations."/ws/" = {
          proxyWebsockets = true;
          proxyPass = "http://localhost:${toString cfg.port}";
          recommendedProxySettings = true;
        };

        locations."/api/" = {
          proxyWebsockets = true;
          proxyPass = "http://localhost:${toString cfg.port}";
          recommendedProxySettings = true;
          extraConfig = ''
            proxy_set_header X-Forwarded-Port $server_port;
            proxy_buffer_size 64k;
            proxy_buffers 4 128k;
            proxy_busy_buffers_size 128k;
          '';
        };

        locations."/" = {
          tryFiles = "$uri $uri/ /index.html =404";
        };
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ kraftnix ];
}
