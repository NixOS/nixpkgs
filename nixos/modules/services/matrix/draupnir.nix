{
  config,
  options,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.draupnir;
  opt = options.services.draupnir;

  format = pkgs.formats.yaml { };
  configFile = format.generate "draupnir.yaml" cfg.settings;

  inherit (lib)
    literalExpression
    mkEnableOption
    mkOption
    mkPackageOption
    mkRemovedOptionModule
    mkRenamedOptionModule
    types
    ;
in
{
  imports = [
    # Removed options for those migrating from the Mjolnir module
    (mkRenamedOptionModule
      [ "services" "draupnir" "dataPath" ]
      [ "services" "draupnir" "settings" "dataPath" ]
    )
    (mkRenamedOptionModule
      [ "services" "draupnir" "homeserverUrl" ]
      [ "services" "draupnir" "settings" "homeserverUrl" ]
    )
    (mkRenamedOptionModule
      [ "services" "draupnir" "managementRoom" ]
      [ "services" "draupnir" "settings" "managementRoom" ]
    )
    (mkRenamedOptionModule
      [ "services" "draupnir" "accessTokenFile" ]
      [ "services" "draupnir" "secrets" "accessToken" ]
    )
    (mkRemovedOptionModule [ "services" "draupnir" "pantalaimon" ] ''
      `services.draupnir.pantalaimon.*` has been removed because it depends on the deprecated and vulnerable
      libolm library for end-to-end encryption and upstream support for Pantalaimon in Draupnir is limited.
      See <https://the-draupnir-project.github.io/draupnir-documentation/bot/encryption> for details.
      If you nontheless require E2EE via Pantalaimon, you can configure `services.pantalaimon-headless.instances`
      yourself and use that with `services.draupnir.settings.pantalaimon` and `services.draupnir.secrets.pantalaimon.password`.
    '')
  ];

  options.services.draupnir = {
    enable = mkEnableOption "Draupnir, a moderations bot for Matrix";

    package = mkPackageOption pkgs "draupnir" { };

    settings = mkOption {
      example = literalExpression ''
        {
          homeserverUrl = "https://matrix.org";
          managementRoom = "#moderators:example.org";

          autojoinOnlyIfManager = true;
          automaticallyRedactForReasons = [ "spam" "advertising" ];
        }
      '';
      description = ''
        Free-form settings written to Draupnir's configuration file.
        See [Draupnir's default configuration](https://github.com/the-draupnir-project/Draupnir/blob/main/config/default.yaml) for available settings.
      '';
      default = { };
      type = types.submodule {
        freeformType = format.type;
        options = {
          homeserverUrl = mkOption {
            type = types.str;
            example = "https://matrix.org";
            description = ''
              Base URL of the Matrix homeserver that provides the Client-Server API.

              ::: {.note}
              When using Pantalaimon, set this to the Pantalaimon URL and
              {option}`${opt.settings}.rawHomeserverUrl` to the public URL.
              :::
            '';
          };

          rawHomeserverUrl = mkOption {
            type = types.str;
            example = "https://matrix.org";
            default = cfg.settings.homeserverUrl;
            defaultText = literalExpression "config.${opt.settings}.homeserverUrl";
            description = ''
              Public base URL of the Matrix homeserver that provides the Client-Server API when using the Draupnir's
              [Report forwarding feature](https://the-draupnir-project.github.io/draupnir-documentation/bot/homeserver-administration#report-forwarding).

              ::: {.warning}
              When using Pantalaimon, do not set this to the Pantalaimon URL!
              :::
            '';
          };

          managementRoom = mkOption {
            type = types.str;
            example = "#moderators:example.org";
            description = ''
              The room ID or alias where moderators can use the bot's functionality.

              The bot has no access controls, so anyone in this room can use the bot - secure this room!
              Do not enable end-to-end encryption for this room, unless set up with Pantalaimon.

              ::: {.warning}
              When using a room alias, make sure the alias used is on the local homeserver!
              This prevents an issue where the control room becomes undefined when the alias can't be resolved.
              :::
            '';
          };

          dataPath = mkOption {
            type = types.path;
            readOnly = true;
            default = "/var/lib/draupnir";
            description = ''
              The path Draupnir will store its state/data in.

              ::: {.warning}
              This option is read-only.
              :::

              ::: {.note}
              If you want to customize where this data is stored, use a bind mount.
              :::
            '';
          };
        };
      };
    };

    secrets = {
      accessToken = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = ''
          File containing the access token for Draupnir's Matrix account
          to be used in place of {option}`${opt.settings}.accessToken`.
        '';
      };

      pantalaimon.password = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = ''
          File containing the password for Draupnir's Matrix account when used in
          conjunction with Pantalaimon to be used in place of
          {option}`${opt.settings}.pantalaimon.password`.

          ::: {.warning}
          Take note that upstream has limited Pantalaimon and E2EE support:
          <https://the-draupnir-project.github.io/draupnir-documentation/bot/encryption> and
          <https://the-draupnir-project.github.io/draupnir-documentation/shared/dogfood#e2ee-support>.
          :::
        '';
      };

      web.synapseHTTPAntispam.authorization = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = ''
          File containing the secret token when using the Synapse HTTP Antispam module
          to be used in place of
          {option}`${opt.settings}.web.synapseHTTPAntispam.authorization`.

          See <https://the-draupnir-project.github.io/draupnir-documentation/bot/synapse-http-antispam> for details.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        # Removed option for those migrating from the Mjolnir module - mkRemovedOption module does *not* work with submodules.
        assertion = !(cfg.settings ? protectedRooms);
        message = "Unset ${opt.settings}.protectedRooms, as it is unsupported on Draupnir. Add these rooms via `!draupnir rooms add` instead.";
      }
    ];

    systemd.services.draupnir = {
      description = "Draupnir - a moderation bot for Matrix";
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

      startLimitIntervalSec = 0;
      serviceConfig = {
        ExecStart = toString (
          [
            (lib.getExe cfg.package)
            "--draupnir-config"
            configFile
          ]
          ++ lib.optionals (cfg.secrets.accessToken != null) [
            "--access-token-path"
            "%d/access_token"
          ]
          ++ lib.optionals (cfg.secrets.pantalaimon.password != null) [
            "--pantalaimon-password-path"
            "%d/pantalaimon_password"
          ]
          ++ lib.optionals (cfg.secrets.web.synapseHTTPAntispam.authorization != null) [
            "--http-antispam-authorization-path"
            "%d/http_antispam_authorization"
          ]
        );

        WorkingDirectory = "/var/lib/draupnir";
        StateDirectory = "draupnir";
        StateDirectoryMode = "0700";
        ProtectHome = true;
        PrivateDevices = true;
        Restart = "on-failure";
        RestartSec = "5s";
        DynamicUser = true;
        LoadCredential =
          lib.optionals (cfg.secrets.accessToken != null) [
            "access_token:${cfg.secrets.accessToken}"
          ]
          ++ lib.optionals (cfg.secrets.pantalaimon.password != null) [
            "pantalaimon_password:${cfg.secrets.pantalaimon.password}"
          ]
          ++ lib.optionals (cfg.secrets.web.synapseHTTPAntispam.authorization != null) [
            "http_antispam_authorization:${cfg.secrets.web.synapseHTTPAntispam.authorization}"
          ];
      };
    };
  };

  meta = {
    doc = ./draupnir.md;
    maintainers = with lib.maintainers; [
      RorySys
      emilylange
    ];
  };
}
