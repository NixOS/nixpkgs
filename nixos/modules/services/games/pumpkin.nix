{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.pumpkin;

  settingsFormat = pkgs.formats.toml { };
  jsonFormat = pkgs.formats.json { };

  hasSecret = path: settings: (lib.attrByPath path null settings) != null;

  filterNulls =
    v: if lib.isAttrs v then lib.mapAttrs (_: filterNulls) (lib.filterAttrs (_: x: x != null) v) else v;

  settingsWithoutSecrets = filterNulls (
    cfg.settings
    // {
      networking = cfg.settings.networking // {
        rcon =
          (builtins.removeAttrs cfg.settings.networking.rcon [ "passwordFile" ])
          // lib.optionalAttrs (cfg.settings.networking.rcon.passwordFile != null) {
            password = "@PUMPKIN_RCON_PASSWORD@";
          };
        proxy = cfg.settings.networking.proxy // {
          velocity =
            (builtins.removeAttrs cfg.settings.networking.proxy.velocity [ "secretFile" ])
            // lib.optionalAttrs (cfg.settings.networking.proxy.velocity.secretFile != null) {
              secret = "@PUMPKIN_VELOCITY_SECRET@";
            };
        };
      };
    }
  );

  configFile = settingsFormat.generate "pumpkin.toml" settingsWithoutSecrets;

  whitelistFile = jsonFormat.generate "whitelist.json" cfg.whitelist.entries;
in
{
  meta.maintainers = with lib.maintainers; [
    DerGrumpf
    jk
  ];

  options.services.pumpkin = {
    enable = lib.mkEnableOption "Pumpkin, a Minecraft server written in Rust";

    package = lib.mkPackageOption pkgs "pumpkin" { };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to open the firewall for the ports enabled under
        {option}`services.pumpkin.settings.networking`.
      '';
      example = true;
    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/pumpkin";
      description = ''
        Directory holding Pumpkin's state (config, worlds, logs, etc.).
        If this is a subdirectory of `/var/lib`, it is managed automatically
        via systemd's `StateDirectory`; otherwise you are responsible for
        ensuring the directory exists with the correct permissions.
      '';
      example = "/srv/pumpkin";
    };

    whitelist.entries = lib.mkOption {
      type = lib.types.listOf (
        lib.types.submodule {
          options = {
            uuid = lib.mkOption {
              type = lib.types.str;
              description = "The player's UUID, in dashed form.";
            };
            name = lib.mkOption {
              type = lib.types.str;
              description = "The player's username.";
            };
          };
        }
      );
      default = [ ];
      description = ''
        Initial whitelist entries. Written to `whitelist.json` only if
        that file doesn't already exist, since it's normally managed at
        runtime via in-game/console `/whitelist` commands; changes made
        this way are not overwritten by later rebuilds.
      '';
      example = [
        {
          uuid = "069a79f4-44e9-4726-a5be-fca90e38aaf5";
          name = "Notch";
        }
      ];
    };

    settings = lib.mkOption {
      description = ''
        Structured configuration written to `pumpkin.toml`, following
        [RFC 42](https://github.com/NixOS/rfcs/blob/master/rfcs/0042-config-option.md).
        Any field not covered by a typed option below can still be set via
        this freeform `settings` attrset. See upstream's default generated
        `pumpkin.toml` and the `pumpkin-config` crate source for the full
        field list.

        ::: {.warning}
        Do not set `networking.rcon.password` or
        `networking.proxy.velocity.secret` here — they would end up
        world-readable in the Nix store. Use
        {option}`services.pumpkin.settings.networking.rcon.passwordFile` and
        {option}`services.pumpkin.settings.networking.proxy.velocity.secretFile`
        instead; setting either password/secret directly is rejected at
        eval time.
        :::
      '';
      default = { };
      example = lib.literalExpression ''
        {
          seed = "1785537519969227430";
          server_links.custom.discord = "https://discord.gg/example";
        }
      '';
      type = lib.types.submodule {
        freeformType = settingsFormat.type;

        options = {
          default_difficulty = lib.mkOption {
            type = lib.types.enum [
              "Peaceful"
              "Easy"
              "Normal"
              "Hard"
            ];
            default = "Normal";
            description = "Default game difficulty.";
            example = "Hard";
          };
          op_permission_level = lib.mkOption {
            type = lib.types.enum [
              0
              2
              3
              4
            ];
            default = 4;
            description = ''
              Permission level assigned to players by the /op command. Note:
              upstream's deserializer currently rejects the value `1` due to a
              missing match arm — only 0, 2, 3, and 4 are accepted.
            '';
          };
          allow_nether = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Whether the Nether dimension is enabled.";
          };
          allow_end = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Whether the End dimension is enabled.";
          };
          hardcore = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Whether the server runs in hardcore mode.";
            example = true;
          };
          tps = lib.mkOption {
            type = lib.types.float;
            default = 20.0;
            description = "Server ticks per second.";
          };
          default_gamemode = lib.mkOption {
            type = lib.types.enum [
              "Survival"
              "Creative"
              "Adventure"
              "Spectator"
            ];
            default = "Survival";
            description = "Default gamemode assigned to new players.";
            example = "Creative";
          };
          force_gamemode = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Whether to force the default gamemode on every join.";
            example = true;
          };
          scrub_ips = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Whether to remove IP addresses from logs.";
          };
          use_favicon = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Whether to serve a favicon to clients.";
          };
          favicon_path = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "Path to an optional server favicon.";
            example = "favicon.png";
          };
          default_level_name = lib.mkOption {
            type = lib.types.str;
            default = "world";
            description = "Name of the default level/world folder.";
          };
          allow_chat_reports = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Whether players can send signed chat reports.";
            example = true;
          };
          seed = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "Seed string for world generation.";
            example = "11238910";
          };

          white_list = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Whether the whitelist is active.";
          };
          enforce_whitelist = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Whether to kick already-connected players who aren't whitelisted.";
          };

          logging = {
            enabled = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Whether Pumpkin's internal logging is enabled.";
            };
            threads = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Whether to include thread names in log output.";
            };
            color = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Whether to colorize log output.";
            };
            timestamp = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Whether to include timestamps in log output.";
            };
            file = lib.mkOption {
              type = lib.types.str;
              default = "latest.log";
              description = "Log file name, relative to the state directory.";
              example = "pumpkin.log";
            };
          };

          resource_pack = {
            java = {
              enabled = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = "Whether to require a Java Edition resource pack.";
                example = true;
              };
              url = lib.mkOption {
                type = lib.types.str;
                default = "";
                description = "URL of the resource pack.";
                example = "https://example.com/resourcepack.zip";
              };
              sha1 = lib.mkOption {
                type = lib.types.str;
                default = "";
                description = "SHA-1 hash of the resource pack.";
                example = "da39a3ee5e6b4b0d3255bfef95601890afd80709";
              };
              prompt_message = lib.mkOption {
                type = lib.types.str;
                default = "";
                description = "Message shown to players when prompted to accept the pack.";
                example = "Please accept the resource pack to join.";
              };
              force = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = "Whether to disconnect players who decline the pack.";
              };
            };
            bedrock = {
              enabled = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = "Whether to require a Bedrock Edition resource pack.";
                example = true;
              };
              force = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = "Whether to disconnect players who decline the pack.";
              };
              packs = lib.mkOption {
                type = lib.types.listOf (lib.types.either lib.types.str (lib.types.attrsOf settingsFormat.type));
                default = [ ];
                description = ''
                  Array of Bedrock resource pack definitions. Entries may be bare
                  strings (e.g. a UUID or path) or tables (e.g. attrsets with
                  name/uuid/version keys), since upstream does not document the
                  entry shape in more detail.
                '';
                example = [ "016d3a32-11f0-4a3f-8b52-8f1c3f1e5b0a" ];
              };
            };
          };

          world = {
            lighting = lib.mkOption {
              type = lib.types.enum [
                "default"
                "full"
                "dark"
              ];
              default = "default";
              description = "Lighting engine mode.";
              example = "full";
            };
            autosave_ticks = lib.mkOption {
              type = lib.types.ints.unsigned;
              default = 6000;
              description = "Ticks between automatic world saves (0 disables autosave).";
              example = 12000;
            };
            chunk = {
              type = lib.mkOption {
                type = lib.types.enum [
                  "anvil"
                  "linear"
                  "pump"
                ];
                default = "anvil";
                description = ''
                  Chunk/world storage format. `anvil` is the modern Vanilla format;
                  `linear` is the more compact third-party format; `pump` is
                  Pumpkin's own optimized format. Only `anvil` uses
                  `write_in_place`/`compression` — they're ignored for the other two.
                '';
                example = "linear";
              };
              write_in_place = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = "Whether to write chunk data in place (anvil only).";
              };
              compression = {
                algorithm = lib.mkOption {
                  type = lib.types.enum [
                    "GZip"
                    "ZLib"
                    "LZ4"
                    "Custom"
                  ];
                  default = "LZ4";
                  description = "Chunk compression algorithm (anvil only).";
                  example = "ZLib";
                };
                level = lib.mkOption {
                  type = lib.types.ints.unsigned;
                  default = 6;
                  description = "Chunk compression level (anvil only).";
                  example = 9;
                };
              };
            };
          };

          networking = {
            query = {
              enabled = lib.mkOption {
                type = lib.types.bool;
                default = true;
                description = "Whether to accept GameSpy4 query connections.";
              };
              address = lib.mkOption {
                type = lib.types.str;
                default = "0.0.0.0:25565";
                description = "Address:port to bind the query listener to.";
              };
            };

            rcon = {
              enabled = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = "Whether to accept RCON connections.";
              };
              address = lib.mkOption {
                type = lib.types.str;
                default = "0.0.0.0:25575";
                description = "Address:port to bind the RCON listener to.";
              };
              max_connections = lib.mkOption {
                type = lib.types.ints.unsigned;
                default = 10;
                description = "Maximum number of simultaneous RCON connections.";
                example = 20;
              };
              logging = {
                logged_successfully = lib.mkOption {
                  type = lib.types.bool;
                  default = true;
                  description = "Whether to log successful RCON logins.";
                };
                wrong_password = lib.mkOption {
                  type = lib.types.bool;
                  default = true;
                  description = "Whether to log failed RCON login attempts.";
                };
                commands = lib.mkOption {
                  type = lib.types.bool;
                  default = true;
                  description = "Whether to log commands run over RCON.";
                };
                quit = lib.mkOption {
                  type = lib.types.bool;
                  default = true;
                  description = "Whether to log RCON client disconnects.";
                };
              };
              passwordFile = lib.mkOption {
                type = lib.types.nullOr lib.types.path;
                default = null;
                description = ''
                  Path to a file containing the RCON password. Loaded securely
                  at service start via systemd's `LoadCredential` and substituted
                  into the generated `pumpkin.toml` in place of a placeholder
                  string, using `replace-secret`; never placed in the Nix store.
                  Compatible with sops-nix and agenix. Does not enable RCON on
                  its own — set
                  {option}`services.pumpkin.settings.networking.rcon.enabled`
                  as well.
                '';
                example = "/run/secrets/pumpkin-rcon-password";
              };
            };

            proxy = {
              enabled = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = "Whether to enable proxy (Velocity/BungeeCord) support.";
                example = true;
              };
              velocity = {
                enabled = lib.mkOption {
                  type = lib.types.bool;
                  default = false;
                  description = "Whether to enable the Velocity modern forwarding protocol.";
                  example = true;
                };
                secretFile = lib.mkOption {
                  type = lib.types.nullOr lib.types.path;
                  default = null;
                  description = ''
                    Path to a file containing the Velocity forwarding secret. Loaded
                    securely at service start via systemd's `LoadCredential` and
                    substituted into the generated `pumpkin.toml` in place of a
                    placeholder string, using `replace-secret`; never placed in the
                    Nix store.
                  '';
                  example = "/run/secrets/pumpkin-velocity-secret";
                };
              };
              bungeecord.enabled = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = "Whether to enable BungeeCord IP forwarding.";
                example = true;
              };
            };

            lan_broadcast.enabled = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Whether to broadcast the server on the local network.";
              example = true;
            };

            java = {
              enabled = lib.mkOption {
                type = lib.types.bool;
                default = true;
                description = "Whether to accept Java Edition connections.";
              };
              address = lib.mkOption {
                type = lib.types.str;
                default = "0.0.0.0:25565";
                description = "Address:port to bind the Java listener to.";
              };
              compression = {
                enabled = lib.mkOption {
                  type = lib.types.bool;
                  default = true;
                  description = "Whether to compress packets.";
                };
                threshold = lib.mkOption {
                  type = lib.types.ints.unsigned;
                  default = 256;
                  description = "Minimum packet size (in bytes) before compression is applied.";
                  example = 512;
                };
                level = lib.mkOption {
                  type = lib.types.ints.unsigned;
                  default = 4;
                  description = "Compression level.";
                  example = 5;
                };
              };
              authentication = {
                enabled = lib.mkOption {
                  type = lib.types.bool;
                  default = true;
                  description = "Whether to require Mojang authentication for Java clients.";
                };
                connect_timeout = lib.mkOption {
                  type = lib.types.ints.unsigned;
                  default = 5000;
                  description = "Timeout (ms) for connecting to the authentication server.";
                };
                read_timeout = lib.mkOption {
                  type = lib.types.ints.unsigned;
                  default = 5000;
                  description = "Timeout (ms) for reading from the authentication server.";
                };
                prevent_proxy_connections = lib.mkOption {
                  type = lib.types.bool;
                  default = false;
                  description = "Whether to reject connections proxied through another server.";
                };
                player_profile = {
                  allow_banned_players = lib.mkOption {
                    type = lib.types.bool;
                    default = false;
                    description = "Whether to allow players Mojang has banned.";
                  };
                  allowed_actions = lib.mkOption {
                    type = lib.types.listOf (
                      lib.types.enum [
                        "FORCED_NAME_CHANGE"
                        "USING_BANNED_SKIN"
                      ]
                    );
                    default = [
                      "FORCED_NAME_CHANGE"
                      "USING_BANNED_SKIN"
                    ];
                    description = "Which flagged-profile actions are still permitted to join.";
                  };
                };
                textures = {
                  enabled = lib.mkOption {
                    type = lib.types.bool;
                    default = true;
                    description = "Whether to fetch player skins/capes/elytras.";
                  };
                  allowed_url_schemes = lib.mkOption {
                    type = lib.types.listOf (
                      lib.types.enum [
                        "http"
                        "https"
                      ]
                    );
                    default = [
                      "http"
                      "https"
                    ];
                    description = "URL schemes allowed for texture URLs.";
                  };
                  allowed_url_domains = lib.mkOption {
                    type = lib.types.listOf lib.types.str;
                    default = [
                      ".minecraft.net"
                      ".mojang.com"
                    ];
                    description = "Domains allowed to serve textures.";
                    example = [ ".mydomain.example" ];
                  };
                  types = {
                    skin = lib.mkOption {
                      type = lib.types.bool;
                      default = true;
                      description = "Whether to load skin textures.";
                    };
                    cape = lib.mkOption {
                      type = lib.types.bool;
                      default = true;
                      description = "Whether to load cape textures.";
                    };
                    elytra = lib.mkOption {
                      type = lib.types.bool;
                      default = true;
                      description = "Whether to load elytra textures.";
                    };
                  };
                };
              };
            };

            bedrock = {
              enabled = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = "Whether to accept Bedrock Edition connections.";
              };
              address = lib.mkOption {
                type = lib.types.str;
                default = "0.0.0.0:19132";
                description = "Address:port to bind the Bedrock listener to.";
              };
              compression = {
                enabled = lib.mkOption {
                  type = lib.types.bool;
                  default = true;
                  description = "Whether to compress packets.";
                };
                threshold = lib.mkOption {
                  type = lib.types.ints.unsigned;
                  default = 256;
                  description = "Minimum packet size (in bytes) before compression is applied.";
                  example = 512;
                };
                level = lib.mkOption {
                  type = lib.types.ints.unsigned;
                  default = 4;
                  description = "Compression level.";
                  example = 5;
                };
              };
              authentication = {
                enabled = lib.mkOption {
                  type = lib.types.bool;
                  default = true;
                  description = "Whether to require Xbox Live authentication for Bedrock clients.";
                };
                connect_timeout = lib.mkOption {
                  type = lib.types.ints.unsigned;
                  default = 5000;
                  description = "Timeout (ms) for connecting to the authentication server.";
                };
                read_timeout = lib.mkOption {
                  type = lib.types.ints.unsigned;
                  default = 5000;
                  description = "Timeout (ms) for reading from the authentication server.";
                };
              };
            };
          };

          commands = {
            use_console = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Whether the server console accepts commands.";
            };
            use_tty = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Whether to use a TTY for the console.";
            };
            log_console = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Whether to log console command usage.";
            };
            broadcast_console_to_ops = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Whether to broadcast console commands to operators.";
            };
            default_op_level = lib.mkOption {
              type = lib.types.ints.between 0 4;
              default = 0;
              description = "Default operator permission level assigned via the console.";
              example = 4;
            };
          };

          chat.format = lib.mkOption {
            type = lib.types.str;
            default = "<{DISPLAYNAME}> {MESSAGE}";
            description = "Chat message format template.";
            example = "[{DISPLAYNAME}]: {MESSAGE}";
          };

          pvp = {
            enabled = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Whether player-vs-player combat is allowed.";
            };
            hurt_animation = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Whether to show the hurt animation on PvP damage.";
            };
            protect_creative = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Whether creative-mode players are protected from PvP damage.";
            };
            knockback = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Whether PvP hits apply knockback.";
            };
            swing = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Whether to show the attack swing animation.";
            };
          };

          server_links = {
            enabled = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Whether to advertise server links to clients.";
            };
            bug_report = lib.mkOption {
              type = lib.types.str;
              default = "https://github.com/Pumpkin-MC/Pumpkin/issues";
              description = "Bug report link.";
            };
            support = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = "Support link.";
              example = "https://example.com/support";
            };
            status = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = "Status page link.";
              example = "https://status.example.com";
            };
            feedback = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = "Feedback link.";
              example = "https://example.com/feedback";
            };
            community = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = "Community link.";
              example = "https://discord.gg/example";
            };
            website = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = "Website link.";
              example = "https://example.com";
            };
            forums = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = "Forums link.";
              example = "https://forums.example.com";
            };
            news = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = "News link.";
              example = "https://example.com/news";
            };
            announcements = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = "Announcements link.";
              example = "https://example.com/announcements";
            };
            # server_links.custom is intentionally left to the freeform part
            # of `settings`, since its shape is user-defined key/value pairs.
          };

          player_data = {
            save_player_data = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Whether to persist player data.";
            };
            save_player_cron_interval = lib.mkOption {
              type = lib.types.ints.unsigned;
              default = 300;
              description = "Interval, in seconds, between player data saves.";
              example = 600;
            };
          };

          fun.april_fools = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Whether to enable April Fools' Day easter eggs.";
          };

          recipe.send_recipes = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Whether to send the recipe book to clients.";
          };

          plugins.blocked_permissions = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ ];
            description = "Permissions plugins are blocked from granting.";
            example = [ "pumpkin.admin" ];
          };

          advancement.save_advancements = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Whether to persist player advancement progress.";
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = !(hasSecret [ "networking" "rcon" "password" ] cfg.settings);
        message = "services.pumpkin: `settings.networking.rcon.password` is not allowed (world-readable in the Nix store). Use `settings.networking.rcon.passwordFile` instead.";
      }
      {
        assertion = !(hasSecret [ "networking" "proxy" "velocity" "secret" ] cfg.settings);
        message = "services.pumpkin: `settings.networking.proxy.velocity.secret` is not allowed (world-readable in the Nix store). Use `settings.networking.proxy.velocity.secretFile` instead.";
      }
    ];

    systemd.services.pumpkin = {
      description = "Pumpkin Minecraft Server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];

      preStart = ''
        install -m600 ${configFile} "${cfg.dataDir}/pumpkin.toml"
      ''
      + lib.optionalString (cfg.settings.networking.rcon.passwordFile != null) ''
        ${lib.getExe pkgs.replace-secret} '@PUMPKIN_RCON_PASSWORD@' \
          "$CREDENTIALS_DIRECTORY/rcon-password" "${cfg.dataDir}/pumpkin.toml"
      ''
      + lib.optionalString (cfg.settings.networking.proxy.velocity.secretFile != null) ''
        ${lib.getExe pkgs.replace-secret} '@PUMPKIN_VELOCITY_SECRET@' \
          "$CREDENTIALS_DIRECTORY/velocity-secret" "${cfg.dataDir}/pumpkin.toml"
      ''
      + lib.optionalString (cfg.whitelist.entries != [ ]) ''
        if [ ! -e "${cfg.dataDir}/whitelist.json" ]; then
          install -m600 ${whitelistFile} "${cfg.dataDir}/whitelist.json"
        fi
      '';

      serviceConfig = lib.mkMerge [
        (lib.mkIf (lib.hasPrefix "/var/lib/" cfg.dataDir) {
          StateDirectory = lib.last (lib.splitString "/" cfg.dataDir);
        })
        {
          ExecStart = lib.getExe cfg.package;
          LoadCredential =
            lib.optional (
              cfg.settings.networking.rcon.passwordFile != null
            ) "rcon-password:${cfg.settings.networking.rcon.passwordFile}"
            ++ lib.optional (
              cfg.settings.networking.proxy.velocity.secretFile != null
            ) "velocity-secret:${cfg.settings.networking.proxy.velocity.secretFile}";
          Restart = "on-failure";
          RestartSec = 5;
          StartLimitIntervalSec = 120;
          StartLimitBurst = 5;
          TimeoutStopSec = 120;
          LimitNOFILE = 65536;

          DynamicUser = true;
          WorkingDirectory = cfg.dataDir;

          NoNewPrivileges = true;
          PrivateTmp = true;
          ProtectSystem = "strict";
          ProtectHome = true;
          CapabilityBoundingSet = "";
        }
      ];
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts =
        lib.optional cfg.settings.networking.java.enabled (
          lib.toInt (lib.last (lib.splitString ":" cfg.settings.networking.java.address))
        )
        ++ lib.optional (
          cfg.settings.networking.rcon.enabled || cfg.settings.networking.rcon.passwordFile != null
        ) (lib.toInt (lib.last (lib.splitString ":" cfg.settings.networking.rcon.address)));
      allowedUDPPorts = lib.optional cfg.settings.networking.bedrock.enabled (
        lib.toInt (lib.last (lib.splitString ":" cfg.settings.networking.bedrock.address))
      );
    };
  };
}
