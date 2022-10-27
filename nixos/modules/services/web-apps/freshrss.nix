{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.freshrss;

  poolName = "freshrss";
in
{
  meta.maintainers = with maintainers; [ etu stunkymonkey ];

  options.services.freshrss = {
    enable = mkEnableOption (mdDoc "FreshRSS feed reader");

    package = mkOption {
      type = types.package;
      default = pkgs.freshrss;
      defaultText = lib.literalExpression "pkgs.freshrss";
      description = mdDoc "Which FreshRSS package to use.";
    };

    defaultUser = mkOption {
      type = types.str;
      default = "admin";
      description = mdDoc "Default username for FreshRSS.";
      example = "eva";
    };

    passwordFile = mkOption {
      type = types.path;
      description = mdDoc "Password for the defaultUser for FreshRSS.";
      example = "/run/secrets/freshrss";
    };

    baseUrl = mkOption {
      type = types.str;
      description = mdDoc "Default URL for FreshRSS.";
      example = "https://freshrss.example.com";
    };

    language = mkOption {
      type = types.str;
      default = "en";
      description = mdDoc "Default language for FreshRSS.";
      example = "de";
    };

    database = {
      type = mkOption {
        type = types.enum [ "sqlite" "pgsql" "mysql" ];
        default = "sqlite";
        description = mdDoc "Database type.";
        example = "pgsql";
      };

      host = mkOption {
        type = types.nullOr types.str;
        default = "localhost";
        description = mdDoc "Database host for FreshRSS.";
      };

      port = mkOption {
        type = with types; nullOr port;
        default = null;
        description = mdDoc "Database port for FreshRSS.";
        example = 3306;
      };

      user = mkOption {
        type = types.nullOr types.str;
        default = "freshrss";
        description = mdDoc "Database user for FreshRSS.";
      };

      passFile = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = mdDoc "Database password file for FreshRSS.";
        example = "/run/secrets/freshrss";
      };

      name = mkOption {
        type = types.nullOr types.str;
        default = "freshrss";
        description = mdDoc "Database name for FreshRSS.";
      };

      tableprefix = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = mdDoc "Database table prefix for FreshRSS.";
        example = "freshrss";
      };
    };

    dataDir = mkOption {
      type = types.str;
      default = "/var/lib/freshrss";
      description = mdDoc "Default data folder for FreshRSS.";
      example = "/mnt/freshrss";
    };

    virtualHost = mkOption {
      type = types.nullOr types.str;
      default = "freshrss";
      description = mdDoc ''
        Name of the nginx virtualhost to use and setup. If null, do not setup any virtualhost.
      '';
    };

    pool = mkOption {
      type = types.str;
      default = poolName;
      description = mdDoc ''
        Name of the phpfpm pool to use and setup. If not specified, a pool will be created
        with default values.
      '';
    };
  };


  config =
    let
      systemd-hardening = {
        CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
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
      };
    in
    mkIf cfg.enable {
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
      services.phpfpm.pools = mkIf (cfg.pool == poolName) {
        ${poolName} = {
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
          phpEnv = {
            FRESHRSS_DATA_PATH = "${cfg.dataDir}";
          };
        };
      };

      users.users.freshrss = {
        description = "FreshRSS service user";
        isSystemUser = true;
        group = "freshrss";
      };
      users.groups.freshrss = { };

      systemd.services.freshrss-config =
        let
          settingsFlags = concatStringsSep " \\\n    "
            (mapAttrsToList (k: v: "${k} ${toString v}") {
              "--default_user" = ''"${cfg.defaultUser}"'';
              "--auth_type" = ''"form"'';
              "--base_url" = ''"${cfg.baseUrl}"'';
              "--language" = ''"${cfg.language}"'';
              "--db-type" = ''"${cfg.database.type}"'';
              # The following attributes are optional depending on the type of
              # database.  Those that evaluate to null on the left hand side
              # will be omitted.
              ${if cfg.database.name != null then "--db-base" else null} = ''"${cfg.database.name}"'';
              ${if cfg.database.passFile != null then "--db-password" else null} = ''"$(cat ${cfg.database.passFile})"'';
              ${if cfg.database.user != null then "--db-user" else null} = ''"${cfg.database.user}"'';
              ${if cfg.database.tableprefix != null then "--db-prefix" else null} = ''"${cfg.database.tableprefix}"'';
              ${if cfg.database.host != null && cfg.database.port != null then "--db-host" else null} = ''"${cfg.database.host}:${toString cfg.database.port}"'';
            });
        in
        {
          description = "Set up the state directory for FreshRSS before use";
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            Type = "oneshot";
            User = "freshrss";
            Group = "freshrss";
            StateDirectory = "freshrss";
            WorkingDirectory = cfg.package;
          } // systemd-hardening;
          environment = {
            FRESHRSS_DATA_PATH = cfg.dataDir;
          };

          script = ''
            # create files with correct permissions
            mkdir -m 755 -p ${cfg.dataDir}

            # do installation or reconfigure
            if test -f ${cfg.dataDir}/config.php; then
              # reconfigure with settings
              ./cli/reconfigure.php ${settingsFlags}
              ./cli/update-user.php --user ${cfg.defaultUser} --password "$(cat ${cfg.passwordFile})"
            else
              # Copy the user data template directory
              cp -r ./data ${cfg.dataDir}

              # check correct folders in data folder
              ./cli/prepare.php
              # install with settings
              ./cli/do-install.php ${settingsFlags}
              ./cli/create-user.php --user ${cfg.defaultUser} --password "$(cat ${cfg.passwordFile})"
            fi
          '';
        };

      systemd.services.freshrss-updater = {
        description = "FreshRSS feed updater";
        after = [ "freshrss-config.service" ];
        wantedBy = [ "multi-user.target" ];
        startAt = "*:0/5";
        environment = {
          FRESHRSS_DATA_PATH = cfg.dataDir;
        };
        serviceConfig = {
          Type = "oneshot";
          User = "freshrss";
          Group = "freshrss";
          StateDirectory = "freshrss";
          WorkingDirectory = cfg.package;
          ExecStart = "${cfg.package}/app/actualize_script.php";
        } // systemd-hardening;
      };
    };
}
