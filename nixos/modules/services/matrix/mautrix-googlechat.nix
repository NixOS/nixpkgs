{
  config,
  pkgs,
  lib,
  ...
}:
let
  dataDir = "/var/lib/mautrix-googlechat";
  registrationFile = "${dataDir}/googlechat-registration.yaml";
  cfg = config.services.mautrix-googlechat;
  settingsFormat = pkgs.formats.json { };
  settingsFileUnsubstituted = settingsFormat.generate "mautrix-googlechat-config.json" cfg.settings;
  settingsFile = "${dataDir}/config.json";
in
{
  options.services.mautrix-googlechat = {
    enable = lib.mkEnableOption "Mautrix-GoogleChat, a Matrix - Google Chat hybrid puppeting/relaybot bridge";
    package = lib.mkPackageOption pkgs "mautrix-googlechat" { };

    user = lib.mkOption {
      default = "mautrix-googlechat";
      type = lib.types.str;
      description = "User the mautrix-googlechat bridge runs as.";
    };

    group = lib.mkOption {
      default = "mautrix-googlechat";
      type = lib.types.str;
      description = "Group the mautrix-googlechat bridge runs as.";
    };

    settings = lib.mkOption rec {
      apply = lib.recursiveUpdate default;
      inherit (settingsFormat) type;

      default = {
        homeserver = {
          software = "standard";
        };

        appservice = rec {
          database = "sqlite:///${dataDir}/mautrix-googlechat.db";
          database_opts = { };
          hostname = "0.0.0.0";
          port = 8080;
          address = "http://localhost:${toString port}";
        };

        bridge = {
          permissions."*" = "relaybot";
          relaybot.whitelist = [ ];
          double_puppet_server_map = { };
          login_shared_secret_map = { };
        };

        logging = {
          version = 1;

          formatters.normal.format = "[%(levelname)s@%(name)s] %(message)s";

          handlers.console = {
            class = "logging.StreamHandler";
            formatter = "precise";
          };

          loggers = {
            mau.level = "INFO";
            maugclib.level = "INFO";

            # prevent tokens from leaking in the logs
            aiohttp.level = "WARNING";
          };

          # log to console/systemd instead of file
          root = {
            level = "INFO";
            handlers = [ "console" ];
          };
        };
      };
      example = lib.literalExpression ''
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
      description = ''
        {file}`config.yaml` configuration as a Nix attribute set.
        Configuration options should match those described in
        [example-config.yaml](https://github.com/mautrix/googlechat/blob/master/mautrix_googlechat/example-config.yaml).

        Secret tokens should be specified using {option}`environmentFile`
        instead of this world-readable attribute set.
      '';
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        File containing environment variables to be passed to the mautrix-googlechat service,
        in which secret tokens can be specified securely to the bridge.
      '';
    };

    serviceDependencies = lib.mkOption {
      type = with lib.types; listOf str;
      default = lib.optional config.services.matrix-synapse.enable config.services.matrix-synapse.serviceUnit;
      defaultText = lib.literalExpression ''
        lib.optional config.services.matrix-synapse.enable config.services.matrix-synapse.serviceUnit
      '';
      description = ''
        List of Systemd services to require and wait for when starting the application service.
      '';
    };

    registerToSynapse = lib.mkOption {
      type = lib.types.bool;
      default = config.services.matrix-synapse.enable;
      defaultText = lib.literalExpression "config.services.matrix-synapse.enable";
      description = ''
        Whether to add the bridge's app service registration file to
        `services.matrix-synapse.settings.app_service_config_files`.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.${cfg.user} = {
      isSystemUser = true;
      group = cfg.group;
      home = dataDir;
      description = "Mautrix-GoogleChat bridge user";
    };

    users.groups.${cfg.group} = { };

    services.matrix-synapse = lib.mkIf cfg.registerToSynapse {
      settings.app_service_config_files = [ registrationFile ];
    };

    systemd.services.matrix-synapse = lib.mkIf cfg.registerToSynapse {
      serviceConfig.SupplementaryGroups = [ cfg.group ];
    };

    systemd.services.mautrix-googlechat = {
      description = "Mautrix-GoogleChat, a Matrix - Google Chat hybrid puppeting/relaybot bridge.";

      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ] ++ cfg.serviceDependencies;
      after = [ "network-online.target" ] ++ cfg.serviceDependencies;
      path = [
        pkgs.lottieconverter
        pkgs.ffmpeg-headless
      ];

      # mautrix-googlechat tries to generate a dotfile in the home directory of
      # the running user if using a PostgreSQL database, therefore we
      # have to explicitly declare it
      environment.HOME = dataDir;

      preStart = ''
        # substitute the settings file by environment variables
        test -f '${settingsFile}' && rm -f '${settingsFile}'
        old_umask=$(umask)
        umask 0177

        ${pkgs.envsubst}/bin/envsubst \
          -o '${settingsFile}' \
          -i '${settingsFileUnsubstituted}'

        umask $old_umask

        # generate the appservice's registration file if absent
        if [ ! -f '${registrationFile}' ]; then
          ${cfg.package}/bin/mautrix-googlechat \
            --generate-registration \
            --config='${settingsFile}' \
            --registration='${registrationFile}'
        fi

        old_umask=$(umask)
        umask 0177

        # overwrite generated registration tokens in config
        ${pkgs.yq}/bin/yq -s '.[0].appservice.as_token = .[1].as_token
          | .[0].appservice.hs_token = .[1].hs_token
          | .[0]' \
          '${settingsFile}' '${registrationFile}' > '${settingsFile}.tmp'
        mv '${settingsFile}.tmp' '${settingsFile}'

        umask $old_umask
      '';

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        Type = "simple";
        Restart = "always";

        ProtectSystem = "strict";
        ProtectHome = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;

        PrivateTmp = true;
        UMask = "0027";
        StateDirectory = baseNameOf dataDir;
        EnvironmentFile = cfg.environmentFile;

        ExecStart = ''
          ${cfg.package}/bin/mautrix-googlechat \
            --config='${settingsFile}'
        '';
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ sadorowo ];
}
