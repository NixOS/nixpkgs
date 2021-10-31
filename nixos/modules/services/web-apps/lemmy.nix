{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.services.lemmy;
  settingsFormat = pkgs.formats.json { };
in
{
  meta.maintainers = with maintainers; [ happysalada ];
  # Don't edit the docbook xml directly, edit the md and generate it:
  # `pandoc lemmy.md -t docbook --top-level-division=chapter --extract-media=media -f markdown+smart > lemmy.xml`
  meta.doc = ./lemmy.xml;

  options.services.lemmy = {

    enable = mkEnableOption "lemmy a federated alternative to reddit in rust";

    jwtSecretPath = mkOption {
      type = types.path;
      description = "Path to read the jwt secret from.";
    };

    ui = {
      port = mkOption {
        type = types.port;
        default = 1234;
        description = "Port where lemmy-ui should listen for incoming requests.";
      };
    };

    caddy.enable = mkEnableOption "exposing lemmy with the caddy reverse proxy";

    settings = mkOption {
      default = { };
      description = "Lemmy configuration";

      type = types.submodule {
        freeformType = settingsFormat.type;

        options.hostname = mkOption {
          type = types.str;
          default = null;
          description = "The domain name of your instance (eg 'lemmy.ml').";
        };

        options.port = mkOption {
          type = types.port;
          default = 8536;
          description = "Port where lemmy should listen for incoming requests.";
        };

        options.federation = {
          enabled = mkEnableOption "activitypub federation";
        };

        options.captcha = {
          enabled = mkOption {
            type = types.bool;
            default = true;
            description = "Enable Captcha.";
          };
          difficulty = mkOption {
            type = types.enum [ "easy" "medium" "hard" ];
            default = "medium";
            description = "The difficultly of the captcha to solve.";
          };
        };

        options.database.createLocally = mkEnableOption "creation of database on the instance";

      };
    };

  };

  config =
    let
      localPostgres = (cfg.settings.database.host == "localhost" || cfg.settings.database.host == "/run/postgresql");
    in
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

      services.postgresql = mkIf localPostgres {
        enable = mkDefault true;
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
              path /api/* /pictrs/* feeds/* nodeinfo/*
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
        assertion = cfg.settings.database.createLocally -> localPostgres;
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
          "https://join-lemmy.org/docs/en/administration/from_scratch.html"
          "https://join-lemmy.org/docs"
        ];

        wantedBy = [ "multi-user.target" ];

        after = [ "pict-rs.service " ] ++ lib.optionals cfg.settings.database.createLocally [ "lemmy-postgresql.service" ];

        requires = lib.optionals cfg.settings.database.createLocally [ "lemmy-postgresql.service" ];

        # script is needed here since loadcredential is not accessible on ExecPreStart
        script = ''
          ${pkgs.coreutils}/bin/install -m 600 ${settingsFormat.generate "config.hjson" cfg.settings} /run/lemmy/config.hjson
          jwtSecret="$(< $CREDENTIALS_DIRECTORY/jwt_secret )"
          ${pkgs.jq}/bin/jq ".jwt_secret = \"$jwtSecret\"" /run/lemmy/config.hjson | ${pkgs.moreutils}/bin/sponge /run/lemmy/config.hjson
          ${pkgs.lemmy-server}/bin/lemmy_server
        '';

        serviceConfig = {
          DynamicUser = true;
          RuntimeDirectory = "lemmy";
          LoadCredential = "jwt_secret:${cfg.jwtSecretPath}";
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
          "https://join-lemmy.org/docs/en/administration/from_scratch.html"
          "https://join-lemmy.org/docs"
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

      systemd.services.lemmy-postgresql = mkIf cfg.settings.database.createLocally {
        description = "Lemmy postgresql db";
        after = [ "postgresql.service" ];
        partOf = [ "lemmy.service" ];
        script = with cfg.settings.database; ''
          PSQL() {
            ${config.services.postgresql.package}/bin/psql --port=${toString cfg.settings.database.port} "$@"
          }
          # check if the database already exists
          if ! PSQL -lqt | ${pkgs.coreutils}/bin/cut -d \| -f 1 | ${pkgs.gnugrep}/bin/grep -qw ${database} ; then
            PSQL -tAc "CREATE ROLE ${user} WITH LOGIN;"
            PSQL -tAc "CREATE DATABASE ${database} WITH OWNER ${user};"
          fi
        '';
        serviceConfig = {
          User = config.services.postgresql.superUser;
          Type = "oneshot";
          RemainAfterExit = true;
        };
      };
    };

}
