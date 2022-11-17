{ lib, pkgs, config, ... }:

with lib;

let
  cfg = config.services.claper;
in {
  options.services.claper = {
    enable = mkEnableOption (lib.mdDoc "claper");

    database = {
      postgres = {
        setup = mkEnableOption (lib.mdDoc "creating a postgresql instance") // { default = true; };
        dbname = mkOption {
          default = "claper";
          type = types.str;
          description = lib.mdDoc ''
            Name of the database to use.
          '';
        };
        url = mkOption {
          default = "postgres://claper:claper@127.0.0.1:5432/claper";
          type = types.str;
          description = lib.mdDoc ''
            Path to the UNIX domain-socket to communicate with `postgres`.
          '';
        };
      };
    };

    server = {
      secretKeybaseFile = mkOption {
        type = types.either types.path types.str;
        description = lib.mdDoc ''
          Path to the secret used by the `phoenix`-framework. Instructions
          how to generate one are documented in the
          [framework docs](https://hexdocs.pm/phoenix/Mix.Tasks.Phx.Gen.Secret.html#content).
        '';
      };
      endpoint_host = mkOption {
        default = "localhost";
        type = types.str;
        description = lib.mdDoc ''
          Host used to access the app (used for url generation)
        '';
      };
      endpoint_port = mkOption {
        default = 80;
        type = types.port;
        description = lib.mdDoc ''
          Port used to access the app (used for url generation)
        '';
      };
      port = mkOption {
        default = 4000;
        type = types.port;
        description = lib.mdDoc ''
          Port to listen to
        '';
      };
    };

  };

  config = mkIf cfg.enable {
    services.postgresql = mkIf cfg.database.postgres.setup {
      enable = true;
    };

    services.epmd.enable = true;

    environment.systemPackages = [ cfg.package ];

    systemd.services = mkMerge [
      {
        claper = {
          inherit (pkgs.claper.meta) description;
          documentation = [ "https://docs.claper.co" ];
          wantedBy = [ "multi-user.target" ];
          after = optionals cfg.database.postgres.setup [
            "postgresql.service"
            "claper-postgres.service"
          ];
          requires = optionals cfg.database.postgres.setup [
              "postgresql.service"
              "claper-postgres.service"
            ];

          environment = {
            DATABASE_URL = cfg.database.postgres.url;
            SECRET_KEY_BASE = cfg.secret_key_base;
            ENDPOINT_HOST = cfg.server.endpoint_host;
            ENDPOINT_PORT = cfg.server.endpoint_port;
            PORT = cfg.server.port;
          };

          path = [ pkgs.claper ]
            ++ optional cfg.database.postgres.setup config.services.postgresql.package;
          script = ''
            execStart claper start
          '';

          serviceConfig = {
            DynamicUser = true;
            PrivateTmp = true;
            WorkingDirectory = "/var/lib/claper";
            StateDirectory = "claper";
            LoadCredential = [
              "SECRET_KEY_BASE:${cfg.server.secretKeybaseFile}"
              "RELEASE_COOKIE:${cfg.releaseCookiePath}"
            ];
          };
        };
      }
      (mkIf cfg.database.postgres.setup {
        claper-postgres = {
          after = [ "postgresql.service" ];
          partOf = [ "claper.service" ];
          serviceConfig = {
            Type = "oneshot";
            User = config.services.postgresql.superUser;
            RemainAfterExit = true;
          };
          ensureUsers = [ "claper" ];
          ensureDatabases = [ cfg.database.postgres.dbname ];
        };
      })
    ];
  };

  meta.maintainers = with maintainers; [ drupol ];
}
