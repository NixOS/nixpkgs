{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.services.szurubooru;
  inherit (lib)
    mkOption
    mkEnableOption
    mkIf
    mkPackageOption
    types
    ;
  format = pkgs.formats.yaml { };
  python = pkgs.python3;
in

{
  options = {
    services.szurubooru = {
      enable = mkEnableOption "Szurubooru, an image board engine dedicated for small and medium communities";

      user = mkOption {
        type = types.str;
        default = "szurubooru";
        description = ''
          User account under which Szurubooru runs.
        '';
      };

      group = mkOption {
        type = types.str;
        default = "szurubooru";
        description = ''
          Group under which Szurubooru runs.
        '';
      };

      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/szurubooru";
        example = "/var/lib/szuru";
        description = ''
          The path to the data directory in which Szurubooru will store its data.
        '';
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = ''
          Whether to open the firewall for the port in {option}`services.szurubooru.server.port`.
        '';
      };

      server = {
        package = mkPackageOption pkgs [
          "szurubooru"
          "server"
        ] { };

        port = mkOption {
          type = types.port;
          default = 8080;
          example = 9000;
          description = ''
            Port to expose HTTP service.
          '';
        };

        threads = mkOption {
          type = types.int;
          default = 4;
          example = 6;
          description = ''Number of waitress threads to start.'';
        };

        settings = mkOption {
          type = types.submodule {
            freeformType = format.type;
            options = {
              name = mkOption {
                type = types.str;
                default = "szurubooru";
                example = "Szuru";
                description = ''Name shown in the website title and on the front page.'';
              };

              domain = mkOption {
                type = types.str;
                example = "http://example.com";
                description = ''Full URL to the homepage of this szurubooru site (with no trailing slash).'';
              };

              # NOTE: this is not a real upstream option
              secretFile = mkOption {
                type = types.path;
                example = "/run/secrets/szurubooru-server-secret";
                description = ''
                  File containing a secret used to salt the users' password hashes and generate filenames for static content.
                '';
              };

              delete_source_files = mkOption {
                type = types.enum [
                  "yes"
                  "no"
                ];
                default = "no";
                example = "yes";
                description = ''Whether to delete thumbnails and source files on post delete.'';
              };

              smtp = {
                host = mkOption {
                  type = types.nullOr types.str;
                  default = null;
                  example = "localhost";
                  description = ''Host of the SMTP server used to send reset password.'';
                };

                port = mkOption {
                  type = types.nullOr types.port;
                  default = null;
                  example = 25;
                  description = ''Port of the SMTP server.'';
                };

                user = mkOption {
                  type = types.nullOr types.str;
                  default = null;
                  example = "bot";
                  description = ''User to connect to the SMTP server.'';
                };

                # NOTE: this is not a real upstream option
                passFile = mkOption {
                  type = types.nullOr types.path;
                  default = null;
                  example = "/run/secrets/szurubooru-smtp-pass";
                  description = ''File containing the password associated to the given user for the SMTP server.'';
                };
              };

              data_url = mkOption {
                type = types.str;
                default = "${cfg.server.settings.domain}/data/";
                defaultText = lib.literalExpression ''"''${services.szurubooru.server.settings.domain}/data/"'';
                example = "http://example.com/content/";
                description = ''Full URL to the data endpoint.'';
              };

              data_dir = mkOption {
                type = types.path;
                default = "${cfg.dataDir}/data";
                defaultText = lib.literalExpression ''"''${services.szurubooru.dataDir}/data"'';
                example = "/srv/szurubooru/data";
                description = ''Path to the static files.'';
              };

              debug = mkOption {
                type = types.int;
                default = 0;
                example = 1;
                description = ''Whether to generate server logs.'';
              };

              show_sql = mkOption {
                type = types.int;
                default = 0;
                example = 1;
                description = ''Whether to show SQL in server logs.'';
              };
            };
          };
          description = ''
            Configuration to write to {file}`config.yaml`.
            See <https://github.com/rr-/szurubooru/blob/master/server/config.yaml.dist> for more information.
          '';
        };
      };

      client = {
        package = mkPackageOption pkgs [
          "szurubooru"
          "client"
        ] { };
      };

      database = {
        host = mkOption {
          type = types.str;
          default = "localhost";
          example = "192.168.1.2";
          description = ''Host on which the PostgreSQL database runs.'';
        };

        port = mkOption {
          type = types.port;
          default = 5432;
          description = ''The port under which PostgreSQL listens to.'';
        };

        name = mkOption {
          type = types.str;
          default = cfg.database.user;
          defaultText = lib.literalExpression "szurubooru.database.name";
          example = "szuru";
          description = ''Name of the PostgreSQL database.'';
        };

        user = mkOption {
          type = types.str;
          default = "szurubooru";
          example = "szuru";
          description = ''PostgreSQL user.'';
        };

        passwordFile = mkOption {
          type = types.path;
          example = "/run/secrets/szurubooru-db-password";
          description = ''A file containing the password for the PostgreSQL user.'';
        };
      };
    };
  };

  config = mkIf cfg.enable {

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.server.port ];

    users.groups = mkIf (cfg.group == "szurubooru") {
      szurubooru = { };
    };

    users.users = mkIf (cfg.user == "szurubooru") {
      szurubooru = {
        group = cfg.group;
        description = "Szurubooru Daemon user";
        isSystemUser = true;
      };
    };

    systemd.services.szurubooru =
      let
        configFile = format.generate "config.yaml" (
          lib.pipe cfg.server.settings [
            (
              settings:
              lib.recursiveUpdate settings {
                secretFile = null;
                secret = "$SZURUBOORU_SECRET";

                smtp.pass = if settings.smtp.passFile != null then "$SZURUBOORU_SMTP_PASS" else null;
                smtp.passFile = null;
                smtp.enable = null;

                database = "postgresql://${cfg.database.user}:$SZURUBOORU_DATABASE_PASSWORD@${cfg.database.host}:${toString cfg.database.port}/${cfg.database.name}";
              }
            )
            (lib.filterAttrsRecursive (_: x: x != null))
          ]
        );
        pyenv = python.buildEnv.override {
          extraLibs = [ (python.pkgs.toPythonModule cfg.server.package) ];
        };
      in
      {
        description = "Server of Szurubooru, an image board engine dedicated for small and medium communities";

        wantedBy = [
          "multi-user.target"
          "szurubooru-client.service"
        ];
        before = [ "szurubooru-client.service" ];
        after = [
          "network.target"
          "network-online.target"
        ];
        wants = [ "network-online.target" ];

        environment = {
          PYTHONPATH = "${pyenv}/${pyenv.sitePackages}/";
        };

        path =
          with pkgs;
          [
            envsubst
            ffmpeg_4-full
          ]
          ++ (with python.pkgs; [
            alembic
            waitress
          ]);

        script = ''
          export SZURUBOORU_SECRET="$(<$CREDENTIALS_DIRECTORY/secret)"
          export SZURUBOORU_DATABASE_PASSWORD="$(<$CREDENTIALS_DIRECTORY/database)"
          ${lib.optionalString (cfg.server.settings.smtp.passFile != null) ''
            export SZURUBOORU_SMTP_PASS=$(<$CREDENTIALS_DIRECTORY/smtp)
          ''}
          install -m0640 ${cfg.server.package.src}/config.yaml.dist ${cfg.dataDir}/config.yaml.dist
          touch ${cfg.dataDir}/config.yaml
          chmod 0640 ${cfg.dataDir}/config.yaml
          envsubst -i ${configFile} -o ${cfg.dataDir}/config.yaml
          sed 's|script_location = |script_location = ${cfg.server.package.src}/|' ${cfg.server.package.src}/alembic.ini > ${cfg.dataDir}/alembic.ini
          alembic upgrade head
          waitress-serve --port ${toString cfg.server.port} --threads ${toString cfg.server.threads} szurubooru.facade:app
        '';

        serviceConfig = {
          LoadCredential = [
            "secret:${cfg.server.settings.secretFile}"
            "database:${cfg.database.passwordFile}"
          ]
          ++ (lib.optionals (cfg.server.settings.smtp.passFile != null) [
            "smtp:${cfg.server.settings.smtp.passFile}"
          ]);

          User = cfg.user;
          Group = cfg.group;

          Type = "simple";
          Restart = "on-failure";

          StateDirectory = mkIf (cfg.dataDir == "/var/lib/szurubooru") "szurubooru";
          WorkingDirectory = cfg.dataDir;
        };
      };
  };

  meta = {
    maintainers = with lib.maintainers; [ ratcornu ];
    doc = ./szurubooru.md;
  };
}
