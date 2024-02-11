{ config, lib, pkgs, utils, ... }:

with lib;
let
  cfg = config.services.draupnir;

  format = pkgs.formats.yaml {};
  configFile = format.generate "draupnir.yaml" cfg.settings;
in
{
  #region Options
  options.services.draupnir = {
    enable = mkEnableOption (lib.mdDoc "Draupnir, a moderation tool for Matrix");

    accessTokenFile = mkOption {
      type = with types; nullOr path;
      default = null;
      description = lib.mdDoc ''
        File containing the access token for Draupnir's Matrix account.
      '';
    };

    #region Pantalaimon options
    pantalaimon = mkOption {
      description = lib.mdDoc ''
        `pantalaimon` options (enables E2E Encryption support).

        This will create a `pantalaimon` instance with the name "draupnir".
      '';
      default = { };
      type = types.submodule {
        options = {
          enable = mkEnableOption (lib.mdDoc ''
            pantalaimon, in order to enable E2EE support.
            If `true`, accessToken is ignored and the username/password below will be
            used instead. The access token of the bot will be stored in /var/lib/draupnir.
          '');

          homeserver = mkOption {
            type = types.str;
            description = lib.mdDoc ''
              Account name on the Matrix homeserver.
            '';
          };

          username = mkOption {
            type = types.str;
            description = lib.mdDoc ''
              Account name on the Matrix homeserver.
            '';
          };

          passwordFile = mkOption {
            type = with types; nullOr path;
            default = null;
            description = lib.mdDoc ''
              File containing the password for the Matrix account.
            '';
          };

          options = mkOption {
            type = types.submodule (import ./pantalaimon-options.nix);
            default = { };
            description = lib.mdDoc ''
              Pass through additional options to the `pantalaimon` service.
            '';
          };
        };
      };
    };
    #endregion

    #region Draupnir settings
    settings = mkOption {
      example = literalExpression ''
        {
          autojoinOnlyIfManager = true;
          automaticallyRedactForReasons = [ "spam" "advertising" ];
        }
      '';
      description = lib.mdDoc ''
        Draupnir settings (see [Draupnir's default configuration](https://github.com/the-draupnir-project/Draupnir/blob/main/config/default.yaml) for available settings).
        These settings will override settings made by the module config.
      '';
      default = { };
      type = types.submodule {
        freeformType = format.type;
        options = {
          #region Readonly settings - these settings are not configurable
          dataPath = mkOption {
            type = types.str;
            default = "/var/lib/draupnir";
            readOnly = true;
            description = lib.mdDoc ''
              The path where Draupnir stores its data.

              ::: {.note}
                If you want to customize where this data is stored, use a bind mount.
              :::
            '';
          };

          pantalaimon = mkOption {
            readOnly = true;
            description = lib.mdDoc ''
              `pantalaimon` settings (enables E2E Encryption support).
              This property is read-only, please configure `services.draupnir.pantalaimon` instead!
            '';
            default = {};
            type = types.submodule {
              freeformType = format.type;
              options = {
                use = mkOption {
                  type = types.bool;
                  default = if cfg.pantalaimon.enable then true else false;
                  readOnly = true;
                  description = lib.mdDoc ''
                    Whether to use `pantalaimon` for E2E encryption. Enabled if `services.draupnir.pantalaimon.enable` is `true`.
                  '';
                };
                username = mkOption {
                  type = types.str;
                  default = cfg.pantalaimon.username;
                  readOnly = true;
                  description = lib.mdDoc ''
                    Account name on the Matrix homeserver. Configured in `services.draupnir.pantalaimon.username`.
                  '';
                };
              };
            };
          };
          #endregion

          #region Base settings
          homeserverUrl = mkOption {
            type = types.str;
            default = if cfg.pantalaimon.enable 
              then "http://${config.services.pantalaimon-headless.instances."draupnir".listenAddress}:${toString config.services.pantalaimon-headless.instances."draupnir".listenPort}/"
              else "https://matrix.org";
            readOnly = if cfg.pantalaimon.enable then true else false;
            description = lib.mdDoc ''
              Base URL of the Matrix homeserver, that provides the Client-Server API.

              If `pantalaimon.enable` is `true`, this option will become read only. Configure `pantalaimon.homeserver` instead in that case.
              The listen address of `pantalaimon` will then become the `homeserverUrl` of `draupnir`.
            '';
          };
          #endregion

          #region Common settings
          autojoinOnlyIfManager = mkOption {
            type = types.bool;
            default = false;
            description = lib.mdDoc ''
              If `true`, the bot will only autojoin rooms if the user is a manager.
            '';
          };

          automaticallyRedactForReasons = mkOption {
            type = types.listOf types.str;
            default = [ ];
            description = lib.mdDoc ''
              A list of reasons for which the bot will automatically redact messages.
            '';
          };
          managementRoom = mkOption {
            type = types.str;
            default = "#moderators:example.org";
            description = lib.mdDoc ''
              The room ID or alias where moderators can use the bot's functionality.

              The bot has no access controls, so anyone in this room can use the bot - secure this room!

              Warning: When using a room alias, make sure the alias used is on the local homeserver!
              This prevents an issue where the control room becomes undefined when the alias can't be resolved.
            '';
          };

          protectedRooms = mkOption {
            type = types.listOf types.str;
            default = [ ];
            example = literalExpression ''
              [
                "https://matrix.to/#/#yourroom:example.org"
                "https://matrix.to/#/#anotherroom:example.org"
              ]
            '';
            description = lib.mdDoc ''
              A list of rooms to protect (matrix.to URLs).
              These can also be configured interactively.
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
  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = !(cfg.pantalaimon.enable && cfg.pantalaimon.passwordFile == null);
        message = "Specify pantalaimon.passwordFile";
      }
      {
        assertion = !(cfg.pantalaimon.enable && cfg.accessTokenFile != null);
        message = "Do not specify accessTokenFile when using pantalaimon";
      }
      {
        assertion = !(!cfg.pantalaimon.enable && cfg.accessTokenFile == null);
        message = "Specify accessTokenFile when not using pantalaimon";
      }
    ];

    services.pantalaimon-headless.instances."draupnir" = mkIf cfg.pantalaimon.enable
      {
        homeserver = cfg.pantalaimon.homeserverUrl;
      } // cfg.pantalaimon.options;

    systemd.services.draupnir = {
      description = "Draupnir - a moderation tool for Matrix";
      requires = optionals (cfg.pantalaimon.enable) [
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
        ExecStart = utils.escapeSystemdExecArgs ([
          (lib.getExe pkgs.draupnir)
          "--draupnir-config" "${configFile}"
        ] ++ optionals (cfg.pantalaimon.enable && cfg.pantalaimon.passwordFile != null) [
          "--pantalaimon-password-file"
          "$CREDENTIALS_DIRECTORY/pantalaimon_password"
        ] ++ optionals (cfg.accessTokenFile != null) [
          "--access-token-file"
          "$CREDENTIALS_DIRECTORY/access_token"
        ]);

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
          optionals (cfg.accessTokenFile != null) [
            "access_token:${cfg.accessTokenFile}"
          ]
          ++ optionals (cfg.pantalaimon.enable && cfg.pantalaimon.passwordFile != null) [
            "pantalaimon_password:${cfg.pantalaimon.passwordFile}"
          ];
      };
    };
  };
  #endregion

  meta = {
    doc = ./draupnir.md;
    maintainers = with maintainers; [ Rory ];
  };
}
