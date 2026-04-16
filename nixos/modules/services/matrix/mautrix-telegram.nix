{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (lib)
    mkOption
    mkPackageOption
    versionAtLeast
    types
    mkMerge
    mkDefault
    mkEnableOption
    literalExpression
    optional
    optionalString
    mkIf
    getExe
    maintainers
    ;

  dataDir = "/var/lib/mautrix-telegram";

  cfg = config.services.mautrix-telegram;

  settingsFormat = pkgs.formats.yaml { };
  settingsFile = settingsFormat.generate "mautrix-telegram-config.yaml" cfg.settings;
  runtimeSettingsFile = "${dataDir}/config.yaml";

  runtimeRegistrationFile = "${dataDir}/telegram-registration.yaml";

  isPythonVersion = cfg.package ? overridePythonAttrs;
in
{
  options.services.mautrix-telegram = {
    enable = mkEnableOption "Mautrix-Telegram, a Matrix-Telegram hybrid puppeting/relaybot bridge";

    package = mkPackageOption pkgs "mautrix-telegram" { } // {
      default =
        if versionAtLeast config.system.stateVersion "26.05" then
          pkgs.mautrix-telegram-go
        else
          pkgs.mautrix-telegram;
      defaultText = lib.literalExpression ''
        if lib.versionAtLeast config.system.stateVersion "26.05" then
          pkgs.mautrix-telegram-go
        else
          pkgs.mautrix-telegram
      '';
    };

    settings = mkOption {
      type = types.submodule {
        freeformType = settingsFormat.type;
      };
      default = { };
      description = ''
        {file}`config.yaml` configuration as a Nix attribute set.

        For the Go version (`pkgs.mautrix-telegram-go`), see configuration options in
        [example-config.yaml](https://docs.mau.fi/configs/mautrix-telegram/latest)

        For the legacy Python version (`pkgs.mautrix-telegram`), see configuration options in
        [example-config.yaml](https://github.com/mautrix/telegram/blob/python-final/mautrix_telegram/example-config.yaml).

        Secret tokens should be specified using {option}`environmentFile`
        instead of this world-readable attribute set.
      '';
    };
    environmentFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        File containing environment variables to be passed to the mautrix-telegram service.

        For the Go version, the prefix for these environment variables defaults to `MAUTRIX_TELEGRAM_`.
        All variables with this prefix must map to valid config fields. Nesting in variable names
        is represented with a dot `.`. If there are no dots in the name, two underscores `__`
        are replaced with a dot. E.g. `MAUTRIX_TELEGRAM_APPSERVICE__AS_TOKEN` will set
        {option}`settings.appservice.as_token`. `MAUTRIX_TELEGRAM_appservice.as_token` would work as well.

        For the legacy Python version, the prefix for these environment variables is also `MAUTRIX_TELEGRAM_`.
        Nesting in variable names is represented with an underscore `_`.
        E.g. `MAUTRIX_TELEGRAM_APPSERVICE_AS_TOKEN` will set {option}`settings.appservice.as_token`.
        The environment variable values can be prefixed with `json::` to have them be parsed as JSON.
        For example, `login_shared_secret_map` can be set as follows:
        `MAUTRIX_TELEGRAM_BRIDGE_LOGIN_SHARED_SECRET_MAP=json::{"example.com":"secret"}`.
      '';
    };
    serviceDependencies = mkOption {
      type = types.listOf types.str;
      default = optional config.services.matrix-synapse.enable config.services.matrix-synapse.serviceUnit;
      defaultText = literalExpression ''
        lib.optional config.services.matrix-synapse.enable config.services.matrix-synapse.serviceUnit
      '';
      description = ''
        List of Systemd services to require and wait for when starting the application service.
      '';
    };
    registerToSynapse = mkOption {
      type = types.bool;
      default = config.services.matrix-synapse.enable;
      defaultText = literalExpression "config.services.matrix-synapse.enable";
      description = ''
        Whether to add the bridge's app service registration file to
        {option}`services.matrix-synapse.settings.app_service_config_files`.
      '';
    };
  };

  config = mkIf cfg.enable {
    services.mautrix-telegram.settings = mkMerge [
      (mkIf (!isPythonVersion) {
        appservice = {
          address = mkDefault "http://localhost:${toString cfg.settings.appservice.port}";
          port = mkDefault 8080;
        };
        database = {
          type = mkDefault "sqlite3-fk-wal";
          uri = mkDefault "file:${dataDir}/mautrix-telegram.db?_txlock=immediate";
        };
        env_config_prefix = "MAUTRIX_TELEGRAM_";
      })
      (mkIf isPythonVersion {
        appservice = {
          database = mkDefault "sqlite:///${dataDir}/mautrix-telegram.db";
          port = mkDefault 8080;
          address = mkDefault "http://localhost:${toString cfg.settings.appservice.port}";
        };

        bridge.permissions."*" = mkDefault "relaybot";

        logging = {
          formatters.precise.format = mkDefault "[%(levelname)s@%(name)s] %(message)s";
          handlers.console.formatter = mkDefault "precise";
          loggers = {
            mau.level = mkDefault "INFO";
            # prevent tokens from leaking in the logs:
            # https://github.com/tulir/mautrix-telegram/issues/351
            aiohttp.level = mkDefault "WARNING";
          };
          # log to console/systemd instead of file
          root = {
            level = mkDefault "INFO";
            handlers = mkDefault [ "console" ];
          };
        };
      })
    ];

    users.users.mautrix-telegram = {
      isSystemUser = true;
      group = "mautrix-telegram";
      home = dataDir;
      description = "Mautrix-Telegram bridge user";
    };

    users.groups.mautrix-telegram = { };

    services.matrix-synapse = mkIf cfg.registerToSynapse {
      settings.app_service_config_files = [ runtimeRegistrationFile ];
    };
    systemd.services.matrix-synapse = mkIf cfg.registerToSynapse {
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
        old_umask=$(umask)
        umask 0177
      ''
      +
        # Only substitute environment variables directly if we are using the
        # Python version, otherwise the Go version will load these itself
        (optionalString isPythonVersion ''
          # substitute the settings file by environment variables
          # in this case read from EnvironmentFile
          test -f '${settingsFile}' && rm -f '${settingsFile}'
          ${getExe pkgs.envsubst} \
            -o '${runtimeSettingsFile}' \
            -i '${settingsFile}'
        '')
      + (optionalString (!isPythonVersion) "cp ${settingsFile} ${runtimeSettingsFile}")
      + ''
        # generate the appservice's registration file if absent
        if [ ! -f '${runtimeRegistrationFile}' ]; then
          ${lib.getExe cfg.package} \
            --generate-registration \
            --config='${settingsFile}' \
            --registration='${runtimeRegistrationFile}'
        fi

        # 1. Overwrite registration tokens in config
        #    is set, set it as the login shared secret value for the configured
        #    homeserver domain.
        ${getExe pkgs.yq} -s '.[0].appservice.as_token = .[1].as_token
          | .[0].appservice.hs_token = .[1].hs_token
          | .[0]' \
          '${runtimeSettingsFile}' '${runtimeRegistrationFile}' > '${runtimeSettingsFile}.tmp'
        mv '${runtimeSettingsFile}.tmp' '${runtimeSettingsFile}'
        umask $old_umask
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
        ExecStart = "${getExe cfg.package} --config='${runtimeSettingsFile}'";
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

  meta.maintainers = with maintainers; [
    bartoostveen
    euxane
    vskilet
  ];
}
