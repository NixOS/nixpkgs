{
  config,
  options,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.nextcloud.notify_push;
  cfgN = config.services.nextcloud;
in
{
  options.services.nextcloud.notify_push = {
    enable = lib.mkEnableOption "Notify push";

    package = lib.mkPackageOption pkgs "nextcloud-notify_push" { };

    socketPath = lib.mkOption {
      type = lib.types.str;
      default = "/run/nextcloud-notify_push/sock";
      description = "Socket path to use for notify_push";
    };

    logLevel = lib.mkOption {
      type = lib.types.enum [
        "error"
        "warn"
        "info"
        "debug"
        "trace"
      ];
      default = "error";
      description = "Log level";
    };

    nextcloudUrl = lib.mkOption {
      type = lib.types.str;
      default = "http${lib.optionalString cfgN.https "s"}://${cfgN.hostName}";
      defaultText = lib.literalExpression ''"http''${lib.optionalString config.services.nextcloud.https "s"}://''${config.services.nextcloud.hostName}"'';
      description = "Configure the nextcloud URL notify_push tries to connect to.";
    };

    bendDomainToLocalhost = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to add an entry to `/etc/hosts` for the configured nextcloud domain to point to `localhost` and add `localhost `to nextcloud's `trusted_proxies` config option.

        This is useful when nextcloud's domain is not a static IP address and when the reverse proxy cannot be bypassed because the backend connection is done via unix socket.
      '';
    };
  }
  // (lib.genAttrs
    [
      "dbtype"
      "dbname"
      "dbuser"
      "dbpassFile"
      "dbhost"
      "dbport"
      "dbtableprefix"
    ]
    (
      opt:
      options.services.nextcloud.config.${opt}
      // {
        default = config.services.nextcloud.config.${opt};
        defaultText = lib.literalExpression "config.services.nextcloud.config.${opt}";
      }
    )
  );

  config = lib.mkIf cfg.enable {
    systemd.services = {
      nextcloud-notify_push = {
        description = "Push daemon for Nextcloud clients";
        documentation = [ "https://github.com/nextcloud/notify_push" ];
        after = [
          "nextcloud-setup.service"
          "phpfpm-nextcloud.service"
          "redis-nextcloud.service"
        ];
        requires = [
          "nextcloud-setup.service"
          "phpfpm-nextcloud.service"
        ];
        wantedBy = [ "multi-user.target" ];
        environment = {
          NEXTCLOUD_URL = cfg.nextcloudUrl;
          SOCKET_PATH = cfg.socketPath;
          DATABASE_PREFIX = cfg.dbtableprefix;
          LOG = cfg.logLevel;
        };
        script =
          let
            dbType = if cfg.dbtype == "pgsql" then "postgresql" else cfg.dbtype;
            dbUser = lib.optionalString (cfg.dbuser != null) cfg.dbuser;
            dbPass = lib.optionalString (cfg.dbpassFile != null) ":$DATABASE_PASSWORD";
            dbHostHasPrefix = prefix: lib.hasPrefix prefix (toString cfg.dbhost);
            isPostgresql = dbType == "postgresql";
            isMysql = dbType == "mysql";
            isSocket = (isPostgresql && dbHostHasPrefix "/") || (isMysql && dbHostHasPrefix "localhost:/");
            dbHost = lib.optionalString (cfg.dbhost != null) (
              if isSocket then lib.optionalString isMysql "@localhost" else "@${cfg.dbhost}"
            );
            dbOpts = lib.optionalString (cfg.dbhost != null && isSocket) (
              if isPostgresql then
                "?host=${cfg.dbhost}"
              else if isMysql then
                "?socket=${lib.removePrefix "localhost:" cfg.dbhost}"
              else
                throw "unsupported dbtype"
            );
            dbName = lib.optionalString (cfg.dbname != null) "/${cfg.dbname}";
            dbUrl = "${dbType}://${dbUser}${dbPass}${dbHost}${dbName}${dbOpts}";
          in
          lib.optionalString (cfg.dbpassFile != null) ''
            export DATABASE_PASSWORD="$(<"$CREDENTIALS_DIRECTORY/dbpass")"
          ''
          + ''
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
          LoadCredential = lib.optional (cfg.dbpassFile != null) "dbpass:${cfg.dbpassFile}";
        };
      };

      nextcloud-notify_push_setup = {
        wantedBy = [ "multi-user.target" ];
        requiredBy = [ "nextcloud-notify_push.service" ];
        after = [ "nextcloud-notify_push.service" ];
        serviceConfig = {
          Type = "oneshot";
          User = "nextcloud";
          Group = "nextcloud";
          ExecStart = "${lib.getExe cfgN.occ} notify_push:setup ${cfg.nextcloudUrl}/push";
          LoadCredential = config.systemd.services.nextcloud-cron.serviceConfig.LoadCredential;
          RestartMode = "direct";
          Restart = "on-failure";
          RestartSec = "5s";
        };
        unitConfig = {
          StartLimitIntervalSec = 30;
          StartLimitBurst = 5;
        };
      };
    };

    networking.hosts = lib.mkIf cfg.bendDomainToLocalhost {
      "127.0.0.1" = [ cfgN.hostName ];
      "::1" = [ cfgN.hostName ];
    };

    services = {
      nginx.virtualHosts.${cfgN.hostName}.locations."^~ /push/" = {
        proxyPass = "http://unix:${cfg.socketPath}";
        proxyWebsockets = true;
        recommendedProxySettings = lib.mkDefault true;
        extraConfig = # nginx
          ''
            # disable in case it was configured on a higher level
            keepalive_timeout 0;
            proxy_buffering off;
          '';
      };
      nextcloud = {
        extraApps = {
          inherit (config.services.nextcloud.package.packages.apps)
            notify_push
            ;
        };
        settings.trusted_proxies = lib.mkIf cfg.bendDomainToLocalhost [
          "127.0.0.1"
          "::1"
        ];
      };
    };
  };
}
