{
  lib,
  config,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkOption
    mkIf
    types
    ;
  toml = pkgs.formats.toml { };
  cfg = config.services.hebbot;
  settingsFile = toml.generate "config.toml" cfg.settings;
  stateDirectory = lib.removePrefix "/var/lib/" cfg.dataDir;
in
{
  imports = [
    (lib.mkRemovedOptionModule [ "services" "hebbot" "templates" ] ''
      Hebbot 3.0 uses a single template. Set services.hebbot.template to a
      combined template compatible with Hebbot 3.0 instead.
    '')
  ];

  options.services.hebbot = {
    enable = mkEnableOption "hebbot";
    package = lib.mkPackageOption pkgs "hebbot" { };
    botPasswordFile = mkOption {
      type = types.path;
      description = ''
        A path to the password file for your bot.

        Consider using a path that does not end up in your Nix store
        as it would be world readable.
      '';
    };
    template = mkOption {
      type = types.path;
      description = "Path to the report template used by Hebbot 3.0.";
    };

    environment = mkOption {
      type = types.attrsOf types.str;
      default = { };
      example = {
        HOMESERVER_URL = "https://matrix.example.org";
      };
      description = ''
        Environment variables passed to Hebbot. Set HOMESERVER_URL if the
        homeserver cannot be discovered from the bot's Matrix user ID.
        CONFIG_PATH, TEMPLATE_PATH and STORE_PATH are set by the module.
        Use botPasswordFile rather than setting BOT_PASSWORD here, as these
        values are stored in the world-readable Nix store.
      '';
    };

    dataDir = mkOption {
      type = types.str;
      default = "/var/lib/hebbot";
      description = ''
        The directory where Hebbot stores its stateful data. Must be a
        normalized path below /var/lib, managed by systemd for the dynamic user.
      '';
    };

    settings = mkOption {
      default = { };
      description = ''
        Configuration for Hebbot, see, for examples:

        - <https://github.com/matrix-org/twim-config/blob/master/config.toml>
        - <https://gitlab.gnome.org/Teams/Websites/thisweek.gnome.org/-/blob/main/hebbot/config.toml>
      '';
      type = types.submodule {
        freeformType = toml.type;

        options = {
          bot_user_id = mkOption {
            type = types.str;
            description = ''
              Matrix User ID of the bot.
            '';
          };
          reporting_room_id = mkOption {
            type = types.str;
            description = ''
              Room ID of the room the bot will report to.
            '';
          };
          admin_room_id = mkOption {
            type = types.str;
            description = ''
              Room ID of the room in which the bot is administered.
            '';
          };
          notice_emoji = mkOption {
            type = types.str;
            default = "⭕";
            description = ''
              Emoji the bot uses for a post.
            '';
          };
          restrict_notice = mkOption {
            type = types.bool;
            default = false;
            description = ''
              Restrict section and project reactions to editors, and prevent
              non-editors from approving other users' reports with the notice emoji.
            '';
          };
          min_length = mkOption {
            type = types.ints.unsigned;
            default = 30;
            description = ''
              Reports must exceed this message length in bytes to be stored.
            '';
          };
          ack_text = mkOption {
            type = types.str;
            default = "✅ Thanks for the report {{user}}, I'll store your update!";
            description = ''
              Acknowledgement sent when a report is stored. The placeholder
              {{user}} is replaced with the reporter's display name. Set to an
              empty string to disable acknowledgements.
            '';
          };
          verbs = mkOption {
            type = types.listOf types.str;
            default = [
              "reports"
              "says"
              "announces"
            ];
            description = "Verbs available to the report template for introducing reports.";
          };
          update_config_command = mkOption {
            type = types.str;
            default = "${pkgs.coreutils}/bin/true";
            defaultText = lib.literalExpression ''"''${pkgs.coreutils}/bin/true"'';
            description = ''
              Command executed by !update-config. Defaults to a no-op because the
              configuration and template are managed declaratively by NixOS.
            '';
          };
          editors = mkOption {
            type = types.listOf types.str;
            default = [ ];
            description = ''
              List of Matrix IDs that are editors of this bot.
            '';
          };
          sections = mkOption {
            type = types.listOf (
              types.submodule {
                options = {
                  emoji = mkOption {
                    type = types.str;
                    description = "Reaction emoji used to select this section.";
                  };
                  name = mkOption {
                    type = types.str;
                    description = "Unique section name referenced by projects.";
                  };
                  title = mkOption {
                    type = types.str;
                    description = "Section title available to the report template.";
                  };
                  order = mkOption {
                    type = types.ints.u32;
                    description = "Section sorting order, from lowest to highest.";
                  };
                  usual_reporters = mkOption {
                    type = types.listOf types.str;
                    default = [ ];
                    description = "Matrix user IDs whose reports belong in this section by default.";
                  };
                };
              }
            );
            default = [ ];
            description = "Sections into which reports can be grouped.";
          };
          projects = mkOption {
            type = types.listOf (
              types.submodule {
                options = {
                  emoji = mkOption {
                    type = types.str;
                    description = "Reaction emoji used to select this project.";
                  };
                  name = mkOption {
                    type = types.str;
                    description = "Unique project name.";
                  };
                  title = mkOption {
                    type = types.str;
                    description = "Project title available to the report template.";
                  };
                  description = mkOption {
                    type = types.str;
                    description = "Project description available to the report template.";
                  };
                  website = mkOption {
                    type = types.str;
                    description = "Project website URL available to the report template.";
                  };
                  default_section = mkOption {
                    type = types.str;
                    description = "Name of the section used for this project by default.";
                  };
                };
              }
            );
            default = [ ];
            description = "Projects to which reports can be assigned.";
          };
        };
      };
    };
  };

  config = mkIf cfg.enable {
    warnings =
      lib.optional (cfg.environment ? BOT_PASSWORD)
        "services.hebbot.environment.BOT_PASSWORD will be overwritten by the startup script. Use services.hebbot.botPasswordFile instead.";

    assertions = [
      {
        assertion =
          lib.hasPrefix "/var/lib/" cfg.dataDir
          && lib.all (part: part != "" && part != "." && part != "..") (lib.splitString "/" stateDirectory)
          && !(lib.hasInfix "\n" cfg.dataDir)
          && !(lib.hasInfix "\r" cfg.dataDir)
          && !(lib.hasInfix ":" cfg.dataDir)
          && !(lib.hasInfix "%" cfg.dataDir);
        message = "services.hebbot.dataDir must be a normalized path strictly below /var/lib without colons, percent signs or newlines.";
      }
    ];

    services.hebbot.environment = {
      CONFIG_PATH = lib.mkDefault (toString settingsFile);
      TEMPLATE_PATH = lib.mkDefault (toString cfg.template);
      STORE_PATH = lib.mkDefault "${cfg.dataDir}/store.json";
    };
    systemd.services.hebbot = {
      description = "hebbot - a TWIM-style Matrix bot written in Rust";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      environment = cfg.environment;
      script = ''
        export BOT_PASSWORD="$(cat "$CREDENTIALS_DIRECTORY/bot-password-file")"
        exec ${lib.getExe cfg.package}
      '';
      serviceConfig = {
        LoadCredential = "bot-password-file:${cfg.botPasswordFile}";
        StateDirectory = stateDirectory;
        StateDirectoryMode = "0700";
        WorkingDirectory = cfg.dataDir;

        DynamicUser = true;
        PrivateTmp = true;
        ProtectHome = true;
        ProtectSystem = "strict";
        NoNewPrivileges = true;
        UMask = "0077";

        Restart = "on-failure";
        RestartSec = "10s";
      };
    };
  };
  meta = {
    maintainers = with lib.maintainers; [ skowalak ];
    teams = [ lib.teams.matrix ];
  };
}
