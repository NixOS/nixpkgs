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

    # NOTE: All settings are required to be specified alwise it will error out.
    settings = mkOption {
      type = types.submodule {
        freeformType = settingsFormat.type;

        options = {
          DISCORD_CLIENT_ID = mkOption {
            type = types.int;
            example = 321436435432;
            description = "The client ID that should be used for Discord OAuth.";
          };

          DISCORD_CLIENT_SECRET_FILE = mkOption {
            type = types.str;
            example = "/path/to/discord_secret_file";
            description = "The client secret file that should be used for Discord OAuth.";
          };

          DISCORD_REDIRECT_URI = mkOption {
            type = types.str;
            default = "http://localhost:8000/v1/oauth/callback";
            example = "https://example.com/v1/oauth/callback";
            description = "The redirect URI that should be used for Discord OAuth.";
          };

          PEPPER_SETTINGS_FILE = mkOption {
            type = types.str;
            example = "/path/to/pepper_settings_file";
            description = ''
              Pepper settings file for hashing settings

              To generate the pepper secret use `openssl rand -hex 64`.
            '';
          };

          PEPPER_SECRET_FILE = mkOption {
            type = types.str;
            example = "/path/to/pepper_secret_file";
            description = ''
              The pepper secrets file for hashing secrets

              To generate the pepper secret use `openssl rand -hex 64`.
            '';
          };

          SIZE_LIMIT = mkOption {
            type = types.nullOr types.int;
            default = 32000000; # Default is: 32MB
            description = "Amount of storage you want to backup.";
          };

          ALLOWED_USERS = mkOption {
            type = with types; nullOr (listOf str);
            default = null;
            description = "The allowed users to use the instance.";
          };

          PROMETHEUS = mkOption {
            type = types.nullOr types.str;
            default = null;
            example = true;
            description = "Ability to exposes a /metric endpoint for prometheus.";
          };

          PROXY_HEADER = mkOption {
            type = types.nullOr types.str;
            default = null;
            example = "X-Forwarded-For";
            description = "Ability to set proxy header if using vencord in a proxy.";
          };

          ROOT_REDIRECT = mkOption {
            type = types.str;
            default = "https://github.com/Vencord/Vencloud";
            description = "The repo where your local copy of vencloud is located.";
          };

          HOST = mkOption {
            type = types.str;
            default = "0.0.0.0";
            description = "The host that Vencloud should listen on.";
          };

          PORT = mkOption {
            type = types.port;
            default = 8080;
            description = "The port that Vencloud should listen on.";
          };

          redis = {
            createLocally = mkOption {
              type = types.bool;
              default = true;
              description = "Configure a local redis server for Vencloud.";
            };

            host = mkOption {
              type = types.str;
              default = "localhost";
              description = "Redis host.";
            };

            port = mkOption {
              type = types.port;
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
    services.redis.servers.vencloud.enable = cfgRedis.createLocally;
    systemd.services.vencloud = {
      description = "Vencord's API for cloud settings sync";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        DynamicUser = true;
        Restart = "on-failure";
        Environment = {
          ALLOWED_USERS = lib.concatStringsSep "," cfg.ALLOWED_USERS; # Comma seperated!
        }
        // lib.filterAttrs (
          name: _:
          name != "DISCORD_CLIENT_SECRET_FILE"
          || "ALLOWED_USERS" # Comma seperated!
          || "PEPPER_SETTINGS"
          || "PEPPER_SETTINGS"
          || "redis"
        );
        LoadCredential =
          "DISCORD_CLIENT_SECRET:${cfg.settings.DISCORD_CLIENT_SECRET_FILE}"
          ++ "PEPPER_SETTINGS:${cfg.settings.PEPPER_SETTINGS_FILE}"
          ++ "PEPPER_SECRET:${cfg.settings.PEPPER_SECRET_FILE}"
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
          export PEPPER_SETTINGS="$(${pkgs.systemd}/bin/systemd-creds cat PEPPER_SETTINGS)"
          export PEPPER_SECRET="$(${pkgs.systemd}/bin/systemd-creds cat PEPPER_SECRET)"
          export REDIS_URL="${redisProtocol}://${redisUsername}:$(${config.systemd.package}/bin/systemd-creds cat REDIS_PASSWORD)@${redisHost}:${redisPort}"
          exec ${lib.getExe cfg.package}
        '';
    };
  };

}
