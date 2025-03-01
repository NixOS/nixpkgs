{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.services.mautrix-slack;
  dataDir = "/var/lib/mautrix-slack";
  registrationFile = "${dataDir}/slack-registration.yaml";
  settingsFile = "${dataDir}/config.json";
  settingsFileUnsubstituted = settingsFormat.generate "mautrix-slack-config-unsubstituted.json" cfg.settings;
  settingsFormat = pkgs.formats.json { };
  appservicePort = 29319;

  mkDefaults = lib.mapAttrsRecursive (n: v: lib.mkDefault v);
  defaultConfig = {
    homeserver.address = "http://localhost:8448";
    appservice = {
      hostname = "[::]";
      port = appservicePort;
      database.type = "sqlite3";
      database.uri = "${dataDir}/mautrix-slack.db";
      id = "slack";
      bot.username = "slackbot";
      bot.displayname = "Slack Bridge Bot";
      as_token = "";
      hs_token = "";
    };
    bridge = {
      username_template = "slack_{{.}}";
      displayname_template = "{{.RealName}} (S)";
      bot_displayname_template = "{{.Name}} (bot)";
      channel_name_template = "#{{.Name}}";
      double_puppet_server_map = { };
      login_shared_secret_map = { };
      command_prefix = "!slack";
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
  options.services.mautrix-slack = {
    enable = lib.mkEnableOption "mautrix-slack, a puppeting/relaybot bridge between Matrix and Slack.";

    package = lib.mkPackageOption pkgs "mautrix-slack" { };

    user = lib.mkOption {
      default = "mautrix-slack";
      type = lib.types.str;
      description = "User the mautrix-slack bridge runs as.";
    };
    group = lib.mkOption {
      default = "mautrix-slack";
      type = lib.types.str;
      description = "Group the mautrix-slack bridge runs as.";
    };

    settings = lib.mkOption {
      type = settingsFormat.type;
      default = defaultConfig;
      description = ''
        {file}`config.yaml` configuration as a Nix attribute set.
        Configuration options should match those described in
        [example-config.yaml](https://github.com/mautrix/slack/blob/master/example-config.yaml).
        Secret tokens should be specified using {option}`environmentFile`
        instead of this world-readable attribute set.
      '';
      example = {
        appservice = {
          database = {
            type = "postgres";
            uri = "postgresql:///mautrix_slack?host=/run/postgresql";
          };
          id = "slack";
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
        File containing environment variables to be passed to the mautrix-slack service,
        in which secret tokens can be specified securely by optionally defining a value for
        `MAUTRIX_SLACK_BRIDGE_LOGIN_SHARED_SECRET`.
      '';
    };

    serviceDependencies = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = lib.optional config.services.matrix-synapse.enable config.services.matrix-synapse.serviceUnit;
      defaultText = lib.literalExpression ''
        optional config.services.matrix-synapse.enable config.services.matrix-synapse.serviceUnits
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
      description = "Mautrix-Slack bridge user";
    };

    users.groups.${cfg.group} = { };

    services.matrix-synapse = lib.mkIf cfg.registerToSynapse {
      settings.app_service_config_files = [ registrationFile ];
    };
    systemd.services.matrix-synapse = lib.mkIf cfg.registerToSynapse {
      serviceConfig.SupplementaryGroups = [ cfg.group ];
    };

    services.mautrix-slack.settings = lib.mkMerge (
      map mkDefaults [
        defaultConfig
        # Note: this is defined here to avoid the docs depending on `config`
        {
          homeserver.domain = config.services.matrix-synapse.settings.server_name;
        }
      ]
    );

    systemd.services.mautrix-slack = {
      description = "Mautrix-Slack Service - A Slack bridge for Matrix";

      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ] ++ cfg.serviceDependencies;
      after = [ "network-online.target" ] ++ cfg.serviceDependencies;

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
          ${cfg.package}/bin/mautrix-slack \
            --generate-registration \
            --config='${settingsFile}' \
            --registration='${registrationFile}'
        fi
        chmod 640 ${registrationFile}

        umask 0177
        ${pkgs.yq}/bin/yq -s '.[0].appservice.as_token = .[1].as_token
          | .[0].appservice.hs_token = .[1].hs_token
          | .[0]' '${settingsFile}' '${registrationFile}' \
          > '${settingsFile}.tmp'
        mv '${settingsFile}.tmp' '${settingsFile}'
        umask $old_umask
      '';

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        EnvironmentFile = cfg.environmentFile;
        StateDirectory = baseNameOf dataDir;
        WorkingDirectory = dataDir;
        ExecStart = ''
          ${cfg.package}/bin/mautrix-slack \
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
  meta.maintainers = with lib.maintainers; [ BonusPlay ];
}
