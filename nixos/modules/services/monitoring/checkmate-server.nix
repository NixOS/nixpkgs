{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.checkmate-server;

  inherit (lib)
    mkEnableOption
    mkPackageOption
    mkIf
    mkOption
    types
    isPath
    ;

  assertStringPath =
    optionName: value:
    if isPath value then
      throw ''
        services.checkmate-server.${optionName}:
          ${toString value}
          is a Nix path, but should be a string, since Nix
          paths are copied into the world-readable Nix store.
      ''
    else
      value;
in
{
  options = {
    services.checkmate-server = {
      enable = mkEnableOption "the Checkmate monitoring server";

      package = mkPackageOption pkgs "checkmate-server" { };

      vhostName = mkOption {
        type = types.str;
        default = "checkmate-server";
        description = "Name of the nginx vhost.";
      };

      enableLocalDB = mkEnableOption "a local MongoDB instance";

      settings = {
        clientHost = mkOption {
          type = types.str;
          default = "http://127.0.0.1";
          description = "Frontend Host URI.";
        };

        origin = mkOption {
          type = types.str;
          default = "localhost";
          description = ''
            Origin where requests to server originate from, for CORS purposes.
          '';
        };

        port = mkOption {
          type = types.port;
          default = 52345;
          description = "Port the Checkmate backend should listen on.";
        };

        logLevel = mkOption {
          type = types.enum [
            "debug"
            "info"
            "warn"
            "error"
          ];
          default = "info";
          description = "Debug level, can be one of: debug, info, warn, error.";
        };

        tokenTTL = mkOption {
          type = types.str;
          default = "1h";
          description = ''
            Time for token to live in vercel/ms format, see: https://github.com/vercel/ms.
          '';
        };

        JWTSecretFile = mkOption {
          type = types.path;
          apply = assertStringPath "settings.JWTSecretFile";
          description = ''
            Path to a file that contains the secret to sign web requests using JSON Web Tokens.
          '';
        };
      };

      mongodbUri = mkOption {
        type = types.str;
        default = "mongodb://127.0.0.1:27017/uptime_db";
        description = ''
          MongoDB connection string.
          See http://docs.mongodb.org/manual/reference/connection-string/ for details.
        '';
      };
    };
  };

  config = mkIf cfg.enable {

    services.mongodb = mkIf cfg.enableLocalDB {
      enable = true;
    };

    systemd.services.checkmate-backend = {
      description = "Checkmate backend daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ] ++ lib.optionals cfg.enableLocalDB [ "mongodb.service" ];
      startLimitIntervalSec = 60;
      startLimitBurst = 3;
      environment = {
        CLIENT_HOST = cfg.settings.clientHost;
        LOG_LEVEL = cfg.settings.logLevel;
        DB_CONNECTION_STRING = cfg.mongodbUri;
        ORIGIN = cfg.settings.origin;
        TOKEN_TTL = cfg.settings.tokenTTL;
        PORT = toString cfg.settings.port;
      };
      serviceConfig = {
        LoadCredential = [ "JWT_SECRET:${cfg.settings.JWTSecretFile}" ];
        PrivateDevices = true;
        LimitCORE = 0;
        KillSignal = "SIGINT";
        TimeoutStopSec = "30s";
        Restart = "on-failure";
        DynamicUser = true;
      };
      script = ''
        set -eou pipefail
        shopt -s inherit_errexit

        JWT_SECRET="$(<"$CREDENTIALS_DIRECTORY/JWT_SECRET")" \
        ${cfg.package}/startserver ${cfg.package}/backend/index.js
      '';
    };

    services.nginx.virtualHosts.${cfg.vhostName} = {
      locations."/" = {
        root = "${cfg.package}/public";
        index = "index.html index.htm";
        tryFiles = "$uri $uri/ /index.html";
      };
      locations."/api/" = {
        proxyPass = "http://127.0.0.1:${toString cfg.settings.port}/api/";
        proxyWebsockets = true;
      };
      locations."/api-docs/" = {
        proxyPass = "http://127.0.0.1:${toString cfg.settings.port}/api-docs/";
        proxyWebsockets = true;
      };
    };

  };
}
