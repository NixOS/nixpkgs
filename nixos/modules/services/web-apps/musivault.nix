{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.musivault;
  isCustomDataDir = cfg.dataDir != "/var/lib/musivault";
in
{
  options.services.musivault = {
    enable = lib.mkEnableOption "Musivault, a web application to catalog and explore your vinyl and CD collection";

    package = lib.mkPackageOption pkgs "musivault" { };

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/musivault";
      description = ''
        The directory where Musivault stores its state files (uploads, logs).

        Note: A bind mount will be used to mount the directory at the expected location
        if a different value than `/var/lib/musivault` is used.
      '';
    };

    enableLocalDB = lib.mkEnableOption "a local MongoDB instance";

    mongodbPackage = lib.mkPackageOption pkgs "mongodb-ce" { };

    port = lib.mkOption {
      type = lib.types.port;
      default = 5001;
      description = "The port the Musivault backend listens on.";
    };

    host = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = "The address the Musivault backend binds to.";
    };

    environment = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      example = {
        DISCOGS_KEY = "your_discogs_key";
        CORS_ORIGINS = "https://musivault.example.com";
      };
      description = ''
        Environment variables to set for the Musivault backend.
        Secrets should be specified using {option}`environmentFiles`.
        Refer to the [Musivault documentation](https://github.com/Jeanball/Musivault)
        for available options.
      '';
    };

    environmentFiles = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [ ];
      example = [ "/run/secrets/musivault.env" ];
      description = ''
        Files to load environment variables from. Loaded variables override
        values set in {option}`environment`. Use this for secrets such as
        `SESSION_SECRET`, `JWT_SECRET`, `DISCOGS_SECRET`, and `DISCOGS_KEY`.
      '';
    };

    nginxVirtualHost = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        If set, creates an nginx virtual host serving the Musivault frontend
        and proxying API requests to the backend. Should be the domain name
        without protocol prefix.
      '';
      example = "musivault.example.com";
    };
  };

  config = lib.mkIf cfg.enable {
    services.mongodb = lib.mkIf cfg.enableLocalDB {
      enable = true;
      package = cfg.mongodbPackage;
    };

    systemd.services.musivault = {
      description = "Musivault server";
      wantedBy = [ "multi-user.target" ];
      after = [
        "network.target"
      ]
      ++ lib.optionals cfg.enableLocalDB [ "mongodb.service" ];
      requires = lib.optionals cfg.enableLocalDB [ "mongodb.service" ];

      environment = {
        PORT = toString cfg.port;
        HOST = cfg.host;
        APP_VERSION = cfg.package.version;
        COMMIT_SHA = cfg.package.src.rev;
        MONGO_URI = lib.mkDefault (if cfg.enableLocalDB then "mongodb://localhost:27017/musivault" else "");
      }
      // cfg.environment;

      preStart = ''
        mkdir -p /var/lib/musivault/uploads/covers
        mkdir -p /var/lib/musivault/logs/imports
        mkdir -p /var/lib/musivault/logs/audits
      '';

      unitConfig.RequiresMountsFor = [ cfg.dataDir ];

      serviceConfig = {
        ExecStart = lib.getExe cfg.package;
        DynamicUser = true;
        StateDirectory = "musivault";
        WorkingDirectory = "/var/lib/musivault";
        EnvironmentFile = cfg.environmentFiles;
        Restart = "on-failure";

        # Hardening
        CapabilityBoundingSet = "";
        LockPersonality = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_NETLINK"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "@pkey"
        ];
        UMask = "0077";
      };
    };

    systemd.tmpfiles.settings."10-musivault".${cfg.dataDir}.d = lib.mkIf isCustomDataDir {
      user = "root";
      group = "root";
      mode = "0700";
    };

    systemd.mounts = lib.optional isCustomDataDir {
      what = cfg.dataDir;
      where = "/var/lib/private/musivault";
      options = "bind";
      wantedBy = [ "local-fs.target" ];
    };

    services.nginx = lib.mkIf (cfg.nginxVirtualHost != null) {
      enable = true;
      virtualHosts.${cfg.nginxVirtualHost} = {
        root = "${cfg.package}/share/musivault";
        locations."/" = {
          tryFiles = "$uri $uri/ /index.html";
          extraConfig = ''
            add_header X-Frame-Options "SAMEORIGIN";
            add_header X-Content-Type-Options "nosniff";
          '';
        };
        locations."/api/" = {
          proxyPass = "http://${cfg.host}:${toString cfg.port}";
          recommendedProxySettings = true;
        };
        locations."/uploads/" = {
          proxyPass = "http://${cfg.host}:${toString cfg.port}";
          recommendedProxySettings = true;
        };
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ tomhesse ];
}
