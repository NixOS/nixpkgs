{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.alerta;

  alertaConf = pkgs.writeTextFile {
    name = "alertad.conf";
    text = ''
      DATABASE_URL = '${cfg.databaseUrl}'
      DATABASE_NAME = '${cfg.databaseName}'
      LOG_FILE = '${cfg.logDir}/alertad.log'
      LOG_FORMAT = '%(asctime)s - %(name)s - %(levelname)s - %(message)s'
      CORS_ORIGINS = [ ${lib.concatMapStringsSep ", " (s: "\"" + s + "\"") cfg.corsOrigins} ];
      AUTH_REQUIRED = ${if cfg.authenticationRequired then "True" else "False"}
      SIGNUP_ENABLED = ${if cfg.signupEnabled then "True" else "False"}
      ${cfg.extraConfig}
    '';
  };
in
{
  options.services.alerta = {
    enable = lib.mkEnableOption "alerta";

    port = lib.mkOption {
      type = lib.types.port;
      default = 5000;
      description = "Port of Alerta";
    };

    bind = lib.mkOption {
      type = lib.types.str;
      default = "0.0.0.0";
      description = "Address to bind to. The default is to bind to all addresses";
    };

    logDir = lib.mkOption {
      type = lib.types.path;
      description = "Location where the logfiles are stored";
      default = "/var/log/alerta";
    };

    databaseUrl = lib.mkOption {
      type = lib.types.str;
      description = "URL of the MongoDB or PostgreSQL database to connect to";
      default = "mongodb://localhost";
    };

    databaseName = lib.mkOption {
      type = lib.types.str;
      description = "Name of the database instance to connect to";
      default = "monitoring";
    };

    corsOrigins = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "List of URLs that can access the API for Cross-Origin Resource Sharing (CORS)";
      default = [
        "http://localhost"
        "http://localhost:5000"
      ];
    };

    authenticationRequired = lib.mkOption {
      type = lib.types.bool;
      description = "Whether users must authenticate when using the web UI or command-line tool";
      default = false;
    };

    signupEnabled = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to prevent sign-up of new users via the web UI";
      default = true;
    };

    extraConfig = lib.mkOption {
      description = "These lines go into alertad.conf verbatim.";
      default = "";
      type = lib.types.lines;
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.settings."10-alerta".${cfg.logDir}.d = {
      user = "alerta";
      group = "alerta";
    };

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
