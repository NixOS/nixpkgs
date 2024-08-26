{ config, options, lib, pkgs, ... }:

let
  cfg = config.services.nextcloud.notify_push;
  cfgD = config.services.nextcloud.notify_push.database;
  cfgN = config.services.nextcloud;
in
{
  options.services.nextcloud.notify_push = {
    enable = lib.mkEnableOption "Notify push";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.nextcloud-notify_push;
      defaultText = lib.literalMD "pkgs.nextcloud-notify_push";
      description = "Which package to use for notify_push";
    };

    socketPath = lib.mkOption {
      type = lib.types.str;
      default = "/run/nextcloud-notify_push/sock";
      description = "Socket path to use for notify_push";
    };

    logLevel = lib.mkOption {
      type = lib.types.enum [ "error" "warn" "info" "debug" "trace" ];
      default = "error";
      description = "Log level";
    };

    bendDomainToLocalhost = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to add an entry to `/etc/hosts` for the configured nextcloud domain to point to `localhost` and add `localhost `to nextcloud's `trusted_proxies` config option.

        This is useful when nextcloud's domain is not a static IP address and when the reverse proxy cannot be bypassed because the backend connection is done via unix socket.
      '';
    };

    database = {
      dbtype = lib.mkOption {
        type = lib.types.enum [ "sqlite" "pgsql" "mysql" ];
        default = cfgN.settings.dbtype;
        description = "Database type.";
      };
      dbname = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = cfgN.settings.dbname;
        description = "Database name.";
      };
      dbuser = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = cfgN.settings.dbuser;
        description = "Database user.";
      };
      dbhost = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = cfgN.settings.dbhost;
        description = ''
          Database host (+port) or socket path. Defaults to the correct unix socket
          instead if [](#opt-services.nextcloud.database.createLocally) is true and
          [](#opt-services.nextcloud.settings.dbtype) is either `pgsql` or
          `mysql`.
        '';
      };
      dbtableprefix = lib.mkOption {
        type = lib.types.str;
        default = cfgN.settings.dbtableprefix;
        description = "Table prefix in Nextcloud database.";
      };
      dbpassFile = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          The full path to a file that contains the database password.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.nextcloud-notify_push = let
      nextcloudUrl = "http${lib.optionalString cfgN.https "s"}://${cfgN.hostName}";
    in {
      description = "Push daemon for Nextcloud clients";
      documentation = [ "https://github.com/nextcloud/notify_push" ];
      after = [
        "phpfpm-nextcloud.service"
        "redis-nextcloud.service"
      ];
      wantedBy = [ "multi-user.target" ];
      environment = {
        NEXTCLOUD_URL = nextcloudUrl;
        SOCKET_PATH = cfg.socketPath;
        DATABASE_PREFIX = cfgD.dbtableprefix;
        LOG = cfg.logLevel;
      };
      postStart = ''
        ${cfgN.occ}/bin/nextcloud-occ notify_push:setup ${nextcloudUrl}/push
      '';
      script = let
        dbType = if cfgD.dbtype == "pgsql" then "postgresql" else cfgD.dbtype;
        dbUser = lib.optionalString (cfgD.dbuser != null) cfgD.dbuser;
        dbPass = lib.optionalString (cfgD.dbpassFile != null) ":$DATABASE_PASSWORD";
        isSocket = lib.hasPrefix "/" (toString cfgD.dbhost);
        dbHost = lib.optionalString (cfgD.dbhost != null) (if
          isSocket then
            if dbType == "postgresql" then "?host=${cfgD.dbhost}" else
            if dbType == "mysql" then "?socket=${cfgD.dbhost}" else throw "unsupported dbtype"
          else
            "@${cfgD.dbhost}");
        dbName = lib.optionalString (cfgD.dbname != null) "/${cfgD.dbname}";
        dbUrl = "${dbType}://${dbUser}${dbPass}${lib.optionalString (!isSocket) dbHost}${dbName}${lib.optionalString isSocket dbHost}";
      in lib.optionalString (dbPass != "") ''
        export DATABASE_PASSWORD="$(<"${cfgD.dbpassFile}")"
      '' + ''
        export DATABASE_URL="${dbUrl}"
        exec ${cfg.package}/bin/notify_push '${cfgN.datadir}/config/config.php'
      '';
      serviceConfig = {
        User = "nextcloud";
        Group = "nextcloud";
        RuntimeDirectory = [ "nextcloud-notify_push" ];
        Restart = "on-failure";
        RestartSec = "5s";
        Type = "notify";
      };
    };

    networking.hosts = lib.mkIf cfg.bendDomainToLocalhost {
      "127.0.0.1" = [ cfgN.hostName ];
      "::1" = [ cfgN.hostName ];
    };

    services = lib.mkMerge [
      {
        nginx.virtualHosts.${cfgN.hostName}.locations."^~ /push/" = {
          proxyPass = "http://unix:${cfg.socketPath}";
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };
      }

      (lib.mkIf cfg.bendDomainToLocalhost {
        nextcloud.settings.trusted_proxies = [ "127.0.0.1" "::1" ];
      })
    ];
  };
}
