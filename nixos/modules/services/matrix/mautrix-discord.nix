{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.services.mautrix-discord;
  dataDir = cfg.dataDir;
  format = pkgs.formats.yaml { };

  registrationFile = "${dataDir}/discord-registration.yaml";

  settingsFile = "${dataDir}/config.yaml";
  settingsFileUnformatted = format.generate "discord-config-unsubstituted.yaml" cfg.settings;
in
{
  options = {
    services.mautrix-discord = {
      enable = lib.mkEnableOption "Mautrix-Discord, a Matrix-Discord puppeting/relay-bot bridge";

      package = lib.mkPackageOption pkgs "mautrix-discord" { };

      settings = lib.mkOption {
        type = lib.types.submodule {
          freeformType = format.type;

          config = {
            _module.args = { inherit cfg lib; };
          };

          options = {
            homeserver = lib.mkOption {
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
                fullDataDiration.
                                See [example-config.yaml](https://github.com/mautrix/discord/blob/main/example-config.yaml)
                                for more information.
              '';
            };

            appservice = lib.mkOption {
              type = lib.types.attrs;
              default = {
                address = "http://localhost:29334";
                hostname = "0.0.0.0";
                port = 29334;
                database = {
                  type = "sqlite3";
                  uri = "file:/var/lib/mautrix-discord/mautrix-discord.db?_txlock=immediate";
                  max_open_conns = 20;
                  max_idle_conns = 2;
                  max_conn_idle_time = null;
                  max_conn_lifetime = null;
                };
                id = "discord";
                bot = {
                  username = "discordbot";
                  displayname = "Discord bridge bot";
                  avatar = "mxc://maunium.net/nIdEykemnwdisvHbpxflpDlC";
                };
                ephemeral_events = true;
                async_transactions = false;
                as_token = "This value is generated when generating the registration";
                hs_token = "This value is generated when generating the registration";
              };
              defaultText = lib.literalExpression ''
                {
                  address = "http://localhost:29334";
                  hostname = "0.0.0.0";
                  port = 29334;
                  database = {
                    type = "sqlite3";
                    uri = "file:''${config.services.mautrix-discord.dataDir}/mautrix-discord.db?_txlock=immediate";
                    max_open_conns = 20;
                    max_idle_conns = 2;
                    max_conn_idle_time = null;
                    max_conn_lifetime = null;
                  };
                  id = "discord";
                  bot = {
                    username = "discordbot";
                    displayname = "Discord bridge bot";
                    avatar = "mxc://maunium.net/nIdEykemnwdisvHbpxflpDlC";
                  };
                  ephemeral_events = true;
                  async_transactions = false;
                  as_token = "This value is generated when generating the registration";
                  hs_token = "This value is generated when generating the registration";
                }
              '';
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
                displayname_template = "{{if .Webhook}}Webhook{{else}}{{or .GlobalName .Username}}{{if .Bot}} (bot){{end}}{{end}}";
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
                prefix_webhook_messages = true;
                enable_webhook_avatars = false;
                use_discord_cdn_upload = true;
                #proxy =
                cache_media = "unencrypted";
                direct_media = {
                  enabled = false;
                  #server_name = "discord-media.example.com";
                  #well_known_response =
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
                double_puppet_server_map = {
                  #"example.com" = "https://example.com";
                };
                double_puppet_allow_discovery = false;
                login_shared_secret_map = {
                  #"example.com" = "foobar";
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
                  #"example.com" = "user";
                  #"@admin:example.com": "admin";
                };
              };
              description = ''
                Bridge configuration.
                See [example-config.yaml](https://github.com/mautrix/discord/blob/main/example-config.yaml)
                for more information.
              '';
            };
            logging = lib.mkOption {
              type = lib.types.attrs;
              default = {
                min_level = "info";
                writers = lib.singleton {
                  type = "stdout";
                  format = "pretty-colored";
                  time_format = " ";
                };
              };
              description = ''
                Logging configuration.
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
              "example.com" = "user";
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

      # TODO: Get upstream to add an environment File option. Refer to https://github.com/NixOS/nixpkgs/pull/404871#issuecomment-2895663652 and https://github.com/mautrix/discord/issues/187
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

      serviceUnit = lib.mkOption {
        type = lib.types.str;
        readOnly = true;
        default = "mautrix-discord.service";
        description = ''
          The systemd unit (a service or a target) for other services to depend on if they
          need to be started after matrix-synapse.
          This option is useful as the actual parent unit for all matrix-synapse processes
          changes when configuring workers.
        '';
      };

      registrationServiceUnit = lib.mkOption {
        type = lib.types.str;
        readOnly = true;
        default = "mautrix-discord-registration.service";
        description = ''
          The registration service that generates the registration file.
          Systemd unit (a service or a target) for other services to depend on if they
          need to be started after mautrix-discord registration service.
          This option is useful as the actual parent unit for all matrix-synapse processes
          changes when configuring workers.
        '';
      };

      serviceDependencies = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          cfg.registrationServiceUnit
        ]
        ++ (lib.lists.optional config.services.matrix-synapse.enable config.services.matrix-synapse.serviceUnit)
        ++ (lib.lists.optional config.services.matrix-conduit.enable "matrix-conduit.service")
        ++ (lib.lists.optional config.services.dendrite.enable "dendrite.service");

        defaultText = ''
          [ cfg.registrationServiceUnit ] ++
          (lib.lists.optional config.services.matrix-synapse.enable config.services.matrix-synapse.serviceUnit) ++
          (lib.lists.optional config.services.matrix-conduit.enable "matrix-conduit.service") ++
          (lib.lists.optional config.services.dendrite.enable "dendrite.service");
        '';
        description = ''
          List of Systemd services to require and wait for when starting the application service.
        '';
      };
    };
  };
  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion =
          cfg.settings.homeserver.domain or "" != "" && cfg.settings.homeserver.address or "" != "";
        message = ''
          The options with information about the homeserver:
          `services.mautrix-discord.settings.homeserver.domain` and
          `services.mautrix-discord.settings.homeserver.address` have to be set.
        '';
      }
      {
        assertion = cfg.settings.bridge.permissions or { } != { };
        message = ''
          The option `services.mautrix-discord.settings.bridge.permissions` has to be set.
        '';
      }
    ];

    users.users.mautrix-discord = {
      isSystemUser = true;
      group = "mautrix-discord";
      extraGroups = [ "mautrix-discord-registration" ];
      home = dataDir;
      description = "Mautrix-Discord bridge user";
    };

    users.groups.mautrix-discord = { };
    users.groups.mautrix-discord-registration = {
      members = lib.lists.optional config.services.matrix-synapse.enable "matrix-synapse";
    };

    services.matrix-synapse = lib.mkIf cfg.registerToSynapse {
      settings.app_service_config_files = [ registrationFile ];
    };

    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir} 770 mautrix-discord mautrix-discord -"
    ];

    systemd.services = {
      matrix-synapse = lib.mkIf cfg.registerToSynapse {
        serviceConfig.SupplementaryGroups = [ "mautrix-discord-registration" ];
        # Make synapse depend on the registration service when auto-registering
        wants = [ "mautrix-discord-registration.service" ];
        after = [ "mautrix-discord-registration.service" ];
      };

      mautrix-discord-registration = {
        description = "Mautrix-Discord registration generation service";

        wantedBy = lib.mkIf cfg.registerToSynapse [ "multi-user.target" ];
        before = lib.mkIf cfg.registerToSynapse [ "matrix-synapse.service" ];

        path = [
          pkgs.yq
          pkgs.envsubst
          cfg.package
        ];

        script = ''
          # substitute the settings file by environment variables
          # in this case read from EnvironmentFile
          rm -f '${settingsFile}'
          old_umask=$(umask)
          umask 0177
          envsubst \
            -o '${settingsFile}' \
            -i '${settingsFileUnformatted}'
          config_has_tokens=$(yq '.appservice | has("as_token") and has("hs_token")' '${settingsFile}')
          registration_already_exists=$([[ -f '${registrationFile}' ]] && echo "true" || echo "false")
          echo "There are tokens in the config: $config_has_tokens"
          echo "Registration already existed: $registration_already_exists"
          # tokens not configured from config/environment file, and registration file
          # is already generated, override tokens in config to make sure they are not lost
          if [[ $config_has_tokens == "false" && $registration_already_exists == "true" ]]; then
            echo "Copying as_token, hs_token from registration into configuration"
            yq -sY '.[0].appservice.as_token = .[1].as_token
              | .[0].appservice.hs_token = .[1].hs_token
              | .[0]' '${settingsFile}' '${registrationFile}' \
              > '${settingsFile}.tmp'
            mv '${settingsFile}.tmp' '${settingsFile}'
          fi
          # make sure --generate-registration does not affect config.yaml
          cp '${settingsFile}' '${settingsFile}.tmp'
          echo "Generating registration file"
          mautrix-discord \
            --generate-registration \
            --config='${settingsFile}.tmp' \
            --registration='${registrationFile}'
          rm '${settingsFile}.tmp'
          # no tokens configured, and new were just generated by generate registration for first time
          if [[ $config_has_tokens == "false" && $registration_already_exists == "false" ]]; then
            echo "Copying newly generated as_token, hs_token from registration into configuration"
            yq -sY '.[0].appservice.as_token = .[1].as_token
              | .[0].appservice.hs_token = .[1].hs_token
              | .[0]' '${settingsFile}' '${registrationFile}' \
              > '${settingsFile}.tmp'
            mv '${settingsFile}.tmp' '${settingsFile}'
          fi
          # make sure --generate-registration does not affect config.yaml
          cp '${settingsFile}' '${settingsFile}.tmp'
          echo "Generating registration file"
          mautrix-discord \
            --generate-registration \
            --config='${settingsFile}.tmp' \
            --registration='${registrationFile}'
          rm '${settingsFile}.tmp'
          # no tokens configured, and new were just generated by generate registration for first time
          if [[ $config_has_tokens == "false" && $registration_already_exists == "false" ]]; then
            echo "Copying newly generated as_token, hs_token from registration into configuration"
            yq -sY '.[0].appservice.as_token = .[1].as_token
              | .[0].appservice.hs_token = .[1].hs_token
              | .[0]' '${settingsFile}' '${registrationFile}' \
              > '${settingsFile}.tmp'
            mv '${settingsFile}.tmp' '${settingsFile}'
          fi
          # Make sure correct tokens are in the registration file
          if [[ $config_has_tokens == "true" || $registration_already_exists == "true" ]]; then
            echo "Copying as_token, hs_token from configuration to the registration file"
            yq -sY '.[1].as_token = .[0].appservice.as_token
              | .[1].hs_token = .[0].appservice.hs_token
              | .[1]' '${settingsFile}' '${registrationFile}' \
              > '${registrationFile}.tmp'
            mv '${registrationFile}.tmp' '${registrationFile}'
          fi
          umask $old_umask
          chown :mautrix-discord-registration '${registrationFile}'
          chmod 640 '${registrationFile}'
        '';

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          UMask = 27;

          User = "mautrix-discord";
          Group = "mautrix-discord";

          SystemCallFilter = [ "@system-service" ];

          ProtectSystem = "strict";
          ProtectHome = true;

          ReadWritePaths = [ dataDir ];
          StateDirectory = "mautrix-discord";
          EnvironmentFile = cfg.environmentFile;
        };

        restartTriggers = [ settingsFileUnformatted ];
      };

      mautrix-discord = {
        description = "Mautrix-Discord, a Matrix-Discord puppeting/relaybot bridge";

        wantedBy = [ "multi-user.target" ];
        wants = [ "network-online.target" ] ++ cfg.serviceDependencies;
        after = [ "network-online.target" ] ++ cfg.serviceDependencies;
        path = [
          pkgs.lottieconverter
          pkgs.ffmpeg-headless
        ];

        serviceConfig = {
          Type = "simple";
          User = "mautrix-discord";
          Group = "mautrix-discord";
          PrivateUsers = true;
          Restart = "on-failure";
          RestartSec = 30;
          WorkingDirectory = dataDir;
          ExecStart = ''
            ${lib.getExe cfg.package} \
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
          ProtectClock = true;

          SystemCallArchitectures = "native";
          SystemCallErrorNumber = "EPERM";
          SystemCallFilter = "@system-service";
          ReadWritePaths = [ cfg.dataDir ];
        };

        restartTriggers = [ settingsFileUnformatted ];
      };
    };

    meta = {
      maintainers = with lib.maintainers; [
        mistyttm
      ];
    };
  };
}
