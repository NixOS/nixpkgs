{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.draupnir;

  format = pkgs.formats.yaml {};
  config = format.generate "draupnir.yaml" cfg.settings;
in
{
  imports = [
    (mkRemovedOptionModule [ "services" "draupnir" "dataPath" ] "Customising data path is not supported in the Draupnir module. Please move your Mjolnir data to /var/lib/draupnir!" )
    (mkRemovedOptionModule [ "services" "draupnir" "verboseLogging" ] "Verbose logging was deprecated in Draupnir, and the option has been removed to reflect this." )
  ];
  options.services.draupnir = {
    enable = mkEnableOption (lib.mdDoc "Draupnir, a moderation tool for Matrix");

    accessTokenFile = mkOption {
      type = with types; nullOr path;
      default = null;
      description = lib.mdDoc ''
        File containing the access token for Draupnir's Matrix account.
      '';
    };

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

    settings =  types.submodule {
      description = lib.mdDoc ''
        Settings for Draupnir, see [Draupnir's default configuration](https://github.com/the-draupnir-project/Draupnir/blob/main/config/default.yaml) for available settings.
      '';
      default = { };
      type = format.type;
      options = {
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
        homeserverUrl = mkOption {
          type = types.str;
          default = "https://matrix.org";
          description = lib.mdDoc ''
            Base URL of the Matrix homeserver, that provides the Client-Server API.

            If `pantalaimon.enable` is `true`, this option will become the homeserver to which `pantalaimon` connects.
            The listen address of `pantalaimon` will then become the `homeserverUrl` of `draupnir`.
          '';
        };
      };
      example = literalExpression ''
        {
          autojoinOnlyIfManager = true;
          automaticallyRedactForReasons = [ "spam" "advertising" ];
        }
      '';
      description = lib.mdDoc ''
        Additional settings (see [Draupnir's default configuration](https://github.com/the-draupnir-project/Draupnir/blob/main/config/default.yaml) for available settings).
        These settings will override settings made by the module config.
      '';
    };
  };

  config = mkIf config.services.draupnir.enable {
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
        homeserver = cfg.homeserverUrl;
      } // cfg.pantalaimon.options;

    systemd.services.draupnir = {
      description = "Draupnir - a moderation tool for Matrix";
      requires = optionals (cfg.pantalaimon.enable) [
        "pantalaimon-draupnir.service"
      ];
      wants = [
        "network-online.target"
      ];
      after = [
        "network-online.target"
        "matrix-synapse.service"
        "conduit.service"
      ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${lib.getExe pkgs.draupnir} --draupnir-config ${config}";
        ExecStartPre = [ generateConfig ];
        WorkingDirectory = "/var/lib/draupnir";
        StateDirectory = "draupnir";
        StateDirectoryMode = "0700";
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        Restart = "on-failure";

        /* TODO: wait for #102397 to be resolved. Then load secrets from $CREDENTIALS_DIRECTORY+"/NAME" */
        DynamicUser = true;
        LoadCredential =
          optionals (cfg.accessTokenFile != null) [
            "access_token:${cfg.accessTokenFile}"
          ] ++
          optionals (cfg.pantalaimon.passwordFile != null) [
            "pantalaimon_password:${cfg.pantalaimon.passwordFile}"
          ];
        /**/
      };
    };
  };

  meta = {
    doc = ./draupnir.md;
    maintainers = with maintainers; [ Rory ];
  };
}
