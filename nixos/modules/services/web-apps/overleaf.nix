{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.overleaf;
  ferret = pkgs.ferretdb.overrideAttrs (final: prev: {
    patches = [ ./fields.patch ];
  });
in

{
  meta.maintainers = with maintainers; [ julienmalka camillemndn ];

  options.services.overleaf = {
    enable = mkEnableOption (mdDoc ''Overleaf'');

    hostname = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "overleaf.org";
      description = mdDoc ''This enable a default nginx reverse proxy configuration.'';
    };

    enableRedis = mkOption {
      type = types.bool;
      default = true;
      description = mdDoc ''Redis'';
    };

    mongodbType = mkOption {
      type = types.str;
      default = "mongodb";
      example = "ferretdb";
      description = mdDoc ''The type of MongoDB service to enable. One of "mongodb", "ferretdb" or "none".'';
    };

    texlivePackage = mkOption {
      type = types.package;
      default = pkgs.texlive.combined.scheme-basic;
      defaultText = literalExpression "pkgs.textlive.combined.scheme-basic";
      example = literalExpression "pkgs.texlive.combined.scheme-full";
      description = mdDoc ''
        The package for TeX Live. See
        <https://search.nixos.org/packages?query=texlive.combined>
        for available options.
      '';
    };

    settings = mkOption {
      type = types.submodule { freeformType = with types; attrsOf str; };
      default = { };
      example = {
        OVERLEAF_REDIS_HOST = "localhost";
        OVERLEAF_REDIS_PORT = "6379";
        WEB_HOST = "localhost";
        WEB_PORT = "3032";
        GRACEFUL_SHUTDOWN_DELAY = "0";
        OVERLEAF_SITE_URL = "https://verso.saumon.network";
        OVERLEAF_ADMIN_EMAIL = "postmaster@mondon.me";
        OVERLEAF_SITE_LANGUAGE = "fr";
        OVERLEAF_APP_NAME = "Verso, powered by SaumonNetwork";
        OVERLEAF_EMAIL_FROM_ADDRESS = "postmaster@overleaf.nix";
        OVERLEAF_EMAIL_SMTP_HOST = "mail.overleaf.nix";
        OVERLEAF_EMAIL_SMTP_PORT = "587";
        OVERLEAF_EMAIL_SMTP_SECURE = "true";
        OVERLEAF_EMAIL_SMTP_USER = "postmaster";
        ADMIN_PRIVILEGE_AVAILABLE = "true";
      };
      description = mdDoc ''
        Additional configuration for Overleaf, see
        <https://github.com/overleaf/overleaf/blob/main/server-ce/config/settings.js>
        for supported values.
      '';
    };

    secrets = mkOption {
      type = types.submodule { freeformType = with types; attrsOf str; };
      default = { };
      example = {
        WEB_API_PASSWORD = "";
        OVERLEAF_REDIS_PASS = "";
        OVERLEAF_SESSION_SECRET = "/run/secrets/overleaf_session";
        STAGING_PASSWORD_FILE = "";
        OVERLEAF_EMAIL_SMTP_PASS = "";
      };
      description = mdDoc ''
        Secrets for Overleaf, see
        <https://github.com/overleaf/overleaf/blob/main/server-ce/config/settings.js>
        for supported values.
      '';
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      services.overleaf.settings = {
        NODE_ENV = "production";
        OVERLEAF_CONFIG = "${pkgs.overleaf}/share/server-ce/config/settings.js";
        DATA_DIR = mkDefault "/var/lib/overleaf";
        # OVERLEAF_MONGO_URL = mkDefault "mongodb://overleaf@%2Ftmp%2Fmongodb-27017.sock/overleaf";
        OVERLEAF_MONGO_URL = mkDefault "mongodb://localhost:27017/overleaf";
        OVERLEAF_REDIS_PATH = mkDefault "/run/redis-overleaf/redis.sock";
        WEB_PORT = mkDefault "3032";
        WEB_API_USER = mkDefault "overleaf";
        GRACEFUL_SHUTDOWN_DELAY = mkDefault "0";
        OVERLEAF_FPH_DISPLAY_NEW_PROJECTS = mkDefault "true";
      };

      systemd.services =
        let activateServices = service: {
          "overleaf-${service}" = {
            description = "Overleaf ${service}";
            wantedBy = [ "multi-user.target" ];
            environment = cfg.settings;
            path = [ cfg.texlivePackage ];
            serviceConfig = {
              Type = "simple";
              ExecStart = "${pkgs.overleaf}/bin/overleaf-${service}";
              StateDirectory = "overleaf";
              WorkingDirectory = "/var/lib/overleaf";
              User = "overleaf";
              LoadCredentials = mapAttrsToList (key: value: "${key}:${value}") cfg.secrets;
            };
          };
        };
        in
        mkMerge (map activateServices [
          "chat"
          "clsi"
          "contacts"
          "docstore"
          "document-updater"
          "filestore"
          "notifications"
          "project-history"
          "real-time"
          "spelling"
          "track-changes"
          "web"
        ]);

      services.nginx = mkIf (isString cfg.hostname) {
        enable = true;
        recommendedOptimisation = mkDefault true;
        recommendedGzipSettings = mkDefault true;

        virtualHosts."${cfg.hostname}" = {
          locations."/" = {
            proxyPass = "http://localhost:${cfg.settings.WEB_PORT}";
            proxyWebsockets = true;
          };
          locations."/socket.io" = {
            proxyPass = "http://localhost:3026";
            proxyWebsockets = true;
            extraConfig = ''
              proxy_read_timeout 10m;
              proxy_send_timeout 10m;
            '';
          };
        };
      };

      services.redis.servers.overleaf = mkIf cfg.enableRedis {
        enable = true;
        user = "overleaf";
        port = 0;
      };

      services.mongodb = mkIf (cfg.mongodbType == "mongodb") {
        enable = true;
        package = pkgs.mongodb-4_2;
        user = "overleaf";
      };
    }
    (mkIf (cfg.mongodbType == "ferretdb") {
      systemd.services.ferretdb = {
        description = "FerretDB";
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${ferret}/bin/ferretdb --postgresql-url=\"postgres://localhost/ferretdb?host=/run/postgresql\"";
          StateDirectory = "ferretdb";
          WorkingDirectory = "/var/lib/ferretdb";
          User = "ferretdb";
        };
      };
      systemd.services.postgresql.environment.LC_ALL = "en_US.UTF-8";

      users.users.ferretdb = {
        isSystemUser = true;
        group = "ferretdb";
        home = "/var/lib/ferretdb";
        createHome = true;
      };

      users.groups.ferretdb = { };

      services.postgresql = {
        enable = true;
        ensureDatabases = [ "ferretdb" ];
        ensureUsers = [{
          name = "ferretdb";
          ensurePermissions."DATABASE ferretdb" = "ALL PRIVILEGES";
        }];
      };
    })
  ]);
}
