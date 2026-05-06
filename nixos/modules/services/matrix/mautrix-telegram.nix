{
  config,
  pkgs,
  lib,
  ...
}:

let
  dataDir = "/var/lib/mautrix-telegram";
  registrationFile = "${dataDir}/telegram-registration.yaml";

  cfg = config.services.mautrix-telegram;

  settingsFormat = pkgs.formats.yaml { };
  settingsFile = settingsFormat.generate "mautrix-telegram-config.yaml" cfg.settings;
  runtimeSettingsFile = "${dataDir}/config.yaml";
in
{
  options.services.mautrix-telegram = {
    enable = lib.mkEnableOption "Mautrix-Telegram, a Matrix-Telegram hybrid puppeting/relaybot bridge";

    package = lib.mkPackageOption pkgs "mautrix-telegram" { };

    settings = lib.mkOption rec {
      apply = lib.recursiveUpdate default;
      inherit (settingsFormat) type;
      default = {
        homeserver.software = "standard";

        appservice = rec {
          database = "sqlite:///${dataDir}/mautrix-telegram.db?_txlock=immediate";
          database_opts = { };
          hostname = "127.0.0.1";
          port = 29317;
          address = "http://${hostname}:${toString port}";
        };

        env_config_prefix = "MAUTRIX_TELEGRAM_";
      };
      description = ''
        {file}`config.yaml` configuration as a Nix attribute set.

        Secret tokens should be specified using {option}`environmentFile`
        instead of this world-readable attribute set.

        You can find an example of this configuration by running
        `nix-shell -p mautrix-signal --run "mautrix-signal -e"`.
        Alternatively, you can combine the [bridgev2 example config](https://github.com/mautrix/go/blob/main/bridgev2/matrix/mxmain/example-config.yaml)
        and the [Telegram-specific example config](https://github.com/mautrix/telegram/blob/main/pkg/connector/example-config.yaml) yourself,
        but it's better to let the bridge do the combining.
      '';
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        File containing environment variables to be passed to the mautrix-telegram service,
        in which secret tokens can be specified securely by defining values for e.g.
        `MAUTRIX_TELEGRAM_APPSERVICE__AS_TOKEN`,
        `MAUTRIX_TELEGRAM_APPSERVICE__HS_TOKEN`,
        `MAUTRIX_TELEGRAM_NETWORK__API_ID` and
        `MAUTRIX_TELEGRAM_NETWORK__API_HASH`.

        {option}`settings.env_config_prefix` controls the prefix of the environment variables
        as shown above. All variables with this prefix must map to valid config fields, otherwise
        the bridge will not start. Nesting in variable names is represented with a dot (`.`).
        If there are no dots in the name, two underscores (`__`) are replaced with a dot, e.g.
        if the prefix is set to `BRIDGE_`, then `BRIDGE_APPSERVICE__AS_TOKEN` will set
        `appservice.as_token`. `BRIDGE_appservice.as_token` would work as well, but can't be set
        in a shell as easily.
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

    users.users.mautrix-telegram = {
      isSystemUser = true;
      group = "mautrix-telegram";
      home = dataDir;
      description = "Mautrix-Telegram bridge user";
    };

    users.groups.mautrix-telegram = { };

    services.matrix-synapse = lib.mkIf cfg.registerToSynapse {
      settings.app_service_config_files = [ registrationFile ];
    };
    systemd.services.matrix-synapse = lib.mkIf cfg.registerToSynapse {
      serviceConfig.SupplementaryGroups = [ "mautrix-telegram" ];
    };

    systemd.services.mautrix-telegram = {
      description = "Mautrix-Telegram, a Matrix-Telegram hybrid puppeting/relaybot bridge.";

      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ] ++ cfg.serviceDependencies;
      after = [ "network-online.target" ] ++ cfg.serviceDependencies;
      path = [
        pkgs.lottieconverter
        pkgs.ffmpeg-headless
      ];

      # The settings file needs to be writable at runtime, otherwise the bridge will not start
      preStart = ''
        cp ${settingsFile} ${runtimeSettingsFile}
        chmod 660 ${runtimeSettingsFile}
      '';

      serviceConfig = {
        User = "mautrix-telegram";
        Group = "mautrix-telegram";
        Type = "simple";
        Restart = "always";
        WorkingDirectory = dataDir;
        StateDirectory = baseNameOf dataDir;
        UMask = "0027";
        EnvironmentFile = cfg.environmentFile;
        ExecStart = "${lib.getExe cfg.package} --config='${runtimeSettingsFile}'";
        MemoryDenyWriteExecute = true;
        PrivateDevices = true;
        PrivateTmp = true;
        ProtectHome = true;
        ProtectSystem = "strict";
        ProtectControlGroups = true;
        RestrictSUIDSGID = true;
        RestrictRealtime = true;
        LockPersonality = true;
        ProtectKernelLogs = true;
        ProtectKernelTunables = true;
        ProtectHostname = true;
        ProtectKernelModules = true;
        PrivateUsers = true;
        ProtectClock = true;
        SystemCallArchitectures = "native";
        SystemCallErrorNumber = "EPERM";
        SystemCallFilter = "@system-service";
      };
    };
  };

  meta = {
    doc = ./mautrix-telegram.md;
    maintainers = with lib.maintainers; [
      bartoostveen
      euxane
      vskilet
    ];
  };
}
