{ config, pkgs, lib, ... }:

with lib;

let
  dataDir = "/var/lib/mautrix-telegram";
  registrationFile = "${dataDir}/telegram-registration.yaml";
  cfg = config.services.mautrix-telegram;
  settingsFormat = pkgs.formats.json {};
  settingsFileUnsubstituted = settingsFormat.generate "mautrix-telegram-config-unsubstituted.json" cfg.settings;
  settingsFile = "${dataDir}/config.json";

in {
  options = {
    services.mautrix-telegram = {
      enable = mkEnableOption (lib.mdDoc "Mautrix-Telegram, a Matrix-Telegram hybrid puppeting/relaybot bridge");

      settings = mkOption rec {
        apply = recursiveUpdate default;
        inherit (settingsFormat) type;
        default = {
          appservice = rec {
            database = "sqlite:///${dataDir}/mautrix-telegram.db";
            database_opts = {};
            hostname = "0.0.0.0";
            port = 8080;
            address = "http://localhost:${toString port}";
          };

          bridge = {
            permissions."*" = "relaybot";
            relaybot.whitelist = [ ];
            double_puppet_server_map = {};
            login_shared_secret_map = {};
          };

          logging = {
            version = 1;

            formatters.precise.format = "[%(levelname)s@%(name)s] %(message)s";

            handlers.console = {
              class = "logging.StreamHandler";
              formatter = "precise";
            };

            loggers = {
              mau.level = "INFO";
              telethon.level = "INFO";

              # prevent tokens from leaking in the logs:
              # https://github.com/tulir/mautrix-telegram/issues/351
              aiohttp.level = "WARNING";
            };

            # log to console/systemd instead of file
            root = {
              level = "INFO";
              handlers = [ "console" ];
            };
          };
        };
        example = literalExpression ''
          {
            homeserver = {
              address = "http://localhost:8008";
              domain = "public-domain.tld";
            };

            appservice.public = {
              prefix = "/public";
              external = "https://public-appservice-address/public";
            };

            bridge.permissions = {
              "example.com" = "full";
              "@admin:example.com" = "admin";
            };
          }
        '';
        description = lib.mdDoc ''
          {file}`config.yaml` configuration as a Nix attribute set.
          Configuration options should match those described in
          [example-config.yaml](https://github.com/tulir/mautrix-telegram/blob/master/example-config.yaml).

          Secret tokens should be specified using {option}`environmentFile`
          instead of this world-readable attribute set.
        '';
      };

      environmentFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = lib.mdDoc ''
          File containing environment variables to be passed to the mautrix-telegram service,
          in which secret tokens can be specified securely by defining values for
          `MAUTRIX_TELEGRAM_APPSERVICE_AS_TOKEN`,
          `MAUTRIX_TELEGRAM_APPSERVICE_HS_TOKEN`,
          `MAUTRIX_TELEGRAM_TELEGRAM_API_ID`,
          `MAUTRIX_TELEGRAM_TELEGRAM_API_HASH` and optionally
          `MAUTRIX_TELEGRAM_TELEGRAM_BOT_TOKEN`.
        '';
      };

      serviceDependencies = mkOption {
        type = with types; listOf str;
        default = optional config.services.matrix-synapse.enable "matrix-synapse.service";
        defaultText = literalExpression ''
          optional config.services.matrix-synapse.enable "matrix-synapse.service"
        '';
        description = lib.mdDoc ''
          List of Systemd services to require and wait for when starting the application service.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.mautrix-telegram = {
      description = "Mautrix-Telegram, a Matrix-Telegram hybrid puppeting/relaybot bridge.";

      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ] ++ cfg.serviceDependencies;
      after = [ "network-online.target" ] ++ cfg.serviceDependencies;
      path = [ pkgs.lottieconverter ];

      preStart = ''
        # Not all secrets can be passed as environment variable (yet)
        # https://github.com/tulir/mautrix-telegram/issues/584
        [ -f ${settingsFile} ] && rm -f ${settingsFile}
        old_umask=$(umask)
        umask 0177
        ${pkgs.envsubst}/bin/envsubst \
          -o ${settingsFile} \
          -i ${settingsFileUnsubstituted}
        umask $old_umask

        # generate the appservice's registration file if absent
        if [ ! -f '${registrationFile}' ]; then
          ${pkgs.mautrix-telegram}/bin/mautrix-telegram \
            --generate-registration \
            --base-config='${pkgs.mautrix-telegram}/${pkgs.mautrix-telegram.pythonModule.sitePackages}/mautrix_telegram/example-config.yaml' \
            --config='${settingsFile}' \
            --registration='${registrationFile}'
        fi
      '' + lib.optionalString (pkgs.mautrix-telegram ? alembic) ''
        # run automatic database init and migration scripts
        ${pkgs.mautrix-telegram.alembic}/bin/alembic -x config='${settingsFile}' upgrade head
      '';

      serviceConfig = {
        Type = "simple";
        Restart = "always";

        ProtectSystem = "strict";
        ProtectHome = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;

        DynamicUser = true;
        PrivateTmp = true;
        WorkingDirectory = pkgs.mautrix-telegram; # necessary for the database migration scripts to be found
        StateDirectory = baseNameOf dataDir;
        UMask = 0027;
        EnvironmentFile = cfg.environmentFile;

        ExecStart = ''
          ${pkgs.mautrix-telegram}/bin/mautrix-telegram \
            --config='${settingsFile}'
        '';
      };

      restartTriggers = [ settingsFileUnsubstituted ];
    };
  };

  meta.maintainers = with maintainers; [ pacien vskilet ];
}
