{
  lib,
  config,
  pkgs,
}:
let
  cfg = config.services.mautrix-discord;
  dataDir = cfg.dataDir;
  format = pkgs.formats.yaml { };

  registrationFile = "${dataDir}/discord-registration.yaml";
  registrationFileUnformatted = format.generate "discord-registration-unsubstituted.yaml" cfg.settings;

  settingsFile = "${dataDir}/config.yaml";
  settingsFileUnformatted = format.generate "discord-config-unsubstituted.yaml" cfg.settings;
in
{
  options = {
    services.mautrix-discord = {
      enable = lib.mkEnableOption "Mautrix-Discord, a Matrix-Discord puppeting/relay-bot bridge";

      settings = lib.mkOption {
        type = lib.types.submodule {
          freeformType = format.type;

          # Pass `cfg` into the module so we can refer to other values within
          # this submodule definition.
          # This gives us access to `config.settings.appservice.port`, etc.
          _module.args = { inherit cfg lib; };

          options = {
            homeserver = {
              type = lib.types.attrs;
              default = {
                software = "standard";
                status_endpoint = null;
                message_send_checkpoint_endpoint = null;
                async_media = false;
                websocket = false;
                ping_interval_seconds = 0;
              };
              description = ''
                Homeserver configuration.
                See [example-config.yaml](https://github.com/mautrix/discord/blob/main/example-config.yaml)
                for more information.
              '';
            };
            appservice = lib.mkOption {
              type = lib.types.submodule {
                options = {
                  hostname = lib.mkOption {
                    type = lib.types.str;
                    default = "0.0.0.0";
                    description = "Hostname for the appservice.";
                  };

                  port = lib.mkOption {
                    type = lib.types.port;
                    default = 29334;
                    description = "Port for the appservice.";
                  };

                  address = lib.mkOption {
                    type = lib.types.str;
                    default = lib.mkDefault "http://localhost:${toString config.services.mautrix-discord.settings.appservice.port}";
                    description = "Address for the appservice.";
                  };

                  database = lib.mkOption {
                    type = lib.types.attrs;
                    default = {
                      type = "postgres";
                      uri = "postgres://user:password@host/database?sslmode=disable";
                      max_open_conns = 20;
                      max_idle_conns = 2;
                      max_conn_idle_time = null;
                      max_conn_lifetime = null;
                    };
                    description = "Database configuration for the appservice.";
                  };

                  id = lib.mkOption {
                    type = lib.types.str;
                    default = "discord";
                    description = "Appservice ID.";
                  };

                  bot = lib.mkOption {
                    type = lib.types.attrs;
                    default = {
                      username = "discordbot";
                      displayname = "Discord bridge bot";
                      avatar = "mxc://maunium.net/nIdEykemnwdisvHbpxflpDlC";
                    };
                    description = "Bot configuration.";
                  };

                  ephemeral_events = lib.mkOption {
                    type = lib.types.bool;
                    default = true;
                    description = "Enable ephemeral events.";
                  };

                  async_transactions = lib.mkOption {
                    type = lib.types.bool;
                    default = false;
                    description = "Enable asynchronous transactions.";
                  };
                };
              };
              description = ''
                Appservice configuration.
                See [example-config.yaml](https://github.com/mautrix/discord/blob/main/example-config.yaml)
                for more information.
              '';
            };

            bridge = lib.mkOption {
              type = lib.types.attrs;
              default = {
                username_template = "discord_{{.}}";
                displayname_template = "{{or .GlobalName .Username}}{{if .Bot}} (bot){{end}}";
                channel_name_template = "{{if or (eq .Type 3) (eq .Type 4)}}{{.Name}}{{else}}#{{.Name}}{{end}}";
                guild_name_template = "{{.Name}}";
                private_chat_portal_meta = "default";
                public_address = null;
                avatar_proxy_key = "generate";
                portal_message_buffer = 128;
                startup_private_channel_create_limit = 5;
                delivery_receipts = false;
                message_status_events = false;
                message_error_notices = true;
                restricted_rooms = true;
                autojoin_thread_on_open = true;
                embed_fields_as_tables = true;
                mute_channels_on_create = false;
                sync_direct_chat_list = false;
                resend_bridge_info = false;
                custom_emoji_reactions = true;
                delete_portal_on_channel_delete = false;
                delete_guild_on_leave = true;
                federate_rooms = true;
                prefix_webhook_messages = false;
                enable_webhook_avatars = true;
                use_discord_cdn_upload = true;
                cache_media = "unencrypted";
                direct_media = {
                  enabled = false;
                  server_name = "discord-media.example.com";
                  allow_proxy = true;
                  server_key = "generate";
                };
                animated_sticker = {
                  target = "webp";
                  args = {
                    width = 320;
                    height = 320;
                    fps = 25;
                  };
                };
                command_prefix = "!discord";
                management_room_text = {
                  welcome = "Hello, I'm a Discord bridge bot.";
                  welcome_connected = "Use `help` for help.";
                  welcome_unconnected = "Use `help` for help or `login` to log in.";
                  additional_help = "";
                };
                backfill = {
                  forward_limits = {
                    initial = {
                      dm = 0;
                      channel = 0;
                      thread = 0;
                    };
                    missed = {
                      dm = 0;
                      channel = 0;
                      thread = 0;
                    };
                    max_guild_members = -1;
                  };
                };
                encryption = {
                  allow = false;
                  default = false;
                  appservice = false;
                  msc4190 = false;
                  require = false;
                  allow_key_sharing = false;
                  plaintext_mentions = false;
                  delete_keys = {
                    delete_outbound_on_ack = false;
                    dont_store_outbound = false;
                    ratchet_on_decrypt = false;
                    delete_fully_used_on_decrypt = false;
                    delete_prev_on_new_session = false;
                    delete_on_device_delete = false;
                    periodically_delete_expired = false;
                    delete_outdated_inbound = false;
                  };
                  verification_levels = {
                    receive = "unverified";
                    send = "unverified";
                    share = "cross-signed-tofu";
                  };
                  rotation = {
                    enable_custom = false;
                    milliseconds = 604800000;
                    messages = 100;
                    disable_device_change_key_rotation = false;
                  };
                };
                provisioning = {
                  prefix = "/_matrix/provision";
                  shared_secret = "generate";
                  debug_endpoints = false;
                };
                permissions = {
                  "*" = "relay";
                  # "example.com" = "user";
                  # "@admin:example.com": "admin";
                };
              };
              description = ''
                Bridge configuration.
                See [example-config.yaml](https://github.com/mautrix/discord/blob/main/example-config.yaml)
                for more information.
              '';
            };
          };
        };
        default = { };
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
          [example-config.yaml](https://github.com/mautrix/discord/blob/main/example-config.yaml).
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

      dataDir = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/mautrix-discord";
        defaultText = "/var/lib/mautrix-discord";
        description = ''
          Directory to store the bridge's configuration and database files.
          This directory will be created if it does not exist.
        '';
      };

      environmentFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = ''
          File containing environment variables to substitute when copying the configuration
          out of Nix store to the `services.mautrix-discord.dataDir`.
          Can be used for storing the secrets without making them available in the Nix store.
          For example, you can set `services.mautrix-discord.settings.appservice.as_token = "$MAUTRIX_DISCORD_APPSERVICE_AS_TOKEN"`
          and then specify `MAUTRIX_DISCORD_APPSERVICE_AS_TOKEN="{token}"` in the environment file.
          This value will get substituted into the configuration file as a token.
        '';
      };
    };
  };
  config = lib.mkIf cfg.enable {
    users.users.mautrix-discord = {
      isSystemUser = true;
      group = "mautrix-discord";
      home = dataDir;
      description = "Mautrix-Discord bridge user";
    };

    users.groups.mautrix-discord = { };

    services.matrix-synapse = lib.mkIf cfg.registerToSynapse {
      settings.app_service_config_files = [ registrationFile ];
    };
    systemd.services.matrix-synapse = lib.mkIf cfg.registerToSynapse {
      serviceConfig.SupplementaryGroups = [ "mautrix-discord" ];
    };
    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir} 770 mautrix-discord mautrix-discord -"
    ];

    systemd.services.mautrix-discord = {
      description = "Mautrix-Discord, a Matrix-Discord puppeting/relaybot bridge";

      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ] ++ cfg.serviceDependencies;
      after = [ "network-online.target" ] ++ cfg.serviceDependencies;
      path = [
        pkgs.lottieconverter
        pkgs.ffmpeg-headless
      ];

      environment.HOME = cfg.dataDir;

      preStart = ''
        # substitute the settings file by environment variables
        # in this case read from EnvironmentFile
        test -f '${settingsFile}' && rm -f '${settingsFile}'
        old_umask=$(umask)
        umask 0177
        ${pkgs.envsubst}/bin/envsubst \
          -o '${settingsFile}' \
          -i '${settingsFileUnformatted}'
        umask $old_umask
        ${pkgs.envsubst}/bin/envsubst \
          -o '${registrationFile}' \
          -i '${registrationFileUnformatted}'
        chmod 644 ${registrationFile}
      '';

      serviceConfig = {
        User = "mautrix-discord";
        Group = "mautrix-discord";
        Type = "exec";
        Restart = "on-failure";
        RestartSec = 30;
        WorkingDirectory = cfg.dataDir;
        ExecStart = ''
          ${lib.getExe pkgs.mautrix-discord} \
            --config='${settingsFile}'
        '';
        EnvironmentFile = cfg.environmentFile;

        ProtectSystem = "strict";
        ProtectHome = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        PrivateDevices = true;
        PrivateTmp = true;
        RestrictSUIDSGID = true;
        RestrictRealtime = true;
        LockPersonality = true;
        ProtectKernelLogs = true;
        ProtectHostname = true;
        PrivateUsers = true;
        ProtectClock = true;

        SystemCallArchitectures = "native";
        SystemCallErrorNumber = "EPERM";
        SystemCallFilter = "@system-service";
        ReadWritePaths = [ cfg.dataDir ];
      };
    };
  };
  meta = {
    maintainers = with lib.maintainers; [
      mistyttm
    ];
  };
}
