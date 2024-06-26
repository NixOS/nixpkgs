{
  config,
  options,
  pkgs,
  lib,
  ...
}:

with lib;

let
  dataDir = "/var/lib/matrix-appservice-discord";
  registrationFile = "${dataDir}/discord-registration.yaml";
  cfg = config.services.matrix-appservice-discord;
  opt = options.services.matrix-appservice-discord;
  # TODO: switch to configGen.json once RFC42 is implemented
  settingsFile = pkgs.writeText "matrix-appservice-discord-settings.json" (
    builtins.toJSON cfg.settings
  );

in
{
  options = {
    services.matrix-appservice-discord = {
      enable = mkEnableOption "a bridge between Matrix and Discord";

      package = mkPackageOption pkgs "matrix-appservice-discord" { };

      settings = mkOption rec {
        # TODO: switch to types.config.json as prescribed by RFC42 once it's implemented
        type = types.attrs;
        apply = recursiveUpdate default;
        default = {
          database = {
            filename = "${dataDir}/discord.db";
          };

          # empty values necessary for registration file generation
          # actual values defined in environmentFile
          auth = {
            clientID = "";
            botToken = "";
          };
        };
        example = literalExpression ''
          {
            bridge = {
              domain = "public-domain.tld";
              homeserverUrl = "http://public-domain.tld:8008";
            };
          }
        '';
        description = ''
          {file}`config.yaml` configuration as a Nix attribute set.

          Configuration options should match those described in
          [config.sample.yaml](https://github.com/Half-Shot/matrix-appservice-discord/blob/master/config/config.sample.yaml).

          {option}`config.bridge.domain` and {option}`config.bridge.homeserverUrl`
          should be set to match the public host name of the Matrix homeserver for webhooks and avatars to work.

          Secret tokens should be specified using {option}`environmentFile`
          instead of this world-readable attribute set.
        '';
      };

      environmentFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = ''
          File containing environment variables to be passed to the matrix-appservice-discord service,
          in which secret tokens can be specified securely by defining values for
          `APPSERVICE_DISCORD_AUTH_CLIENT_I_D` and
          `APPSERVICE_DISCORD_AUTH_BOT_TOKEN`.
        '';
      };

      url = mkOption {
        type = types.str;
        default = "http://localhost:${toString cfg.port}";
        defaultText = literalExpression ''"http://localhost:''${toString config.${opt.port}}"'';
        description = ''
          The URL where the application service is listening for HS requests.
        '';
      };

      port = mkOption {
        type = types.port;
        default = 9005; # from https://github.com/Half-Shot/matrix-appservice-discord/blob/master/package.json#L11
        description = ''
          Port number on which the bridge should listen for internal communication with the Matrix homeserver.
        '';
      };

      localpart = mkOption {
        type = with types; nullOr str;
        default = null;
        description = ''
          The user_id localpart to assign to the AS.
        '';
      };

      serviceDependencies = mkOption {
        type = with types; listOf str;
        default = optional config.services.matrix-synapse.enable config.services.matrix-synapse.serviceUnit;
        defaultText = literalExpression ''
          optional config.services.matrix-synapse.enable config.services.matrix-synapse.serviceUnit
        '';
        description = ''
          List of Systemd services to require and wait for when starting the application service,
          such as the Matrix homeserver if it's running on the same host.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.matrix-appservice-discord = {
      description = "A bridge between Matrix and Discord.";

      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ] ++ cfg.serviceDependencies;
      after = [ "network-online.target" ] ++ cfg.serviceDependencies;

      preStart = ''
        if [ ! -f '${registrationFile}' ]; then
          ${cfg.package}/bin/matrix-appservice-discord \
            --generate-registration \
            --url=${escapeShellArg cfg.url} \
            ${optionalString (cfg.localpart != null) "--localpart=${escapeShellArg cfg.localpart}"} \
            --config='${settingsFile}' \
            --file='${registrationFile}'
        fi
      '';

      serviceConfig = {
        Type = "simple";
        Restart = "always";

        ProtectSystem = "strict";
        ProtectHome = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;

        DynamicUser = true;
        PrivateTmp = true;
        WorkingDirectory = "${cfg.package}/${cfg.package.passthru.nodeAppDir}";
        StateDirectory = baseNameOf dataDir;
        UMask = "0027";
        EnvironmentFile = cfg.environmentFile;

        ExecStart = ''
          ${cfg.package}/bin/matrix-appservice-discord \
            --file='${registrationFile}' \
            --config='${settingsFile}' \
            --port='${toString cfg.port}'
        '';
      };
    };
  };

  meta.maintainers = with maintainers; [ pacien ];
}
