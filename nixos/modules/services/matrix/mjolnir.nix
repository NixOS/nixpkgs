{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.mjolnir;

  yamlConfig = {
    inherit (cfg) dataPath managementRoom protectedRooms;

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
    "${pkgs.mjolnir}/share/mjolnir/config/default.yaml"
    moduleConfigFile
  ];

  # this will generate the default.yaml file with all configFiles as inputs and
  # replace all secret strings using replace-secret
  generateConfig = pkgs.writeShellScript "mjolnir-generate-config" (
    let
      yqEvalStr = concatImapStringsSep " * " (pos: _: "select(fileIndex == ${toString (pos - 1)})") configFiles;
      yqEvalArgs = concatStringsSep " " configFiles;
    in
    ''
      set -euo pipefail

      umask 077

      # mjolnir will try to load a config from "./config/default.yaml" in the working directory
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
  options.services.mjolnir = {
    enable = mkEnableOption (lib.mdDoc "Mjolnir, a moderation tool for Matrix");

    homeserverUrl = mkOption {
      type = types.str;
      default = "https://matrix.org";
      description = lib.mdDoc ''
        Where the homeserver is located (client-server URL).

        If `pantalaimon.enable` is `true`, this option will become the homeserver to which `pantalaimon` connects.
        The listen address of `pantalaimon` will then become the `homeserverUrl` of `mjolnir`.
      '';
    };

    accessTokenFile = mkOption {
      type = with types; nullOr path;
      default = null;
      description = lib.mdDoc ''
        File containing the matrix access token for the `mjolnir` user.
      '';
    };

    pantalaimon = mkOption {
      description = lib.mdDoc ''
        `pantalaimon` options (enables E2E Encryption support).

        This will create a `pantalaimon` instance with the name "mjolnir".
      '';
      default = { };
      type = types.submodule {
        options = {
          enable = mkEnableOption (lib.mdDoc ''
            If true, accessToken is ignored and the username/password below will be
            used instead. The access token of the bot will be stored in the dataPath.
          '');

          username = mkOption {
            type = types.str;
            description = lib.mdDoc "The username to login with.";
          };

          passwordFile = mkOption {
            type = with types; nullOr path;
            default = null;
            description = lib.mdDoc ''
              File containing the matrix password for the `mjolnir` user.
            '';
          };

          options = mkOption {
            type = types.submodule (import ./pantalaimon-options.nix);
            default = { };
            description = lib.mdDoc ''
              passthrough additional options to the `pantalaimon` service.
            '';
          };
        };
      };
    };

    dataPath = mkOption {
      type = types.path;
      default = "/var/lib/mjolnir";
      description = lib.mdDoc ''
        The directory the bot should store various bits of information in.
      '';
    };

    managementRoom = mkOption {
      type = types.str;
      default = "#moderators:example.org";
      description = lib.mdDoc ''
        The room ID where people can use the bot. The bot has no access controls, so
        anyone in this room can use the bot - secure your room!
        This should be a room alias or room ID - not a matrix.to URL.
        Note: `mjolnir` is fairly verbose - expect a lot of messages from it.
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
        Additional settings (see [mjolnir default config](https://github.com/matrix-org/mjolnir/blob/main/config/default.yaml) for available settings). These settings will override settings made by the module config.
      '';
    };
  };

  config = mkIf config.services.mjolnir.enable {
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

    services.pantalaimon-headless.instances."mjolnir" = mkIf cfg.pantalaimon.enable
      {
        homeserver = cfg.homeserverUrl;
      } // cfg.pantalaimon.options;

    systemd.services.mjolnir = {
      description = "mjolnir - a moderation tool for Matrix";
      wants = [ "network-online.target" ] ++ optionals (cfg.pantalaimon.enable) [ "pantalaimon-mjolnir.service" ];
      after = [ "network-online.target" ] ++ optionals (cfg.pantalaimon.enable) [ "pantalaimon-mjolnir.service" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = ''${pkgs.mjolnir}/bin/mjolnir'';
        ExecStartPre = [ generateConfig ];
        WorkingDirectory = cfg.dataPath;
        StateDirectory = "mjolnir";
        StateDirectoryMode = "0700";
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        User = "mjolnir";
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
      users.mjolnir = {
        group = "mjolnir";
        isSystemUser = true;
      };
      groups.mjolnir = { };
    };
  };

  meta = {
    doc = ./mjolnir.xml;
    maintainers = with maintainers; [ jojosch ];
  };
}
