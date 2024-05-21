{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.mautrix-facebook;
  settingsFormat = pkgs.formats.json {};
  settingsFile = settingsFormat.generate "mautrix-facebook-config.json" cfg.settings;

  puppetRegex = concatStringsSep
    ".*"
    (map
      escapeRegex
      (splitString
        "{userid}"
        cfg.settings.bridge.username_template));
in {
  options = {
    services.mautrix-facebook = {
      enable = mkEnableOption "Mautrix-Facebook, a Matrix-Facebook hybrid puppeting/relaybot bridge";

      settings = mkOption rec {
        apply = recursiveUpdate default;
        type = settingsFormat.type;
        default = {
          homeserver = {
            address = "http://localhost:8008";
            software = "standard";
          };

          appservice = rec {
            id = "facebook";
            address = "http://${hostname}:${toString port}";
            hostname = "localhost";
            port = 29319;

            database = "postgresql://";

            bot_username = "facebookbot";
          };

          metrics.enabled = false;
          manhole.enabled = false;

          bridge = {
            encryption = {
              allow = true;
              default = true;

              verification_levels = {
                receive = "cross-signed-tofu";
                send = "cross-signed-tofu";
                share = "cross-signed-tofu";
              };
            };
            username_template = "facebook_{userid}";
          };

          logging = {
            version = 1;
            formatters.journal_fmt.format = "%(name)s: %(message)s";
            handlers.journal = {
              class = "systemd.journal.JournalHandler";
              formatter = "journal_fmt";
              SYSLOG_IDENTIFIER = "mautrix-facebook";
            };
            root = {
              level = "INFO";
              handlers = ["journal"];
            };
          };
        };
        example = literalExpression ''
          {
            homeserver = {
              address = "http://localhost:8008";
              domain = "mydomain.example";
            };

            bridge.permissions = {
              "@admin:mydomain.example" = "admin";
              "mydomain.example" = "user";
            };
          }
        '';
        description = ''
          {file}`config.yaml` configuration as a Nix attribute set.
          Configuration options should match those described in
          [example-config.yaml](https://github.com/mautrix/facebook/blob/master/mautrix_facebook/example-config.yaml).

          Secret tokens should be specified using {option}`environmentFile`
          instead of this world-readable attribute set.
        '';
      };

      environmentFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = ''
          File containing environment variables to be passed to the mautrix-facebook service.

          Any config variable can be overridden by setting `MAUTRIX_FACEBOOK_SOME_KEY` to override the `some.key` variable.
        '';
      };

      configurePostgresql = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Enable PostgreSQL and create a user and database for mautrix-facebook. The default `settings` reference this database, if you disable this option you must provide a database URL.
        '';
      };

      registrationData = mkOption {
        type = types.attrs;
        default = {};
        description = ''
          Output data for appservice registration. Simply make any desired changes and serialize to JSON. Note that this data contains secrets so think twice before putting it into the nix store.

          Currently `as_token` and `hs_token` need to be added as they are not known to this module.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    users.groups.mautrix-facebook = {};

    users.users.mautrix-facebook = {
      group = "mautrix-facebook";
      isSystemUser = true;
    };

    services.postgresql = mkIf cfg.configurePostgresql {
      ensureDatabases = ["mautrix-facebook"];
      ensureUsers = [{
        name = "mautrix-facebook";
        ensureDBOwnership = true;
      }];
    };

    systemd.services.mautrix-facebook = rec {
      wantedBy = [ "multi-user.target" ];
      wants = [
        "network-online.target"
      ] ++ optional config.services.matrix-synapse.enable config.services.matrix-synapse.serviceUnit
        ++ optional cfg.configurePostgresql "postgresql.service";
      after = wants;

      serviceConfig = {
        Type = "simple";
        Restart = "always";

        User = "mautrix-facebook";

        ProtectSystem = "strict";
        ProtectHome = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        PrivateTmp = true;

        EnvironmentFile = cfg.environmentFile;

        ExecStart = ''
          ${pkgs.mautrix-facebook}/bin/mautrix-facebook --config=${settingsFile}
        '';
      };
    };

    services.mautrix-facebook = {
      registrationData = {
        id = cfg.settings.appservice.id;

        namespaces = {
          users = [
            {
              exclusive = true;
              regex = escapeRegex "@${cfg.settings.appservice.bot_username}:${cfg.settings.homeserver.domain}";
            }
            {
              exclusive = true;
              regex = "@${puppetRegex}:${escapeRegex cfg.settings.homeserver.domain}";
            }
          ];
          aliases = [];
        };

        url = cfg.settings.appservice.address;
        sender_localpart = "mautrix-facebook-sender";

        rate_limited = false;
        "de.sorunome.msc2409.push_ephemeral" = true;
        push_ephemeral = true;
      };
    };
  };

  meta.maintainers = with maintainers; [ kevincox ];
}
