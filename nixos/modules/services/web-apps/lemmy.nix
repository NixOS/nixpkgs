{ lib, pkgs, config, ... }:
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

    ui = {
      port = mkOption {
        type = types.port;
        default = 1234;
        description = lib.mdDoc "Port where lemmy-ui should listen for incoming requests.";
      };
    };

    caddy.enable = mkEnableOption (lib.mdDoc "exposing lemmy with the caddy reverse proxy");

    database.createLocally = mkEnableOption (lib.mdDoc "creation of database on the instance");

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

        options.federation = {
          enabled = mkEnableOption (lib.mdDoc "activitypub federation");
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
    lib.mkIf cfg.enable {
      services.lemmy.settings = (mapAttrs (name: mkDefault)
        {
          bind = "127.0.0.1";
          tls_enabled = true;
          pictrs_url = with config.services.pict-rs; "http://${address}:${toString port}";
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
      });

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
              root * ${pkgs.lemmy-ui}/dist
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

      assertions = [{
        assertion = cfg.database.createLocally -> cfg.settings.database.host == "localhost" || cfg.settings.database.host == "/run/postgresql";
        message = "if you want to create the database locally, you need to use a local database";
      }];

      systemd.services.lemmy = {
        description = "Lemmy server";

        environment = {
          LEMMY_CONFIG_LOCATION = "/run/lemmy/config.hjson";

          # Verify how this is used, and don't put the password in the nix store
          LEMMY_DATABASE_URL = with cfg.settings.database;"postgres:///${database}?host=${host}";
        };

        documentation = [
          "https://join-lemmy.org/docs/en/admins/from_scratch.html"
          "https://join-lemmy.org/docs/en/"
        ];

        wantedBy = [ "multi-user.target" ];

        after = [ "pict-rs.service" ] ++ lib.optionals cfg.database.createLocally [ "postgresql.service" ];

        requires = lib.optionals cfg.database.createLocally [ "postgresql.service" ];

        serviceConfig = {
          DynamicUser = true;
          RuntimeDirectory = "lemmy";
          ExecStartPre = "${pkgs.coreutils}/bin/install -m 600 ${settingsFormat.generate "config.hjson" cfg.settings} /run/lemmy/config.hjson";
          ExecStart = "${pkgs.lemmy-server}/bin/lemmy_server";
        };
      };

      systemd.services.lemmy-ui = {
        description = "Lemmy ui";

        environment = {
          LEMMY_UI_HOST = "127.0.0.1:${toString cfg.ui.port}";
          LEMMY_INTERNAL_HOST = "127.0.0.1:${toString cfg.settings.port}";
          LEMMY_EXTERNAL_HOST = cfg.settings.hostname;
          LEMMY_HTTPS = "false";
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
          WorkingDirectory = "${pkgs.lemmy-ui}";
          ExecStart = "${pkgs.nodejs}/bin/node ${pkgs.lemmy-ui}/dist/js/server.js";
        };
      };
    };

}
