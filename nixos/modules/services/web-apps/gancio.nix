{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.gancio;
  settingsFormat = pkgs.formats.json { };
  inherit (lib)
    mkEnableOption
    mkPackageOption
    mkOption
    types
    literalExpression
    mkIf
    optional
    mapAttrsToList
    concatStringsSep
    concatMapStringsSep
    getExe
    mkMerge
    mkDefault
    ;
in
{
  options.services.gancio = {
    enable = mkEnableOption "Gancio, a shared agenda for local communities";

    package = mkPackageOption pkgs "gancio" { };

    plugins = mkOption {
      type = with types; listOf package;
      default = [ ];
      example = literalExpression "[ pkgs.gancioPlugins.telegram-bridge ]";
      description = ''
        Paths of gancio plugins to activate (linked under $WorkingDirectory/plugins/).
      '';
    };

    user = mkOption {
      type = types.str;
      description = "The user (and PostgreSQL database name) used to run the gancio server";
      default = "gancio";
    };

    settings = mkOption rec {
      type = types.submodule {
        freeformType = settingsFormat.type;
        options = {
          hostname = mkOption {
            type = types.str;
            description = "The domain name under which the server is reachable.";
          };
          baseurl = mkOption {
            type = types.str;
            default = "http${
              lib.optionalString config.services.nginx.virtualHosts."${cfg.settings.hostname}".enableACME "s"
            }://${cfg.settings.hostname}";
            defaultText = lib.literalExpression ''"https://''${config.services.gancio.settings.hostname}"'';
            example = "https://demo.gancio.org/gancio";
            description = "The full URL under which the server is reachable.";
          };
          server = {
            socket = mkOption {
              type = types.path;
              readOnly = true;
              default = "/run/gancio/socket";
              description = ''
                The unix socket for the gancio server to listen on.
              '';
            };
          };
          db = {
            dialect = mkOption {
              type = types.enum [
                "sqlite"
                "postgres"
              ];
              default = "sqlite";
              description = ''
                The database dialect to use
              '';
            };
            storage = mkOption {
              description = ''
                Location for the SQLite database.
              '';
              readOnly = true;
              type = types.nullOr types.str;
              default = if cfg.settings.db.dialect == "sqlite" then "/var/lib/gancio/db.sqlite" else null;
              defaultText = ''if config.services.gancio.settings.db.dialect == "sqlite" then "/var/lib/gancio/db.sqlite" else null'';
            };
            host = mkOption {
              description = ''
                Connection string for the PostgreSQL database
              '';
              readOnly = true;
              type = types.nullOr types.str;
              default = if cfg.settings.db.dialect == "postgres" then "/run/postgresql" else null;
              defaultText = ''if config.services.gancio.settings.db.dialect == "postgres" then "/run/postgresql" else null'';
            };
            database = mkOption {
              description = ''
                Name of the PostgreSQL database
              '';
              readOnly = true;
              type = types.nullOr types.str;
              default = if cfg.settings.db.dialect == "postgres" then cfg.user else null;
              defaultText = ''if config.services.gancio.settings.db.dialect == "postgres" then cfg.user else null'';
            };
          };
          log_level = mkOption {
            description = "Gancio log level.";
            type = types.enum [
              "debug"
              "info"
              "warning"
              "error"
            ];
            default = "info";
          };
          # FIXME upstream proper journald logging
          log_path = mkOption {
            description = "Directory Gancio logs into";
            readOnly = true;
            type = types.str;
            default = "/var/log/gancio";
          };
        };
      };
      description = ''
        Configuration for Gancio, see <https://gancio.org/install/config> for supported values.
      '';
    };

    userLocale = mkOption {
      type = with types; attrsOf (attrsOf (attrsOf str));
      default = { };
      example = {
        en.register.description = "My new registration page description";
      };
      description = ''
        Override default locales within gancio.
        See [default languages and locales](https://framagit.org/les/gancio/tree/master/locales).
      '';
    };

    nginx = mkOption {
      type = types.submodule (
        lib.recursiveUpdate (import ../web-servers/nginx/vhost-options.nix { inherit config lib; }) {
          # enable encryption by default,
          # as sensitive login credentials should not be transmitted in clear text.
          options.forceSSL.default = true;
          options.enableACME.default = true;
        }
      );
      default = { };
      example = {
        enableACME = false;
        forceSSL = false;
      };
      description = "Extra configuration for the nginx virtual host of gancio.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      (pkgs.runCommand "gancio" { } ''
        mkdir -p $out/bin
        echo '#!${pkgs.runtimeShell}
        cd /var/lib/gancio/
        sudo=exec
        if [[ "$USER" != ${cfg.user} ]]; then
          sudo="exec /run/wrappers/bin/sudo -u ${cfg.user}"
        fi
        $sudo ${lib.getExe cfg.package} "''${@:--help}"
        ' > $out/bin/gancio
        chmod +x $out/bin/gancio
      '')
    ];

    users.users.gancio = lib.mkIf (cfg.user == "gancio") {
      isSystemUser = true;
      group = cfg.user;
      home = "/var/lib/gancio";
    };
    users.groups.gancio = lib.mkIf (cfg.user == "gancio") { };

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
        configFile = settingsFormat.generate "gancio-config.json" cfg.settings;
      in
      {
        description = "Gancio server";
        documentation = [ "https://gancio.org/" ];

        wantedBy = [ "multi-user.target" ];
        after = [
          "network.target"
        ]
        ++ optional (cfg.settings.db.dialect == "postgres") "postgresql.target";

        environment = {
          NODE_ENV = "production";
        };

        path = [
          # required for sendmail
          "/run/wrappers"
        ];

        preStart = ''
          # We need this so the gancio executable run by the user finds the right settings.
          ln -sf ${configFile} config.json

          rm -f user_locale/*
          ${concatStringsSep "\n" (
            mapAttrsToList (
              l: c: "ln -sf ${settingsFormat.generate "gancio-${l}-locale.json" c} user_locale/${l}.json"
            ) cfg.userLocale
          )}

          rm -f plugins/*
          ${concatMapStringsSep "\n" (p: "ln -sf ${p} plugins/") cfg.plugins}
        '';

        serviceConfig = {
          ExecStart = "${getExe cfg.package} start ${configFile}";
          # set umask so that nginx can write to the server socket
          # FIXME: upstream socket permission configuration in Nuxt
          UMask = "0002";
          RuntimeDirectory = "gancio";
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

    services.postgresql = mkIf (cfg.settings.db.dialect == "postgres") {
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
      virtualHosts."${cfg.settings.hostname}" = mkMerge [
        cfg.nginx
        {
          locations = {
            "/" = {
              index = "index.html";
              tryFiles = "$uri $uri @proxy";
            };
            "@proxy" = {
              proxyWebsockets = true;
              proxyPass = "http://unix:${cfg.settings.server.socket}";
              recommendedProxySettings = true;
            };
          };
        }
      ];
    };
    # for nginx to access gancio socket
    users.users."${config.services.nginx.user}" = lib.mkIf (config.services.nginx.enable) {
      extraGroups = [ config.users.users.${cfg.user}.group ];
    };
  };
}
