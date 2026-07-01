{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.yamtrack;

  inherit (lib) mkOption types mkIf;
in
{
  options.services.yamtrack = {
    enable = lib.mkEnableOption "Yamtrack";
    package = lib.mkPackageOption pkgs "yamtrack" { };

    virtualHost = mkOption {
      type = types.nullOr types.str;
      description = ''
        The nginx virtualHost to configure for Yamtrack.
        For more control set additional options in i.e. `services.nginx.virtualHosts.yamtrack`.
        By default this is accessible as yamtrack.localhost.
      '';
      default = "yamtrack";
    };

    environment = mkOption {
      type = types.submodule {
        freeformType = types.attrsOf types.str;
      };
      description = ''
        Environment variables passed to Yamtrack.
        See the [documentation](https://github.com/FuzzyGrim/Yamtrack/wiki/Environment-Variables)
        for available options.
      '';
      default = { };
      example = {
        REGISTRATION = false;
        ADMIN_ENABLED = true;
      };
    };
    environmentFile = mkOption {
      type = types.nullOr types.path;
      description = ''
        File containing environment variables passed to Yamtrack.
        See the [documentation](https://github.com/FuzzyGrim/Yamtrack/wiki/Environment-Variables)
        for available options.
      '';
      example = "/run/secrets/yamtrack.env";
      default = null;
    };
    port = mkOption {
      type = types.port;
      description = "The port the Yamtrack backend runs behind.";
      default = 8001;
    };
    user = mkOption {
      type = types.str;
      description = "The user Yamtrack is run as.";
      default = "yamtrack";
    };
    group = mkOption {
      type = types.str;
      description = "The group Yamtrack is run as.";
      default = "yamtrack";
    };
  };

  config = mkIf cfg.enable {
    services.yamtrack.environment = {
      DB_FILE = lib.mkDefault "/var/lib/yamtrack/db.sqlite3";
      PORT = toString cfg.port;
      REDIS_URL = "unix://${config.services.redis.servers.yamtrack.unixSocket}";
      CELERY_REDIS_URL = "redis+socket://${config.services.redis.servers.yamtrack.unixSocket}";
    };

    services.redis.servers.yamtrack = {
      enable = true;
    };

    users = {
      users = mkIf (cfg.user == "yamtrack") {
        yamtrack = {
          group = cfg.group;
          isSystemUser = true;
        };
      };
      groups = mkIf (cfg.group == "yamtrack") {
        yamtrack = {
          members = [ cfg.user ];
        };
      };
    };

    services.nginx = mkIf (cfg.virtualHost != null) {
      enable = true;
      # https://github.com/FuzzyGrim/Yamtrack/blob/v0.25.0/nginx.conf
      virtualHosts.${cfg.virtualHost} = {
        serverName = lib.mkIf (cfg.virtualHost == "yamtrack") (lib.mkDefault "yamtrack.localhost");
        extraConfig = ''
          add_header X-Frame-Options "SAMEORIGIN" always;
          add_header X-Content-Type-Options "nosniff" always;
          add_header Referrer-Policy "no-referrer-when-downgrade" always;
        '';

        locations = {
          "/" = {
            proxyPass = "http://127.0.0.1:${toString cfg.port}";
            recommendedProxySettings = true;
          };
          "/static/" = {
            alias = "${cfg.package.staticFiles}/";
            extraConfig = ''
              expires 30d;
              add_header Cache-Control "public";

              add_header X-Frame-Options "SAMEORIGIN" always;
              add_header X-Content-Type-Options "nosniff" always;
              add_header Referrer-Policy "no-referrer-when-downgrade" always;
            '';
          };
        };
      };
    };

    systemd.targets.yamtrack = {
      description = "all Yamtrack services";
      wantedBy = [ "multi-user.target" ];
    };

    systemd.services =
      let
        commonConfig = {
          EnvironmentFile = lib.mkIf (cfg.environmentFile != null) cfg.environmentFile;
          StateDirectory = "yamtrack";
          StateDirectoryMode = "0700";
          User = cfg.user;
          Group = cfg.group;
          SupplementaryGroups = config.services.redis.servers.yamtrack.group;
        };
        serviceDependencies = {
          requires = [ "yamtrack-migrate.service" ];
          wantedBy = [ "yamtrack.target" ];
          partOf = [ "yamtrack.target" ];
          after = [
            "network.target"
            "yamtrack-migrate.service"
          ];
        };
      in
      {
        yamtrack-migrate = {
          environment = cfg.environment;
          serviceConfig = commonConfig // {
            Type = "oneshot";
            ExecStart = lib.getExe' cfg.package "yamtrack-migrate";
          };
        };

        yamtrack-main = serviceDependencies // {
          description = "Yamtrack";
          environment = cfg.environment;
          serviceConfig = commonConfig // {
            ExecStart = lib.getExe' cfg.package "yamtrack";
          };
        };

        yamtrack-celery = serviceDependencies // {
          environment = cfg.environment;
          serviceConfig = commonConfig // {
            ExecStart = lib.getExe' cfg.package "yamtrack-celery";
          };
        };

        yamtrack-celery-beat = serviceDependencies // {
          environment = cfg.environment;
          serviceConfig = commonConfig // {
            ExecStart = lib.getExe' cfg.package "yamtrack-celery-beat";
          };
        };
      };
  };

  meta = {
    maintainers = with lib.maintainers; [ dav-wolff ];
  };
}
