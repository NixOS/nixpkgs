{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.draupnir;

  yamlConfig = {
    inherit (cfg) dataPath managementRoom protectedRooms verboseLogging;

    accessToken = "@ACCESS_TOKEN@"; # will be replaced in "generateConfig"
    homeserverUrl =
      if cfg.pantalaimon.enable then
        "http://${cfg.pantalaimon.options.listenAddress}:${toString cfg.pantalaimon.options.listenPort}"
      else
        cfg.homeserverUrl;

    rawHomeserverUrl = cfg.homeserverUrl;

    pantalaimon = {
      inherit (cfg.pantalaimon) username;

      use = cfg.pantalaimon.enable;
      password = "@PANTALAIMON_PASSWORD@"; # will be replaced in "generateConfig"
    };
  };

  moduleConfigFile = pkgs.writeText "module-config.yaml" (
    generators.toYAML { } (filterAttrs (_: v: v != null)
      (fold recursiveUpdate { } [ yamlConfig cfg.settings ])));

  # these config files will be merged one after the other to build the final config
  configFiles = [
#    "${pkgs.draupnir}/share/draupnir/config/default.yaml"
    moduleConfigFile
  ];

  # this will generate the default.yaml file with all configFiles as inputs and
  # replace all secret strings using replace-secret
  generateConfig = pkgs.writeShellScript "draupnir-generate-config" (
    let
      yqEvalStr = concatImapStringsSep " * " (pos: _: "select(fileIndex == ${toString (pos - 1)})") configFiles;
      yqEvalArgs = concatStringsSep " " configFiles;
    in
    ''
      set -euo pipefail

      umask 077

      # draupnir will try to load a config from "./config/default.yaml" in the working directory
      # -> let's place the generated config there
      mkdir -p ${cfg.dataPath}/config

      # merge all config files into one, overriding settings of the previous one with the next config
      # e.g. "eval-all 'select(fileIndex == 0) * select(fileIndex == 1)' filea.yaml fileb.yaml" will merge filea.yaml with fileb.yaml
      ${pkgs.yq-go}/bin/yq eval-all -P '${yqEvalStr}' ${yqEvalArgs} > ${cfg.dataPath}/config/default.yaml

      ${optionalString (cfg.accessTokenFile != null) ''
        ${pkgs.replace-secret}/bin/replace-secret '@ACCESS_TOKEN@' '${cfg.accessTokenFile}' ${cfg.dataPath}/config/default.yaml
      ''}
      ${optionalString (cfg.pantalaimon.passwordFile != null) ''
        ${pkgs.replace-secret}/bin/replace-secret '@PANTALAIMON_PASSWORD@' '${cfg.pantalaimon.passwordFile}' ${cfg.dataPath}/config/default.yaml
      ''}
    ''
  );
in
{
  options.services.draupnir = {
    enable = mkEnableOption (lib.mdDoc "Draupnir, a moderation tool for Matrix");

    homeserverUrl = mkOption {
      type = types.str;
      default = "https://matrix.org";
      description = lib.mdDoc ''
        Base URL of the Matrix homeserver, that provides the Client-Server API.

        If `pantalaimon.enable` is `true`, this option will become the homeserver to which `pantalaimon` connects.
        The listen address of `pantalaimon` will then become the `homeserverUrl` of `draupnir`.
      '';
    };

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
            used instead. The access token of the bot will be stored in the dataPath.
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
    verboseLogging = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether Draupnir should log a lot more messages in the room,
        mainly involves "all-OK" messages, and debugging messages for when draupnir checks bans in a room.
      '';
    };

    dataPath = mkOption {
      type = types.path;
      default = "/var/lib/draupnir";
      description = lib.mdDoc ''
        The directory the bot should store various bits of information in.
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

    settings = mkOption {
      default = { };
      type = (pkgs.formats.yaml { }).type;
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
      requires = [] ++ optionals (cfg.pantalaimon.enable) [
        "pantalaimon-draupnir.service"
      ];
      wants = [
        "network-online.target"
        "pantalaimon-draupnir.service"
      ];
      after = [
        "network-online.target"
        "matrix-synapse.service"
        "pantalaimon-draupnir.service"
      ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = lib.getExe pkgs.draupnir;
        ExecStartPre = [ generateConfig ];
        WorkingDirectory = cfg.dataPath;
        StateDirectory = "draupnir";
        StateDirectoryMode = "0700";
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        User = "draupnir";
        Restart = "on-failure";

        /* TODO: wait for #102397 to be resolved. Then load secrets from $CREDENTIALS_DIRECTORY+"/NAME"
        DynamicUser = true;
        LoadCredential = [] ++
          optionals (cfg.accessTokenFile != null) [
            "access_token:${cfg.accessTokenFile}"
          ] ++
          optionals (cfg.pantalaimon.passwordFile != null) [
            "pantalaimon_password:${cfg.pantalaimon.passwordFile}"
          ];
        */
      };
    };

    users = {
      users.draupnir = {
        group = "draupnir";
        isSystemUser = true;
      };
      groups.draupnir = { };
    };
  };

  meta = {
    doc = ./draupnir.md;
    maintainers = with maintainers; [ Rory ];
  };
}
