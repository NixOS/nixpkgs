{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.services.oxibooru;
  inherit (lib)
    mkOption
    mkEnableOption
    mkIf
    mkPackageOption
    types
    ;

  format = pkgs.formats.toml { };
in

{
  options = {
    services.oxibooru = {
      enable = mkEnableOption "Oxibooru, an image board engine based on Szurubooru";

      user = mkOption {
        type = types.str;
        default = "oxibooru";
        description = ''
          User account under which Oxibooru runs.
        '';
      };

      group = mkOption {
        type = types.str;
        default = "oxibooru";
        description = ''
          Group under which Oxibooru runs.
        '';
      };

      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/oxibooru";
        example = "/var/lib/booru";
        description = ''
          The path to the data directory in which Oxibooru will store its data.
        '';
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = ''
          Whether to open the firewall for the port in {option}`services.oxibooru.server.port`.
        '';
      };

      server = {
        package = mkPackageOption pkgs [
          "oxibooru"
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

        baseUrl = lib.mkOption {
          type = types.str;
          default = "/";
          example = "/booru";
          description = "URL base to run oxibooru under";
        };

        settings = mkOption {
          type = types.submodule {
            freeformType = format.type;
            options = {
              domain = mkOption {
                type = types.str;
                example = "http://example.com";
                description = "Full URL to the homepage of this Oxibooru site (with no trailing slash).";
              };

              # NOTE: this is not a real upstream option
              secretFile = mkOption {
                type = types.path;
                example = "/run/secrets/oxibooru-server-secret";
                description = ''
                  File containing a secret used to salt the users' password hashes and generate filenames for static content.
                '';
              };

              webhooks = mkOption {
                type = types.listOf types.str;
                default = [ ];
                example = [ "https://example.org/callback/oxibooru" ];
                description = "Webhooks to call when events occur.";
              };

              delete_source_files = mkOption {
                type = types.enum [
                  "yes"
                  "no"
                ];
                default = "no";
                example = "yes";
                description = "Whether to delete thumbnails and source files on post delete.";
              };

              append_tag_implications_on_post_edit = mkOption {
                type = types.bool;
                default = false;
                example = true;
                description = "Adds tag implications to post tags on edit.";
              };

              post_similarity_threshold = mkOption {
                type = types.float;
                default = 0.55;
                example = 0.8;
                description = "Threshold used for reverse search (must be a number between 0 and 1).";
              };

              smtp = {
                host = mkOption {
                  type = types.nullOr types.str;
                  default = null;
                  example = "localhost";
                  description = "Host of the SMTP server used to send reset password.";
                };

                port = mkOption {
                  type = types.nullOr types.port;
                  default = null;
                  example = 25;
                  description = "Port of the SMTP server.";
                };

                username = mkOption {
                  type = types.nullOr types.str;
                  default = null;
                  example = "bot";
                  description = "User to connect to the SMTP server.";
                };

                # NOTE: this is not a real upstream option
                passwordFile = mkOption {
                  type = types.nullOr types.path;
                  default = null;
                  example = "/run/secrets/oxibooru-smtp-pass";
                  description = "File containing the password associated to the given user for the SMTP server.";
                };

                from = mkOption {
                  type = types.nullOr types.str;
                  default = null;
                  example = "App <noreply@example.org>";
                  description = "Content of the From header.";
                };
              };

              data_url = mkOption {
                type = types.str;
                default = "${cfg.server.settings.domain}/data/";
                defaultText = lib.literalExpression ''"''${services.oxibooru.server.settings.domain}/data/"'';
                example = "http://example.com/content/";
                description = "Full URL to the data endpoint.";
              };

              data_dir = mkOption {
                type = types.path;
                default = "${cfg.dataDir}/data";
                defaultText = lib.literalExpression ''"''${services.oxibooru.dataDir}/data"'';
                example = "/srv/oxibooru/data";
                description = "Path to the static files.";
              };

              log_filter = mkOption {
                type = types.str;
                default = "oxibooru_server=info,tower_http=debug,axum=trace";
                example = "oxibooru_server=trace,tower_http=info,axum=debug";
                description = "Directive for controlling log verbosity for different parts of the server.";
              };

              auto_explain = mkOption {
                type = types.bool;
                default = false;
                example = true;
                description = "Whether to show SQL in server logs.";
              };

              public_info = {
                name = mkOption {
                  type = types.str;
                  default = "oxibooru";
                  example = "booru";
                  description = "Name shown in the website title and on the front page.";
                };

                default_user_rank = mkOption {
                  type = types.str;
                  default = "regular";
                  example = "anonymous";
                  description = "Default rank given for new users.";
                };
              };
            };
          };
          description = ''
            Configuration to write to {file}`config.toml`.
            See <https://github.com/liamw1/oxibooru/blob/master/server/config.toml.dist> for more information.
          '';
        };
      };

      client = {
        package = mkPackageOption pkgs [
          "oxibooru"
          "client"
        ] { };
      };

      database = {
        host = mkOption {
          type = types.str;
          default = "localhost";
          example = "192.168.1.2";
          description = "Host on which the PostgreSQL database runs.";
        };

        port = mkOption {
          type = types.port;
          default = 5432;
          description = "The port under which PostgreSQL listens to.";
        };

        name = mkOption {
          type = types.str;
          default = cfg.database.user;
          defaultText = lib.literalExpression "oxibooru.database.name";
          example = "oxi";
          description = "Name of the PostgreSQL database.";
        };

        user = mkOption {
          type = types.str;
          default = "oxibooru";
          example = "oxi";
          description = "PostgreSQL user.";
        };

        passwordFile = mkOption {
          type = types.path;
          example = "/run/secrets/oxibooru-db-password";
          description = "A file containing the password for the PostgreSQL user.";
        };
      };

      extraEnv = lib.mkOption {
        type = types.attrs;
        default = { };
        example = {
          BUILD_INFO = "latest";
        };
        description = ''
          Extra environment variables to be passed to the Oxibooru service.
          Refer to <https://github.com/liamw1/oxibooru/blob/master/example.env> for details on supported variables.
        '';
      };
    };
  };

  config = mkIf cfg.enable {

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.server.port ];

    users.groups = mkIf (cfg.group == "oxibooru") {
      oxibooru = { };
    };

    users.users = mkIf (cfg.user == "oxibooru") {
      oxibooru = {
        group = cfg.group;
        description = "Oxibooru daemon user";
        isSystemUser = true;
      };
    };

    systemd.services.oxibooru =
      let
        envFile = pkgs.writeText ".env" ''
          POSTGRES_HOST=${cfg.database.host}
          POSTGRES_USER=${cfg.database.user}
          POSTGRES_PASSWORD=$OXIBOORU_DATABASE_PASSWORD
          POSTGRES_DB=${cfg.database.name}
          POSTGRES_PORT=${toString cfg.database.port}

          SERVER_PORT=${toString cfg.server.port}
          BASE_URL=${cfg.server.baseUrl}

          MOUNT_DATA=${cfg.server.settings.data_dir}
          MOUNT_SQL=${cfg.dataDir}/sql
        '';
        configFile = format.generate "config.toml" (
          lib.pipe cfg.server.settings [
            (
              settings:
              lib.recursiveUpdate settings {
                secretFile = null;
                password_secret = "$OXIBOORU_SECRET";
                content_secret = "$OXIBOORU_SECRET";

                smtp =
                  if settings.smtp.host == null then
                    null
                  else
                    {
                      password = if settings.smtp.passwordFile != null then "$OXIBOORU_SMTP_PASS" else null;
                      passwordFile = null;
                    };
              }
            )
            (lib.filterAttrsRecursive (_: x: x != null))
          ]
        );
      in
      {
        description = "Server of Oxibooru, an image board engine based on Szurubooru";

        wantedBy = [
          "multi-user.target"
          "oxibooru-client.service"
        ];
        before = [ "oxibooru-client.service" ];
        after = [
          "network.target"
          "network-online.target"
        ];
        wants = [ "network-online.target" ];

        script = ''
          export OXIBOORU_SECRET="$(<$CREDENTIALS_DIRECTORY/secret)"
          export OXIBOORU_DATABASE_PASSWORD="$(<$CREDENTIALS_DIRECTORY/database)"
          ${lib.optionalString (cfg.server.settings.smtp.passwordFile != null) ''
            export OXIBOORU_SMTP_PASS=$(<$CREDENTIALS_DIRECTORY/smtp)
          ''}
          install -m0640 ${cfg.server.package.src}/config.toml.dist ${cfg.dataDir}/config.toml.dist
          touch ${cfg.dataDir}/config.toml
          chmod 0640 ${cfg.dataDir}/config.toml
          ${lib.getExe pkgs.envsubst} -i ${configFile} -o ${cfg.dataDir}/config.toml
          ${lib.getExe pkgs.envsubst} -i ${envFile} -o ${cfg.dataDir}/.env
          ${lib.getExe cfg.server.package} --config-path=${cfg.dataDir}/config.toml --env-path=${cfg.dataDir}/.env
        '';

        serviceConfig = {
          LoadCredential = [
            "secret:${cfg.server.settings.secretFile}"
            "database:${cfg.database.passwordFile}"
          ]
          ++ (lib.optionals (cfg.server.settings.smtp.passwordFile != null) [
            "smtp:${cfg.server.settings.smtp.passwordFile}"
          ]);

          User = cfg.user;
          Group = cfg.group;

          Type = "simple";
          Restart = "on-failure";

          StateDirectory = mkIf (cfg.dataDir == "/var/lib/oxibooru") "oxibooru";
          WorkingDirectory = cfg.dataDir;
        };
      };
  };

  meta = {
    maintainers = with lib.maintainers; [ ratcornu ];
    doc = ./oxibooru.md;
  };
}
