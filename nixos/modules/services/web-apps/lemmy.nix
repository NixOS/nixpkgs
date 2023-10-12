{ lib, pkgs, config, utils, ... }:
with lib;
let
  cfg = config.services.lemmy;
  settingsFormat = pkgs.formats.json { };
in
{
  meta.maintainers = with maintainers; [ happysalada ];
  meta.doc = ./lemmy.md;

  imports = [
    (mkRemovedOptionModule [ "services" "lemmy" "jwtSecretPath" ] "As of v0.13.0, Lemmy auto-generates the JWT secret.")
  ];

  options.services.lemmy = {

    enable = mkEnableOption (lib.mdDoc "lemmy a federated alternative to reddit in rust");

    server = {
      package = mkPackageOptionMD pkgs "lemmy-server" {};
    };

    ui = {
      package = mkPackageOptionMD pkgs "lemmy-ui" {};

      port = mkOption {
        type = types.port;
        default = 1234;
        description = lib.mdDoc "Port where lemmy-ui should listen for incoming requests.";
      };
    };

    caddy.enable = mkEnableOption (lib.mdDoc "exposing lemmy with the caddy reverse proxy");
    nginx.enable = mkEnableOption (lib.mdDoc "exposing lemmy with the nginx reverse proxy");

    database = {
      createLocally = mkEnableOption (lib.mdDoc "creation of database on the instance");

      uri = mkOption {
        type = with types; nullOr str;
        default = null;
        description = lib.mdDoc "The connection URI to use. Takes priority over the configuration file if set.";
      };

      uriFile = mkOption {
        type = with types; nullOr path;
        default = null;
        description = lib.mdDoc "File which contains the database uri.";
      };
    };

    pictrsApiKeyFile = mkOption {
      type = with types; nullOr path;
      default = null;
      description = lib.mdDoc "File which contains the value of `pictrs.api_key`.";
    };

    smtpPasswordFile = mkOption {
      type = with types; nullOr path;
      default = null;
      description = lib.mdDoc "File which contains the value of `email.smtp_password`.";
    };

    adminPasswordFile = mkOption {
      type = with types; nullOr path;
      default = null;
      description = lib.mdDoc "File which contains the value of `setup.admin_password`.";
    };

    settings = mkOption {
      default = { };
      description = lib.mdDoc "Lemmy configuration";

      type = types.submodule {
        freeformType = settingsFormat.type;

        options.hostname = mkOption {
          type = types.str;
          default = null;
          description = lib.mdDoc "The domain name of your instance (eg 'lemmy.ml').";
        };

        options.port = mkOption {
          type = types.port;
          default = 8536;
          description = lib.mdDoc "Port where lemmy should listen for incoming requests.";
        };

        options.captcha = {
          enabled = mkOption {
            type = types.bool;
            default = true;
            description = lib.mdDoc "Enable Captcha.";
          };
          difficulty = mkOption {
            type = types.enum [ "easy" "medium" "hard" ];
            default = "medium";
            description = lib.mdDoc "The difficultly of the captcha to solve.";
          };
        };
      };
    };
  };

  config =
    let
      secretOptions = {
        pictrsApiKeyFile = { setting = [ "pictrs" "api_key" ]; path = cfg.pictrsApiKeyFile; };
        smtpPasswordFile = { setting = [ "email" "smtp_password" ]; path = cfg.smtpPasswordFile; };
        adminPasswordFile = { setting = [ "setup" "admin_password" ]; path = cfg.adminPasswordFile; };
        uriFile = { setting = [ "database" "uri" ]; path = cfg.database.uriFile; };
      };
      secrets = lib.filterAttrs (option: data: data.path != null) secretOptions;
    in
    lib.mkIf cfg.enable {
      services.lemmy.settings = lib.attrsets.recursiveUpdate (mapAttrs (name: mkDefault)
        {
          bind = "127.0.0.1";
          tls_enabled = true;
          pictrs = {
            url = with config.services.pict-rs; "http://${address}:${toString port}";
          };
          actor_name_max_length = 20;

          rate_limit.message = 180;
          rate_limit.message_per_second = 60;
          rate_limit.post = 6;
          rate_limit.post_per_second = 600;
          rate_limit.register = 3;
          rate_limit.register_per_second = 3600;
          rate_limit.image = 6;
          rate_limit.image_per_second = 3600;
        } // {
          database = mapAttrs (name: mkDefault) {
            user = "lemmy";
            host = "/run/postgresql";
            port = 5432;
            database = "lemmy";
            pool_size = 5;
          };
        }) (lib.foldlAttrs (acc: option: data: acc // lib.setAttrByPath data.setting { _secret = option; }) {} secrets);
        # the option name is the id of the credential loaded by LoadCredential

      services.postgresql = mkIf cfg.database.createLocally {
        enable = true;
        ensureDatabases = [ cfg.settings.database.database ];
        ensureUsers = [{
          name = cfg.settings.database.user;
          ensurePermissions."DATABASE ${cfg.settings.database.database}" = "ALL PRIVILEGES";
        }];
      };

      services.pict-rs.enable = true;

      services.caddy = mkIf cfg.caddy.enable {
        enable = mkDefault true;
        virtualHosts."${cfg.settings.hostname}" = {
          extraConfig = ''
            handle_path /static/* {
              root * ${cfg.ui.package}/dist
              file_server
            }
            handle_path /static/${cfg.ui.package.passthru.commit_sha}/* {
              root * ${cfg.ui.package}/dist
              file_server
            }
            @for_backend {
              path /api/* /pictrs/* /feeds/* /nodeinfo/*
            }
            handle @for_backend {
              reverse_proxy 127.0.0.1:${toString cfg.settings.port}
            }
            @post {
              method POST
            }
            handle @post {
              reverse_proxy 127.0.0.1:${toString cfg.settings.port}
            }
            @jsonld {
              header Accept "application/activity+json"
              header Accept "application/ld+json; profile=\"https://www.w3.org/ns/activitystreams\""
            }
            handle @jsonld {
              reverse_proxy 127.0.0.1:${toString cfg.settings.port}
            }
            handle {
              reverse_proxy 127.0.0.1:${toString cfg.ui.port}
            }
          '';
        };
      };

      services.nginx = mkIf cfg.nginx.enable {
        enable = mkDefault true;
        virtualHosts."${cfg.settings.hostname}".locations = let
          ui = "http://127.0.0.1:${toString cfg.ui.port}";
          backend = "http://127.0.0.1:${toString cfg.settings.port}";
        in {
          "~ ^/(api|pictrs|feeds|nodeinfo|.well-known)" = {
            # backend requests
            proxyPass = backend;
            proxyWebsockets = true;
            recommendedProxySettings = true;
          };
          "/" = {
            # mixed frontend and backend requests, based on the request headers
            proxyPass = "$proxpass";
            recommendedProxySettings = true;
            extraConfig = ''
              set $proxpass "${ui}";
              if ($http_accept = "application/activity+json") {
                set $proxpass "${backend}";
              }
              if ($http_accept = "application/ld+json; profile=\"https://www.w3.org/ns/activitystreams\"") {
                set $proxpass "${backend}";
              }
              if ($request_method = POST) {
                set $proxpass "${backend}";
              }

              # Cuts off the trailing slash on URLs to make them valid
              rewrite ^(.+)/+$ $1 permanent;
            '';
          };
        };
      };

      assertions = [
        {
          assertion = cfg.database.createLocally -> cfg.settings.database.host == "localhost" || cfg.settings.database.host == "/run/postgresql";
          message = "if you want to create the database locally, you need to use a local database";
        }
        {
          assertion = (!(hasAttrByPath ["federation"] cfg.settings)) && (!(hasAttrByPath ["federation" "enabled"] cfg.settings));
          message = "`services.lemmy.settings.federation` was removed in 0.17.0 and no longer has any effect";
        }
        {
          assertion = cfg.database.uriFile != null -> cfg.database.uri == null && !cfg.database.createLocally;
          message = "specifying a database uri while also specifying a database uri file is not allowed";
        }
      ];

      systemd.services.lemmy = let
        substitutedConfig = "/run/lemmy/config.hjson";
      in {
        description = "Lemmy server";

        environment = {
          LEMMY_CONFIG_LOCATION = if secrets == {} then settingsFormat.generate "config.hjson" cfg.settings else substitutedConfig;
          LEMMY_DATABASE_URL = if cfg.database.uri != null then cfg.database.uri else (mkIf (cfg.database.createLocally) "postgres:///lemmy?host=/run/postgresql&user=lemmy");
        };

        documentation = [
          "https://join-lemmy.org/docs/en/admins/from_scratch.html"
          "https://join-lemmy.org/docs/en/"
        ];

        wantedBy = [ "multi-user.target" ];

        after = [ "pict-rs.service" ] ++ lib.optionals cfg.database.createLocally [ "postgresql.service" ];

        requires = lib.optionals cfg.database.createLocally [ "postgresql.service" ];

        # substitute secrets and prevent others from reading the result
        # if somehow $CREDENTIALS_DIRECTORY is not set we fail
        preStart = mkIf (secrets != {}) ''
          set -u
          umask u=rw,g=,o=
          cd "$CREDENTIALS_DIRECTORY"
          ${utils.genJqSecretsReplacementSnippet cfg.settings substitutedConfig}
        '';

        serviceConfig = {
          DynamicUser = true;
          RuntimeDirectory = "lemmy";
          ExecStart = "${cfg.server.package}/bin/lemmy_server";
          LoadCredential = lib.foldlAttrs (acc: option: data: acc ++ [ "${option}:${toString data.path}" ]) [] secrets;
          PrivateTmp = true;
          MemoryDenyWriteExecute = true;
          NoNewPrivileges = true;
        };
      };

      systemd.services.lemmy-ui = {
        description = "Lemmy ui";

        environment = {
          LEMMY_UI_HOST = "127.0.0.1:${toString cfg.ui.port}";
          LEMMY_UI_LEMMY_INTERNAL_HOST = "127.0.0.1:${toString cfg.settings.port}";
          LEMMY_UI_LEMMY_EXTERNAL_HOST = cfg.settings.hostname;
          LEMMY_UI_HTTPS = "false";
          NODE_ENV = "production";
        };

        documentation = [
          "https://join-lemmy.org/docs/en/admins/from_scratch.html"
          "https://join-lemmy.org/docs/en/"
        ];

        wantedBy = [ "multi-user.target" ];

        after = [ "lemmy.service" ];

        requires = [ "lemmy.service" ];

        serviceConfig = {
          DynamicUser = true;
          WorkingDirectory = "${cfg.ui.package}";
          ExecStart = "${pkgs.nodejs}/bin/node ${cfg.ui.package}/dist/js/server.js";
        };
      };
    };

}
