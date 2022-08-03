{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.alerta;

  alertaConf = pkgs.writeTextFile {
    name = "alertad.conf";
    text = ''
      DATABASE_URL = '${cfg.databaseUrl}'
      DATABASE_NAME = '${cfg.databaseName}'
      LOG_FILE = '${cfg.logDir}/alertad.log'
      LOG_FORMAT = '%(asctime)s - %(name)s - %(levelname)s - %(message)s'
      CORS_ORIGINS = [ ${concatMapStringsSep ", " (s: "\"" + s + "\"") cfg.corsOrigins} ];
      AUTH_REQUIRED = ${if cfg.authenticationRequired then "True" else "False"}
      SIGNUP_ENABLED = ${if cfg.signupEnabled then "True" else "False"}
      ${cfg.extraConfig}
    '';
  };
in
{
  options.services.alerta = {
    enable = mkEnableOption "alerta";

    port = mkOption {
      type = types.int;
      default = 5000;
      description = lib.mdDoc "Port of Alerta";
    };

    bind = mkOption {
      type = types.str;
      default = "0.0.0.0";
      description = lib.mdDoc "Address to bind to. The default is to bind to all addresses";
    };

    logDir = mkOption {
      type = types.path;
      description = lib.mdDoc "Location where the logfiles are stored";
      default = "/var/log/alerta";
    };

    databaseUrl = mkOption {
      type = types.str;
      description = lib.mdDoc "URL of the MongoDB or PostgreSQL database to connect to";
      default = "mongodb://localhost";
    };

    databaseName = mkOption {
      type = types.str;
      description = lib.mdDoc "Name of the database instance to connect to";
      default = "monitoring";
    };

    corsOrigins = mkOption {
      type = types.listOf types.str;
      description = lib.mdDoc "List of URLs that can access the API for Cross-Origin Resource Sharing (CORS)";
      default = [ "http://localhost" "http://localhost:5000" ];
    };

    authenticationRequired = mkOption {
      type = types.bool;
      description = lib.mdDoc "Whether users must authenticate when using the web UI or command-line tool";
      default = false;
    };

    signupEnabled = mkOption {
      type = types.bool;
      description = lib.mdDoc "Whether to prevent sign-up of new users via the web UI";
      default = true;
    };

    extraConfig = mkOption {
      description = lib.mdDoc "These lines go into alertad.conf verbatim.";
      default = "";
      type = types.lines;
    };
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d '${cfg.logDir}' - alerta alerta - -"
    ];

    systemd.services.alerta = {
      description = "Alerta Monitoring System";
      wantedBy = [ "multi-user.target" ];
      after = [ "networking.target" ];
      environment = {
        ALERTA_SVR_CONF_FILE = alertaConf;
      };
      serviceConfig = {
        ExecStart = "${pkgs.alerta-server}/bin/alertad run --port ${toString cfg.port} --host ${cfg.bind}";
        User = "alerta";
        Group = "alerta";
      };
    };

    environment.systemPackages = [ pkgs.alerta ];

    users.users.alerta = {
      uid = config.ids.uids.alerta;
      description = "Alerta user";
    };

    users.groups.alerta = {
      gid = config.ids.gids.alerta;
    };
  };
}
