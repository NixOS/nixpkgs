{
  config,
  lib,
  pkgs,
  utils,
  ...
}:

let
  cfg = config.services.draupnir;

  format = pkgs.formats.yaml { };
  configFile = format.generate "draupnir.yaml" (
    lib.filterAttrsRecursive (_: value: value != null) cfg.settings
  );
in
{
  #region Options
  options.services.draupnir = {
    enable = lib.mkEnableOption "Draupnir, a moderation bot for Matrix";

    package = lib.mkPackageOption pkgs "draupnir" { };

    accessTokenFile = lib.mkOption {
      type = with lib.types; nullOr path;
      default = null;
      description = ''
        File containing the access token for Draupnir's Matrix account.
        Make sure this does not contain newlines if writing manually: `:set noeol nofixeol` for vim or -L for nano.
      '';
    };

    homeserverUrl = lib.mkOption {
      type = lib.types.str;
      description = ''
        Base URL of the Matrix homeserver, that provides the Client-Server API.
        Will be used by either Draupnir directly, or by Pantalaimon, if enabled.
      '';
    };

    #region Pantalaimon options
    pantalaimon = lib.mkOption {
      description = ''
        `pantalaimon` options (enables E2E Encryption support).

        This will create a `pantalaimon` instance with the name "draupnir".
      '';
      default = { };
      type = lib.types.submodule {
        options = {
          enable = lib.mkEnableOption (''
            pantalaimon, in order to enable E2EE support.
            If `true`, accessToken is ignored and the username/password below will be
            used instead. The access token of the bot will be stored in /var/lib/draupnir.
          '');

          username = lib.mkOption {
            type = lib.types.str;
            description = ''
              Account name on the Matrix homeserver.
            '';
          };

          passwordFile = lib.mkOption {
            type = with lib.types; nullOr path;
            default = null;
            description = ''
              File containing the password for the Matrix account.
              Make sure this does not contain newlines if writing manually: `:set noeol nofixeol` for vim or -L for nano.
            '';
          };

          options = lib.mkOption {
            type = lib.types.submodule (
              import ./pantalaimon-options.nix {
                inherit lib;
                inherit config;
                name = "draupnir";
              }
            );
            default = { };
            description = ''
              Pass through additional options to the `pantalaimon` service.
            '';
          };
        };
      };
    };
    #endregion

    #region Draupnir settings
    settings = lib.mkOption {
      example = lib.literalExpression ''
        {
          autojoinOnlyIfManager = true;
          automaticallyRedactForReasons = [ "spam" "advertising" ];
        }
      '';
      description = ''
        Draupnir settings (see [Draupnir's default configuration](https://github.com/the-draupnir-project/Draupnir/blob/main/config/default.yaml) for available settings).
      '';
      default = { };
      type = lib.types.submodule {
        freeformType = format.type;
        options = {
          #region Readonly settings - these settings are not configurable
          dataPath = lib.mkOption {
            type = lib.types.str;
            default = "/var/lib/draupnir";
            readOnly = true;
            description = ''
              The path where Draupnir stores its data.

              ::: {.note}
                If you want to customize where this data is stored, use a bind mount.
              :::
            '';
          };
          #endregion

          #region Base settings
          managementRoom = lib.mkOption {
            type = lib.types.str;
            example = "#moderators:example.org";
            description = ''
              The room ID or alias where moderators can use the bot's functionality.

              The bot has no access controls, so anyone in this room can use the bot - secure this room!

              Warning: When using a room alias, make sure the alias used is on the local homeserver!
              This prevents an issue where the control room becomes undefined when the alias can't be resolved.
            '';
          };
          #endregion
        };
      };
    };
    #endregion
  };
  #endregion

  #region Service configuration
  config = lib.mkIf cfg.enable {
    assertions = [
      # pantalaimon enabled - use passwordFile instead of accessTokenFile
      {
        assertion = cfg.pantalaimon.enable -> cfg.pantalaimon.passwordFile != null;
        message = "Set services.draupnir.pantailaimon.passwordFile, as it is required in order to use Pantalaimon.";
      }
      {
        assertion = cfg.pantalaimon.enable -> cfg.accessTokenFile == null;
        message = "Unset services.draupnir.accessTokenFile, as it has no effect when Pantalaimon is enabled.";
      }

      # pantalaimon disabled - use accessTokenFile instead of passwordFile
      {
        assertion = !cfg.pantalaimon.enable -> cfg.accessTokenFile != null;
        message = "Set services.draupnir.accessTokenFile, as it is required in order to use Draupnir without Pantalaimon.";
      }
      {
        assertion = !cfg.pantalaimon.enable -> cfg.pantalaimon.passwordFile == null;
        message = "Unset services.draupnir.pantalaimon.passwordFile, as it has no effect when Pantalaimon is disabled.";
      }
      # Removed options for those migrating from the Mjolnir module - mkRemovedOption module does *not* work with submodules.

      # Noop in v2, but should ideally not be used in mjolnir or 1.x either.
      {
        assertion = (cfg.settings ? protectedRooms) == false;
        message = "Unset services.draupnir.settings.protectedRooms, as it is unsupported on Draupnir. Add these rooms via `!draupnir rooms add` instead.";
      }
    ];

    warnings =
      [ ]
      # Unsupported but available options
      # - Crypto
      ++ lib.optionals (cfg.pantalaimon.enable) [
        ''
          Using Draupnir with Pantalaimon is known to break some features, and is thus unsupported.
                      Encryption support should only be enabled if you require an encrypted management room or use Draupnir in encrypted rooms.''
      ]
      ++ lib.optionals (cfg.settings ? experimentalRustCrypto && cfg.settings.experimentalRustCrypto) [
        ''
          Using Draupnir with experimental Rust Crypto support is untested and unsupported.
                      Encryption support should only be enabled if you require an encrypted management room or use Draupnir in encrypted rooms.''
      ]

      # - Deprecated options
      ++ lib.optionals (cfg.settings ? verboseLogging && cfg.settings.verboseLogging) [
        "Verbose logging in Draupnir is deprecated and may be removed in a future version."
      ];

    services.pantalaimon-headless.instances.draupnir = lib.mkIf cfg.pantalaimon.enable (
      cfg.pantalaimon.options // { homeserver = cfg.homeserverUrl; }
    );
    services.draupnir.settings.homeserverUrl =
      if cfg.pantalaimon.enable then
        (
          with config.services.pantalaimon-headless.instances.draupnir;
          "http://${listenAddress}:${toString listenPort}/"
        )
      else
        cfg.homeserverUrl;
    services.draupnir.settings.pantalaimon = lib.mkIf cfg.pantalaimon.enable ({
      use = true;
      username = cfg.pantalaimon.username;
    });

    systemd.services.draupnir = {
      description = "Draupnir - a moderation bot for Matrix";
      requires = lib.optionals (cfg.pantalaimon.enable) [
        "pantalaimon-draupnir.service"
      ];
      wants = [
        "network-online.target"
        "matrix-synapse.service"
        "conduit.service"
        "dendrite.service"
      ];
      after = [
        "network-online.target"
        "matrix-synapse.service"
        "conduit.service"
        "dendrite.service"
      ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = utils.escapeSystemdExecArgs (
          [
            (lib.getExe cfg.package)
            "--draupnir-config"
            configFile
          ]
          ++ lib.optionals (cfg.pantalaimon.enable && cfg.pantalaimon.passwordFile != null) [
            "--pantalaimon-password-path"
            "/run/credentials/draupnir.service/pantalaimon_password"
          ]
          ++ lib.optionals (!cfg.pantalaimon.enable && cfg.accessTokenFile != null) [
            "--access-token-path"
            "/run/credentials/draupnir.service/access_token"
          ]
        );

        WorkingDirectory = "/var/lib/draupnir";
        StateDirectory = "draupnir";
        StateDirectoryMode = "0700";
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        Restart = "on-failure";

        DynamicUser = true;
        LoadCredential =
          lib.optionals (cfg.accessTokenFile != null) [
            "access_token:${cfg.accessTokenFile}"
          ]
          ++ lib.optionals (cfg.pantalaimon.enable && cfg.pantalaimon.passwordFile != null) [
            "pantalaimon_password:${cfg.pantalaimon.passwordFile}"
          ];
      };
    };
  };
  #endregion

  meta = {
    doc = ./draupnir.md;
    maintainers = with lib.maintainers; [ RorySys ];
  };
}
