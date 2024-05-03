{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.gancio;
  json = pkgs.formats.json { };
in
{
  options.services.gancio = {
    enable = lib.mkEnableOption "Gancio, a shared agenda for local communities";

    package = lib.mkPackageOption pkgs "gancio" { };

    plugins = lib.mkOption {
      type = with lib.types; listOf package;
      example = lib.literalExpression "[ pkgs.gancioPlugins.telegram-bridge ]";
      description = ''
        Paths of gancio plugins to activate (linked under $WorkingDirectory/plugins/).
      '';
    };

    user = lib.mkOption {
      type = lib.types.str;
      description = "The user (and database name) used to run the gancio server";
      default = "gancio";
    };

    hostName = lib.mkOption {
      type = lib.types.str;
      default = "localhost";
      description = "The domain under which gancio will be reachable via nginx";
    };

    listenHost = lib.mkOption {
      type = lib.types.str;
      default = "localhost";
      example = "::";
      description = ''
        The address (IPv4, IPv6 or DNS) for the gancio server to listen on.
      '';
    };

    listenPort = lib.mkOption {
      type = lib.types.port;
      default = 13120;
      description = ''
        Port number of the gancio server to listen on.
      '';
    };

    dbDialect = lib.mkOption {
      type = lib.types.enum [
        "sqlite"
        "postgres"
      ];
      default = "sqlite";
      description = ''
        The database dialect to use
      '';
    };

    logLevel = lib.mkOption {
      description = "Gancio log level.";
      type = lib.types.enum [
        "debug"
        "info"
        "warning"
        "error"
      ];
      default = "info";
    };

    settings = lib.mkOption rec {
      type = json.type;
      apply = lib.recursiveUpdate default;
      default = {
        baseurl = "http${
          lib.optionalString config.services.nginx.virtualHosts."${cfg.hostName}".enableACME "s"
        }://${cfg.hostName}";
        server = {
          host = cfg.listenHost;
          port = cfg.listenPort;
        };
        log_level = cfg.logLevel;
        log_path = "/var/log/gancio";
        db =
          {
            dialect = cfg.dbDialect;
          }
          // lib.optionalAttrs (cfg.dbDialect == "sqlite") { storage = "/var/lib/gancio/db.sqlite"; }
          // lib.optionalAttrs (cfg.dbDialect == "postgres") {
            host = "/run/postgresql";
            database = cfg.user;
          };
        user_locale = "/var/lib/gancio/user_locale";
        upload_path = "/var/lib/gancio/uploads";
      };
      defaultText = lib.literalExpression ''
        {
          baseurl = "http(s)://''${cfg.hostName}";
          server = {
            host = cfg.listenHost;
            port = cfg.listenPort;
          };
          log_level = cfg.logLevel;
          log_path = "/var/log/gancio";
          db.dialect = cfg.dbDialect;
          user_locale = "/var/lib/gancio/user_locale";
          upload_path = "/var/lib/gancio/uploads";
        }
      '';
      example = {
        db = {
          dialectOptions.autoJsonMap = false;
        };
      };
      description = ''
        Configuration for Gancio, see <https://gancio.org/install/config> for supported values.
      '';
    };

    userLocale = lib.mkOption {
      type = with lib.types; attrsOf (attrsOf (attrsOf str));
      default = { };
      example = {
        en.register.description = "My new registration page description";
      };
      description = ''
        Override default locales within gancio.
        See [https://framagit.org/les/gancio/tree/master/locales](default languages and locales).
      '';
    };

    nginx = lib.mkOption {
      type = lib.types.submodule (import ../web-servers/nginx/vhost-options.nix { inherit config lib; });
      default = { };
      example = {
        enableACME = true;
        forceSSL = true;
      };
      description = "Extra configuration for the nginx virtual host of gancio.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    users.users.${cfg.user} = {
      isSystemUser = true;
      group = cfg.user;
      home = "/var/lib/gancio";
    };
    users.groups.${cfg.user} = { };

    systemd.tmpfiles.settings."10-gancio" =
      let
        rules = {
          mode = "0755";
          user = cfg.user;
          group = config.users.users.${cfg.user}.group;
        };
      in
      {
        "/var/lib/gancio/user_locale".d = rules;
        "/var/lib/gancio/plugins".d = rules;
      };

    systemd.services.gancio =
      let
        configFile = json.generate "gancio-config.json" cfg.settings;
      in
      {
        description = "Gancio server";
        documentation = [ "https://gancio.org/" ];

        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ] ++ lib.optional (cfg.dbDialect == "postgres") "postgresql.service";

        environment = {
          NODE_ENV = "production";
        };

        preStart = ''
          ln -sf ${configFile} config.json

          rm -f user_locale/*
          ${lib.concatStringsSep "\n" (
            lib.mapAttrsToList (
              l: c: "ln -sf ${json.generate "gancio-${l}-locale.json" c} user_locale/${l}.json"
            ) cfg.userLocale
          )}

          rm -f plugins/*
          ${lib.concatMapStringsSep "\n" (p: "ln -sf ${p} plugins/") cfg.plugins}
        '';

        serviceConfig = {
          ExecStart = "${lib.getExe cfg.package} start";
          StateDirectory = "gancio";
          WorkingDirectory = "/var/lib/gancio";
          LogsDirectory = "gancio";
          User = cfg.user;
          # hardening
          RestrictRealtime = true;
          RestrictNamespaces = true;
          LockPersonality = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectKernelLogs = true;
          ProtectControlGroups = true;
          ProtectClock = true;
          RestrictSUIDSGID = true;
          SystemCallArchitectures = "native";
          CapabilityBoundingSet = "";
          ProtectProc = "invisible";
        };
      };

    services.postgresql = lib.mkIf (cfg.dbDialect == "postgres") {
      enable = true;
      ensureDatabases = [ cfg.user ];
      ensureUsers = [
        {
          name = cfg.user;
          ensureDBOwnership = true;
        }
      ];
    };

    services.nginx = {
      enable = true;
      virtualHosts."${cfg.hostName}" = lib.mkMerge [
        cfg.nginx
        {
          locations = {
            "/" = {
              index = "index.html";
              tryFiles = "$uri $uri @proxy";
            };
            "@proxy" = {
              proxyWebsockets = true;
              proxyPass = "http://${cfg.listenHost}:${toString cfg.listenPort}";
              recommendedProxySettings = true;
            };
          };
        }
      ];
    };
  };
}
