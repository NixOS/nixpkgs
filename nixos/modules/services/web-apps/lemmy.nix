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

  imports = [
    (mkRemovedOptionModule [ "services" "lemmy" "jwtSecretPath" ] "This option is no longer required because the secret gets generated automatically.")
    (mkRemovedOptionModule [ "services" "lemmy" "caddy" ] "This option has been removed due to it being a burden on maintenance, please set up the reverse proxy independently of this service.")
  ];

  options.services.lemmy = {
    enable = mkEnableOption "Lemmy, a federated alternative to reddit in rust";

    ui = {
      package = mkOption {
        type = types.package;
        default = pkgs.lemmy-ui;
        defaultText = literalExpression "pkgs.lemmy-ui";
        description = lib.mdDoc "lemmy-ui package to use.";
      };
      listenAddress = mkOption {
        type = types.str;
        default = "127.0.0.1";
        example = "0.0.0.0";
        description = lib.mdDoc "The address for lemmy-ui to listen on.";
      };
      port = mkOption {
        type = types.port;
        default = 1234;
        description = lib.mdDoc "Port where lemmy-ui should listen for incoming requests.";
      };
    };

    package = mkOption {
      type = types.package;
      default = pkgs.lemmy-server;
      defaultText = literalExpression "pkgs.lemmy-server";
      description = lib.mdDoc "lemmy-server package to use.";
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

        options.listenAddress = mkOption {
          type = types.str;
          default = "127.0.0.1";
          example = "0.0.0.0";
          description = lib.mdDoc "The address for lemmy to listen on.";
        };

        options.federation = {
          enabled = mkEnableOption "ActivityPub federation";
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

          options.database.createLocally = mkEnableOption "creation of database on the instance";
        };
      };
    };
  };

  config = mkIf cfg.enable {
    services.lemmy.settings = (mapAttrs (name: mkDefault)
      {
        bind = cfg.settings.listenAddress;
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

    services.pict-rs.enable = true;

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

      after = [ "pict-rs.service" ] ++ lib.optionals cfg.settings.database.createLocally [ "postgresql.service" ];

      requires = lib.optionals cfg.settings.database.createLocally [ "postgresql.service" ];

      serviceConfig = {
        DynamicUser = true;
        RuntimeDirectory = "lemmy";
        ExecStartPre = "install -m 600 ${settingsFormat.generate "config.hjson" cfg.settings} /run/lemmy/config.hjson";
        ExecStart = "${cfg.package}/bin/lemmy-server";
      };
    };

    systemd.services.lemmy-ui = {
      description = "Lemmy ui";

      environment = {
        LEMMY_UI_HOST = "${cfg.ui.listenAddress}:${toString cfg.ui.port}";
        LEMMY_INTERNAL_HOST = "${cfg.settings.listenAddress}:${toString cfg.settings.port}";
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
        WorkingDirectory = "${cfg.ui.package}";
        ExecStart = "${pkgs.nodejs}/bin/node ${cfg.ui.package}/dist/js/server.js";
      };
    };

    services.postgresql = mkIf cfg.settings.database.createLocally {
      enable = true;
      ensureDatabases = [ cfg.settings.database.database ];
      ensureUsers = [{
        name = cfg.settings.database.user;
        ensurePermissions."DATABASE ${cfg.settings.database.database}" = "ALL PRIVILEGES";
      }];
    };

    assertions = [{
      assertion = cfg.settings.database.createLocally -> (cfg.settings.database.host == "localhost" || cfg.settings.database.host == "/run/postgresql");
      message = "In order to use database.createLocally, you need to use a local database";
    }];
  };
}
