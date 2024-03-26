{ config, options, lib, pkgs, ... }:

let
  cfg = config.services.nextcloud.notify_push;
  cfgN = config.services.nextcloud;
in
{
  options.services.nextcloud.notify_push = {
    enable = lib.mkEnableOption (lib.mdDoc "Notify push");

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.nextcloud-notify_push;
      defaultText = lib.literalMD "pkgs.nextcloud-notify_push";
      description = lib.mdDoc "Which package to use for notify_push";
    };

    socketPath = lib.mkOption {
      type = lib.types.str;
      default = "/run/nextcloud-notify_push/sock";
      description = lib.mdDoc "Socket path to use for notify_push";
    };

    logLevel = lib.mkOption {
      type = lib.types.enum [ "error" "warn" "info" "debug" "trace" ];
      default = "error";
      description = lib.mdDoc "Log level";
    };

    bendDomainToLocalhost = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether to add an entry to `/etc/hosts` for the configured nextcloud domain to point to `localhost` and add `localhost `to nextcloud's `trusted_proxies` config option.

        This is useful when nextcloud's domain is not a static IP address and when the reverse proxy cannot be bypassed because the backend connection is done via unix socket.
      '';
    };
  } // (
    lib.genAttrs [
      "dbtype"
      "dbname"
      "dbuser"
      "dbpassFile"
      "dbhost"
      "dbport"
      "dbtableprefix"
    ] (
      opt: options.services.nextcloud.config.${opt} // {
        default = config.services.nextcloud.config.${opt};
        defaultText = "config.services.nextcloud.config.${opt}";
      }
    )
  );

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
        DATABASE_PREFIX = cfg.dbtableprefix;
        LOG = cfg.logLevel;
      };
      postStart = ''
        ${cfgN.occ}/bin/nextcloud-occ notify_push:setup ${nextcloudUrl}/push
      '';
      script = let
        dbType = if cfg.dbtype == "pgsql" then "postgresql" else cfg.dbtype;
        dbUser = lib.optionalString (cfg.dbuser != null) cfg.dbuser;
        dbPass = lib.optionalString (cfg.dbpassFile != null) ":$DATABASE_PASSWORD";
        isSocket = lib.hasPrefix "/" (toString cfg.dbhost);
        dbHost = lib.optionalString (cfg.dbhost != null) (if
          isSocket then
            if dbType == "postgresql" then "?host=${cfg.dbhost}" else
            if dbType == "mysql" then "?socket=${cfg.dbhost}" else throw "unsupported dbtype"
          else
            "@${cfg.dbhost}");
        dbName = lib.optionalString (cfg.dbname != null) "/${cfg.dbname}";
        dbUrl = "${dbType}://${dbUser}${dbPass}${lib.optionalString (!isSocket) dbHost}${dbName}${lib.optionalString isSocket dbHost}";
      in lib.optionalString (dbPass != "") ''
        export DATABASE_PASSWORD="$(<"${cfg.dbpassFile}")"
      '' + ''
        export DATABASE_URL="${dbUrl}"
        ${cfg.package}/bin/notify_push '${cfgN.datadir}/config/config.php'
      '';
      serviceConfig = {
        User = "nextcloud";
        Group = "nextcloud";
        RuntimeDirectory = [ "nextcloud-notify_push" ];
        Restart = "on-failure";
        RestartSec = "5s";
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
