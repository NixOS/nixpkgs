{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.services.mautrix-signal;
  dataDir = "/var/lib/mautrix-signal";
  registrationFile = "${dataDir}/signal-registration.yaml";
  settingsFile = "${dataDir}/config.yaml";
  settingsFileUnsubstituted = settingsFormat.generate "mautrix-signal-config-unsubstituted.json" cfg.settings;
  settingsFormat = pkgs.formats.json { };
  appservicePort = 29328;

  # to be used with a list of lib.mkIf values
  optOneOf = lib.lists.findFirst (value: value.condition) (lib.mkIf false null);
  mkDefaults = lib.mapAttrsRecursive (n: v: lib.mkDefault v);
  defaultConfig = {
    homeserver.address = "http://localhost:8448";
    appservice = {
      hostname = "[::]";
      port = appservicePort;
      database.type = "sqlite3";
      database.uri = "file:${dataDir}/mautrix-signal.db?_txlock=immediate";
      id = "signal";
      bot = {
        username = "signalbot";
        displayname = "Signal Bridge Bot";
      };
      as_token = "";
      hs_token = "";
    };
    bridge = {
      username_template = "signal_{{.}}";
      displayname_template = "{{or .ProfileName .PhoneNumber \"Unknown user\"}}";
      double_puppet_server_map = { };
      login_shared_secret_map = { };
      command_prefix = "!signal";
      permissions."*" = "relay";
      relay.enabled = true;
    };
    logging = {
      min_level = "info";
      writers = lib.singleton {
        type = "stdout";
        format = "pretty-colored";
        time_format = " ";
      };
    };
  };

in
{
  options.services.mautrix-signal = {
    enable = lib.mkEnableOption "mautrix-signal, a Matrix-Signal puppeting bridge.";

    settings = lib.mkOption {
      apply = lib.recursiveUpdate defaultConfig;
      type = settingsFormat.type;
      default = defaultConfig;
      description = ''
        {file}`config.yaml` configuration as a Nix attribute set.
        Configuration options should match those described in
        [example-config.yaml](https://github.com/mautrix/signal/blob/master/example-config.yaml).
        Secret tokens should be specified using {option}`environmentFile`
        instead of this world-readable attribute set.
      '';
      example = {
        appservice = {
          database = {
            type = "postgres";
            uri = "postgresql:///mautrix_signal?host=/run/postgresql";
          };
          id = "signal";
          ephemeral_events = false;
        };
        bridge = {
          history_sync = {
            request_full_sync = true;
          };
          private_chat_portal_meta = true;
          mute_bridging = true;
          encryption = {
            allow = true;
            default = true;
            require = true;
          };
          provisioning = {
            shared_secret = "disable";
          };
          permissions = {
            "example.com" = "user";
          };
        };
      };
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        File containing environment variables to be passed to the mautrix-signal service.
        If an environment variable `MAUTRIX_SIGNAL_BRIDGE_LOGIN_SHARED_SECRET` is set,
        then its value will be used in the configuration file for the option
        `login_shared_secret_map` without leaking it to the store, using the configured
        `homeserver.domain` as key.
        See [here](https://github.com/mautrix/signal/blob/main/example-config.yaml)
        for the documentation of `login_shared_secret_map`.
      '';
    };

    serviceDependencies = lib.mkOption {
      type = with lib.types; listOf str;
      default =
        (lib.optional config.services.matrix-synapse.enable config.services.matrix-synapse.serviceUnit)
        ++ (lib.optional config.services.matrix-conduit.enable "conduit.service");
      defaultText = lib.literalExpression ''
        (optional config.services.matrix-synapse.enable config.services.matrix-synapse.serviceUnit)
        ++ (optional config.services.matrix-conduit.enable "conduit.service")
      '';
      description = ''
        List of systemd units to require and wait for when starting the application service.
      '';
    };

    registerToSynapse = lib.mkOption {
      type = lib.types.bool;
      default = config.services.matrix-synapse.enable;
      defaultText = lib.literalExpression ''
        config.services.matrix-synapse.enable
      '';
      description = ''
        Whether to add the bridge's app service registration file to
        `services.matrix-synapse.settings.app_service_config_files`.
      '';
    };
  };

  config = lib.mkIf cfg.enable {

    users.users.mautrix-signal = {
      isSystemUser = true;
      group = "mautrix-signal";
      home = dataDir;
      description = "Mautrix-Signal bridge user";
    };

    users.groups.mautrix-signal = { };

    services.matrix-synapse = lib.mkIf cfg.registerToSynapse {
      settings.app_service_config_files = [ registrationFile ];
    };
    systemd.services.matrix-synapse = lib.mkIf cfg.registerToSynapse {
      serviceConfig.SupplementaryGroups = [ "mautrix-signal" ];
    };

    # Note: this is defined here to avoid the docs depending on `config`
    services.mautrix-signal.settings.homeserver = optOneOf (
      with config.services;
      [
        (lib.mkIf matrix-synapse.enable (mkDefaults {
          domain = matrix-synapse.settings.server_name;
        }))
        (lib.mkIf matrix-conduit.enable (mkDefaults {
          domain = matrix-conduit.settings.global.server_name;
          address = "http://localhost:${toString matrix-conduit.settings.global.port}";
        }))
      ]
    );

    systemd.services.mautrix-signal = {
      description = "mautrix-signal, a Matrix-Signal puppeting bridge.";

      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ] ++ cfg.serviceDependencies;
      after = [ "network-online.target" ] ++ cfg.serviceDependencies;
      # ffmpeg is required for conversion of voice messages
      path = [ pkgs.ffmpeg-headless ];

      preStart = ''
        # substitute the settings file by environment variables
        # in this case read from EnvironmentFile
        test -f '${settingsFile}' && rm -f '${settingsFile}'
        old_umask=$(umask)
        umask 0177
        ${pkgs.envsubst}/bin/envsubst \
          -o '${settingsFile}' \
          -i '${settingsFileUnsubstituted}'
        umask $old_umask

        # generate the appservice's registration file if absent
        if [ ! -f '${registrationFile}' ]; then
          ${pkgs.mautrix-signal}/bin/mautrix-signal \
            --generate-registration \
            --config='${settingsFile}' \
            --registration='${registrationFile}'
        fi
        chmod 640 ${registrationFile}

        umask 0177
        # 1. Overwrite registration tokens in config
        # 2. If environment variable MAUTRIX_SIGNAL_BRIDGE_LOGIN_SHARED_SECRET
        #    is set, set it as the login shared secret value for the configured
        #    homeserver domain.
        ${pkgs.yq}/bin/yq -s '.[0].appservice.as_token = .[1].as_token
          | .[0].appservice.hs_token = .[1].hs_token
          | .[0]
          | if env.MAUTRIX_SIGNAL_BRIDGE_LOGIN_SHARED_SECRET then .bridge.login_shared_secret_map.[.homeserver.domain] = env.MAUTRIX_SIGNAL_BRIDGE_LOGIN_SHARED_SECRET else . end' \
          '${settingsFile}' '${registrationFile}' > '${settingsFile}.tmp'
        mv '${settingsFile}.tmp' '${settingsFile}'
        umask $old_umask
      '';

      serviceConfig = {
        User = "mautrix-signal";
        Group = "mautrix-signal";
        EnvironmentFile = cfg.environmentFile;
        StateDirectory = baseNameOf dataDir;
        WorkingDirectory = dataDir;
        ExecStart = ''
          ${pkgs.mautrix-signal}/bin/mautrix-signal \
          --config='${settingsFile}' \
          --registration='${registrationFile}'
        '';
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectSystem = "strict";
        Restart = "on-failure";
        RestartSec = "30s";
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallErrorNumber = "EPERM";
        SystemCallFilter = [ "@system-service" ];
        Type = "simple";
        UMask = 27;
      };
      restartTriggers = [ settingsFileUnsubstituted ];
    };
  };
  meta.maintainers = with lib.maintainers; [ niklaskorz ];
}
