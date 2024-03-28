{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.gancio;
  isLocalHostName =
    cfg.hostName == "localhost"
    || (lib.hasSuffix ".local" cfg.hostName)
    || (lib.hasSuffix ".localhost" cfg.hostName);
  json = pkgs.formats.json { };
in
{
  options.services.gancio = {
    enable = lib.mkEnableOption (
      lib.mdDoc ''
        A shared agenda for local communities.
        The first user to register, using `admin` as email, will be the initial gancio instance administrator.
      ''
    );

    package = lib.mkPackageOption pkgs "gancio" { };

    plugins = lib.mkOption {
      type = with lib.types; listOf package;
      example = lib.literalExpression "[ pkgs.gancioPlugins.telegram-bridge ]";
      description = lib.mdDoc ''
        Paths of gancio plugins to activate (linked under $WorkingDirectory/plugins/).
      '';
    };

    user = lib.mkOption {
      type = lib.types.str;
      description = lib.mdDoc "The user (and database name) used to run the gancio server";
      default = "gancio";
    };

    hostName = lib.mkOption {
      type = lib.types.str;
      default = "localhost";
      description = lib.mdDoc "Web hostname to serve gancio on (nginx)";
    };

    enableACME = lib.mkOption {
      type = lib.types.bool;
      default = !isLocalHostName;
      defaultText = lib.literalMD ''
        `true`, unless {option}`services.gancio.hostName`
         is set to localhost or use a local domain.
      '';
      description = lib.mdDoc ''
        Whether an ACME certificate should be used to secure
        connections to the server.
      '';
    };

    listenHost = lib.mkOption {
      type = lib.types.str;
      default = "localhost";
      example = "::";
      description = lib.mdDoc ''
        The address (IPv4, IPv6 or DNS) for the gancio server to listen on.
      '';
    };

    listenPort = lib.mkOption {
      type = lib.types.int;
      default = 13120;
      description = lib.mdDoc ''
        Port number of the gancio server to listen on.
      '';
    };

    dbDialect = lib.mkOption {
      type = lib.types.enum [
        "sqlite"
        "postgres"
      ];
      default = "sqlite";
      description = lib.mdDoc ''
        The database dialect to use
      '';
    };

    logLevel = lib.mkOption {
      description = lib.mdDoc "Gancio log level.";
      type = lib.types.enum [
        "debug"
        "info"
        "warning"
        "error"
      ];
      default = "info";
    };

    extraSettings = lib.mkOption {
      type = json.type;
      default = { };
      description = lib.mdDoc ''
        Extra configuration settings.
      '';
      example = lib.literalExpression ''
        {
          db = {
            dialectOptions.autoJsonMap = false;
          };
        }
      '';
    };

    userLocale = lib.mkOption {
      type = with lib.types; attrsOf (attrsOf (attrsOf str));
      default = { };
      example = lib.literalExpression ''
        {
          en = {
            register = {
              description = "My new registration page description";
            };
          };
        }
      '';
      description = lib.mdDoc ''
        Override default locales within gancio.
        See [https://framagit.org/les/gancio/tree/master/locales](default languages and locales).
      '';
    };

    nginx = lib.mkOption {
      type = lib.types.submodule (
        lib.recursiveUpdate (import ../web-servers/nginx/vhost-options.nix { inherit config lib; }) {
          options.forceSSL.default = cfg.enableACME;
          options.forceSSL.defaultText = lib.literalMD ''
            Default to {option}`services.gancio.enableACME`
          '';
          options.enableACME.default = cfg.enableACME;
          options.enableACME.defaultText = lib.literalMD ''
            Default to {option}`services.gancio.enableACME`
          '';
        }
      );
      default = { };
      example = lib.literalExpression ''
        {
          serverAliases = [ "gancio.''${config.networking.domain}" ];
        }
      '';
      description = lib.mdDoc "Extra configuration for the nginx virtual host of gancio.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    users.users.${cfg.user} = {
      isSystemUser = true;
      group = cfg.user;
      home = "/var/lib/${cfg.user}";
    };
    users.groups.${cfg.user} = { };

    systemd.services.gancio =
      let
        configFile = json.generate "gancio-config.json" (
          lib.recursiveUpdate cfg.extraSettings {
            baseurl = "http${
              lib.optionalString config.services.nginx.virtualHosts."${cfg.hostName}".enableACME "s"
            }://${cfg.hostName}";
            server = {
              host = cfg.listenHost;
              port = cfg.listenPort;
            };
            log_level = cfg.logLevel;
            log_path = "/var/log/${cfg.user}";
            db =
              {
                dialect = cfg.dbDialect;
              }
              // lib.optionalAttrs (cfg.dbDialect == "sqlite") { storage = "/var/lib/${cfg.user}/db.sqlite"; }
              // lib.optionalAttrs (cfg.dbDialect == "postgres") {
                host = "/run/postgresql";
                database = cfg.user;
              };
            user_locale = "/var/lib/${cfg.user}/user_locale";
            upload_path = "/var/lib/${cfg.user}/uploads";
          }
        );
      in
      {
        description = "Gancio server";
        documentation = [ "https://gancio.org/" ];

        wantedBy = [ "multi-user.target" ];
        after =
          [ "network.target" ]
          ++ lib.optional (cfg.dbDialect == "postgres") "postgresql.service"
          ++ lib.optional (cfg.dbDialect == "mariadb") "mysql.service";

        environment = {
          NODE_ENV = "production";
        };

        preStart = ''
          ln -sf ${configFile} config.json

          rm -rf user_locale
          mkdir -p user_locale
          ${lib.concatStringsSep "\n" (
            lib.mapAttrsToList
              (l: c: "ln -sf ${json.generate "gancio-${l}-locale.json" c} user_locale/${l}.json")
              cfg.userLocale
          )}

          rm -rf plugins
          mkdir -p plugins
          ${lib.concatMapStringsSep "\n" (p: "ln -sf ${p} plugins/") cfg.plugins}
        '';

        serviceConfig = {
          ExecStart = "${cfg.package}/bin/gancio start";
          StateDirectory = cfg.user;
          WorkingDirectory = "/var/lib/${cfg.user}";
          LogsDirectory = cfg.user;
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
