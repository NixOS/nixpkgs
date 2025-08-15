{
  lib,
  pkgs,
  config,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    types
    ;
  cfg = config.services.vencloud;
  cfgRedis = config.services.vencloud.settings.redis;
  settingsFormat = pkgs.formats.keyValue { };
in
{
  meta.doc = ./vencloud.md;
  meta.maintainers = with lib.maintainers; [ eveeifyeve ];

  options.services.vencloud = {
    enable = mkEnableOption "Selfhosted vencloud api";

    package = mkPackageOption pkgs "vencloud" { };

    settings = mkOption {
      type = types.submodule {
        freeformType = settingsFormat.type;

        options = {
          DISCORD_CLIENT_ID = mkOption {
            type = types.nullOr types.int;
            default = null;
            example = 321436435432;
            description = "The client ID that should be used for Discord OAuth.";
          };

          DISCORD_CLIENT_SECRET_FILE = mkOption {
            type = types.nullOr types.str;
            default = null;
            example = "/path/to/discord_secret_file";
            description = "The client secret file that should be used for Discord OAuth.";
          };

          DISCORD_REDIRECT_URI = mkOption {
            type = types.nullOr types.str;
            default = "http://localhost:8000/v1/oauth/callback";
            example = "https://example.com/v1/oauth/callback";
            description = "The redirect URI that should be used for Discord OAuth.";
          };

          HOST = mkOption {
            type = types.nullOr types.str;
            default = "0.0.0.0";
            description = "The host that Vencloud should listen on.";
          };

          PORT = mkOption {
            type = types.nullOr types.port;
            default = null;
            description = "The port that Vencloud should listen on.";
          };

          redis = {
            createLocally = mkOption {
              type = types.bool;
              default = true;
              description = "Configure a local redis server for Vencloud.";
            };

            host = mkOption {
              type = with types; nullOr str;
              default = "localhost";
              description = "Redis host.";
            };

            port = mkOption {
              type = with types; nullOr port;
              default = 6379;
              description = "Redis port.";
            };

            user = mkOption {
              type = with types; nullOr str;
              default = null;
              description = "Optional username used for authentication with redis.";
            };

            passwordFile = mkOption {
              type = with types; nullOr path;
              default = null;
              example = "/run/keys/vencloud/pasword-redis-db";
              description = "Path to a file containing the redis password.";
            };

            useSSL = mkOption {
              type = types.bool;
              default = true;
              description = "Use SSL if using a redis network connection.";
            };
          };
        };
      };
      default = { };

      description = ''
        Configuration for Vencloud, exported as environment variables.
        See
        <link xlink:href="https://github.com/Vencord/Vencloud/blob/main/.env.example"/>
        for supported values.
      '';
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = (
          cfg.settings.DISCORD_CLIENT_SECRET_FILE == null && cfg.settings.DISCORD_CLIENT_ID == null
        );
        message = "You must set both services.vencord.settings.DISCORD_CLEINT_SECRET_FILE and services.vencord.settings.DISCORD_CLIENT_ID.";
      }
    ];

    services.redis.servers.vencloud.enable = cfgRedis.createLocally;
    systemd.services.vencloud = {
      description = "Vencord's API for cloud settings sync";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        DynamicUser = true;
        Restart = "on-failure";
        Environment = lib.filterAttrs (
          name: _: name != "DISCORD_CLIENT_SECRET_FILE" && name != "redis"
        ) cfg.settings;
        LoadCredential =
          "DISCORD_CLIENT_SECRET:${cfg.settings.DISCORD_CLIENT_SECRET_FILE}"
          ++ lib.optional (cfg.redis.passwordFile != null) "REDIS_PASSWORD:${cfg.redis.passwordFile}";
      };

      script =
        let
          redisUsername = lib.optionalString (cfgRedis.user != null) (cfg.redis.user);
          redisHost = cfgRedis.host;
          redisPort = toString.cfgRedis.port;
          redisProtocol = if cfgRedis.useSSL then "rediss" else "redis";
        in
        ''
          export DISCORD_CLIENT_SECRET="$(${pkgs.systemd}/bin/systemd-creds cat DISCORD_CLIENT_SECRET)"
          export REDIS_URL="${redisProtocol}://${redisUsername}:$(${config.systemd.package}/bin/systemd-creds cat REDIS_PASSWORD)@${redisHost}:${redisPort}"
          exec ${lib.getExe cfg.package}
        '';
    };
  };

}
