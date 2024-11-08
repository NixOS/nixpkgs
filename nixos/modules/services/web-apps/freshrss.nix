{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.freshrss;

  extension-env = pkgs.buildEnv {
    name = "freshrss-extensions";
    paths = cfg.extensions;
  };
  env-vars = {
    DATA_PATH = cfg.dataDir;
    THIRDPARTY_EXTENSIONS_PATH = "${extension-env}/share/freshrss/";
  };
in
{
  meta.maintainers = with maintainers; [ etu stunkymonkey mattchrist ];

  options.services.freshrss = {
    enable = mkEnableOption "FreshRSS RSS aggregator and reader with php-fpm backend";

    package = mkPackageOption pkgs "freshrss" { };

    extensions = mkOption {
      type = types.listOf types.package;
      default = [ ];
      defaultText = literalExpression "[]";
      example = literalExpression ''
        with freshrss-extensions; [
          youtube
        ] ++ [
          (freshrss-extensions.buildFreshRssExtension {
            FreshRssExtUniqueId = "ReadingTime";
            pname = "reading-time";
            version = "1.5";
            src = pkgs.fetchFromGitLab {
              domain = "framagit.org";
              owner = "Lapineige";
              repo = "FreshRSS_Extension-ReadingTime";
              rev = "fb6e9e944ef6c5299fa56ffddbe04c41e5a34ebf";
             hash = "sha256-C5cRfaphx4Qz2xg2z+v5qRji8WVSIpvzMbethTdSqsk=";
           };
          })
        ]
      '';
      description = "Additional extensions to be used.";
    };

    defaultUser = mkOption {
      type = types.str;
      default = "admin";
      description = "Default username for FreshRSS.";
      example = "eva";
    };

    passwordFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "Password for the defaultUser for FreshRSS.";
      example = "/run/secrets/freshrss";
    };

    baseUrl = mkOption {
      type = types.str;
      description = "Default URL for FreshRSS.";
      example = "https://freshrss.example.com";
    };

    language = mkOption {
      type = types.str;
      default = "en";
      description = "Default language for FreshRSS.";
      example = "de";
    };

    database = {
      type = mkOption {
        type = types.enum [ "sqlite" "pgsql" "mysql" ];
        default = "sqlite";
        description = "Database type.";
        example = "pgsql";
      };

      host = mkOption {
        type = types.nullOr types.str;
        default = "localhost";
        description = "Database host for FreshRSS.";
      };

      port = mkOption {
        type = types.nullOr types.port;
        default = null;
        description = "Database port for FreshRSS.";
        example = 3306;
      };

      user = mkOption {
        type = types.nullOr types.str;
        default = "freshrss";
        description = "Database user for FreshRSS.";
      };

      passFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = "Database password file for FreshRSS.";
        example = "/run/secrets/freshrss";
      };

      name = mkOption {
        type = types.nullOr types.str;
        default = "freshrss";
        description = "Database name for FreshRSS.";
      };

      tableprefix = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Database table prefix for FreshRSS.";
        example = "freshrss";
      };
    };

    dataDir = mkOption {
      type = types.str;
      default = "/var/lib/freshrss";
      description = "Default data folder for FreshRSS.";
      example = "/mnt/freshrss";
    };

    virtualHost = mkOption {
      type = types.nullOr types.str;
      default = "freshrss";
      description = ''
        Name of the nginx virtualhost to use and setup. If null, do not setup any virtualhost.
        You may need to configure the virtualhost further through services.nginx.virtualHosts.<virtualhost>,
        for example to enable SSL.
      '';
    };

    pool = mkOption {
      type = types.nullOr types.str;
      default = "freshrss";
      description = ''
        Name of the php-fpm pool to use and setup. If not specified, a pool will be created
        with default values.
      '';
    };

    user = mkOption {
      type = types.str;
      default = "freshrss";
      description = "User under which FreshRSS runs.";
    };

    authType = mkOption {
      type = types.enum [ "form" "http_auth" "none" ];
      default = "form";
      description = "Authentication type for FreshRSS.";
    };
  };

  config =
    let
      defaultServiceConfig = {
        ReadWritePaths = "${cfg.dataDir}";
        DeviceAllow = "";
        LockPersonality = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RemoveIPC = true;
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [ "@system-service" "~@resources" "~@privileged" ];
        UMask = "0007";
        Type = "oneshot";
        User = cfg.user;
        Group = config.users.users.${cfg.user}.group;
        StateDirectory = "freshrss";
        WorkingDirectory = cfg.package;
      };
    in
    mkIf cfg.enable {
      assertions = mkIf (cfg.authType == "form") [
        {
          assertion = cfg.passwordFile != null;
          message = ''
            `passwordFile` must be supplied when using "form" authentication!
          '';
        }
      ];
      # Set up a Nginx virtual host.
      services.nginx = mkIf (cfg.virtualHost != null) {
        enable = true;
        virtualHosts.${cfg.virtualHost} = {
          root = "${cfg.package}/p";

          # php files handling
          # this regex is mandatory because of the API
          locations."~ ^.+?\.php(/.*)?$".extraConfig = ''
            fastcgi_pass unix:${config.services.phpfpm.pools.${cfg.pool}.socket};
            fastcgi_split_path_info ^(.+\.php)(/.*)$;
            # By default, the variable PATH_INFO is not set under PHP-FPM
            # But FreshRSS API greader.php need it. If you have a “Bad Request” error, double check this var!
            # NOTE: the separate $path_info variable is required. For more details, see:
            # https://trac.nginx.org/nginx/ticket/321
            set $path_info $fastcgi_path_info;
            fastcgi_param PATH_INFO $path_info;
            include ${pkgs.nginx}/conf/fastcgi_params;
            include ${pkgs.nginx}/conf/fastcgi.conf;
          '';

          locations."/" = {
            tryFiles = "$uri $uri/ index.php";
            index = "index.php index.html index.htm";
          };
        };
      };

      # Set up phpfpm pool
      services.phpfpm.pools = mkIf (cfg.pool != null) {
        ${cfg.pool} = {
          user = "freshrss";
          settings = {
            "listen.owner" = "nginx";
            "listen.group" = "nginx";
            "listen.mode" = "0600";
            "pm" = "dynamic";
            "pm.max_children" = 32;
            "pm.max_requests" = 500;
            "pm.start_servers" = 2;
            "pm.min_spare_servers" = 2;
            "pm.max_spare_servers" = 5;
            "catch_workers_output" = true;
          };
          phpEnv = env-vars;
        };
      };

      users.users."${cfg.user}" = {
        description = "FreshRSS service user";
        isSystemUser = true;
        group = "${cfg.user}";
        home = cfg.dataDir;
      };
      users.groups."${cfg.user}" = { };

      systemd.tmpfiles.settings."10-freshrss".${cfg.dataDir}.d = {
        inherit (cfg) user;
        group = config.users.users.${cfg.user}.group;
      };

      systemd.services.freshrss-config =
        let
          settingsFlags = concatStringsSep " \\\n    "
            (mapAttrsToList (k: v: "${k} ${toString v}") {
              "--default-user" = ''"${cfg.defaultUser}"'';
              "--auth-type" = ''"${cfg.authType}"'';
              "--base-url" = ''"${cfg.baseUrl}"'';
              "--language" = ''"${cfg.language}"'';
              "--db-type" = ''"${cfg.database.type}"'';
              # The following attributes are optional depending on the type of
              # database.  Those that evaluate to null on the left hand side
              # will be omitted.
              ${if cfg.database.name != null then "--db-base" else null} = ''"${cfg.database.name}"'';
              ${if cfg.database.passFile != null then "--db-password" else null} = ''"$(cat ${cfg.database.passFile})"'';
              ${if cfg.database.user != null then "--db-user" else null} = ''"${cfg.database.user}"'';
              ${if cfg.database.tableprefix != null then "--db-prefix" else null} = ''"${cfg.database.tableprefix}"'';
              # hostname:port e.g. "localhost:5432"
              ${if cfg.database.host != null && cfg.database.port != null then "--db-host" else null} = ''"${cfg.database.host}:${toString cfg.database.port}"'';
              # socket path e.g. "/run/postgresql"
              ${if cfg.database.host != null && cfg.database.port == null then "--db-host" else null} = ''"${cfg.database.host}"'';
            });
        in
        {
          description = "Set up the state directory for FreshRSS before use";
          wantedBy = [ "multi-user.target" ];
          serviceConfig = defaultServiceConfig // {
            RemainAfterExit = true;
          };
          restartIfChanged = true;
          environment = env-vars;

          script =
            let
              userScriptArgs = ''--user ${cfg.defaultUser} ${optionalString (cfg.authType == "form") ''--password "$(cat ${cfg.passwordFile})"''}'';
              updateUserScript = optionalString (cfg.authType == "form" || cfg.authType == "none") ''
                ./cli/update-user.php ${userScriptArgs}
              '';
              createUserScript = optionalString (cfg.authType == "form" || cfg.authType == "none") ''
                ./cli/create-user.php ${userScriptArgs}
              '';
            in
            ''
              # do installation or reconfigure
              if test -f ${cfg.dataDir}/config.php; then
                # reconfigure with settings
                ./cli/reconfigure.php ${settingsFlags}
                ${updateUserScript}
              else
                # check correct folders in data folder
                ./cli/prepare.php
                # install with settings
                ./cli/do-install.php ${settingsFlags}
                ${createUserScript}
              fi
            '';
        };

      systemd.services.freshrss-updater = {
        description = "FreshRSS feed updater";
        after = [ "freshrss-config.service" ];
        startAt = "*:0/5";
        environment = env-vars;
        serviceConfig = defaultServiceConfig // {
          ExecStart = "${cfg.package}/app/actualize_script.php";
        };
      };
    };
}
