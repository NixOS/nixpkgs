{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.jellystat;
in
{
  meta.maintainers = [ lib.maintainers.kashw2 ];

  options.services.jellystat = {
    enable = lib.mkEnableOption "Jellystat, a free and open source Statistics App for Jellyfin";

    package = lib.mkPackageOption pkgs "jellystat" { };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Open port in the firewall for the Jellystat web interface.";
    };

    listenAddress = lib.mkOption {
      type = lib.types.str;
      default = "0.0.0.0";
      description = "The listen address the server should serve from.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 3000;
      description = "The port the Jellystat UI should run on.";
    };

    postgresUser = lib.mkOption {
      type = lib.types.str;
      default = "postgres";
      description = "The Postgresql username.";
    };

    postgresPassword = lib.mkOption {
      type = lib.types.str;
      description = "The Postgresql password.";
    };

    postgresAddress = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = "The Postgresql instance address";
    };

    postgresPort = lib.mkOption {
      type = lib.types.port;
      default = 5432;
      description = "The Postgresql instance port.";
    };

    postgresDatabase = lib.mkOption {
      type = lib.types.str;
      default = "postgres";
      description = "The Postgresql database name.";
    };

    jwtSecret = lib.mkOption {
      type = lib.types.str;
      description = "The JWT key to be used to encrypt JWT authentication.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.jellystat = {
      description = "Jellystat, a free and open source Statistics App for Jellyfin";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = {
        POSTGRES_USER = cfg.postgresUser;
        POSTGRES_PASSWORD = cfg.postgresPassword;
        POSTGRES_IP = cfg.postgresAddress;
        POSTGRES_PORT = toString cfg.postgresPort;
        POSTGRES_DB = cfg.postgresDatabase;
        JWT_SECRET = cfg.jwtSecret;
        JS_PORT = toString cfg.port;
        JS_LISTEN_IP = cfg.listenAddress;
      };
      serviceConfig = {
        DynamicUser = true;
        ExecStart = "${pkgs.nodejs}/bin/node ${pkgs.jellystat.out}/backend/server.js";
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };
  };
}
