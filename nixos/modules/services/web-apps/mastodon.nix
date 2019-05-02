{ config, lib, pkgs, ... }:

let
  tmpDir = "/tmp/mastodon";
  logDir = "/var/log/mastodon";

  cfg = config.services.mastodon;

  env = {
    RAILS_ENV = "production";
    NODE_ENV = "production";
    SECRET_KEY_BASE = cfg.secretKeyBase;
    OTP_SECRET = cfg.otpSecret;
    VAPID_PRIVATE_KEY = cfg.vapidPrivateKey;
    VAPID_PUBLIC_KEY = cfg.vapidPublicKey;
    DB_USER = cfg.dbUser;
    DB_PASS = cfg.dbPass;
    SMTP_LOGIN  = cfg.smtpLogin;
    SMTP_PASSWORD = cfg.smtpPassword;
    REDIS_HOST = cfg.redisHost;
    REDIS_PORT = toString(cfg.redisPort);
    DB_HOST = cfg.dbHost;
    DB_PORT = toString(cfg.dbPort);
    DB_NAME = cfg.dbName;
    LOCAL_DOMAIN = cfg.localDomain;
    SMTP_SERVER = cfg.smtpServer;
    SMTP_PORT = toString(cfg.smtpPort);
    SMTP_FROM_ADDRESS = cfg.smtpFromAddress;
    PAPERCLIP_ROOT_PATH = "${cfg.dataDir}/public-system";
    PAPERCLIP_ROOT_URL = "/system";
    ES_ENABLED = if (cfg.elasticsearchHost != null) then "true" else "false";
    ES_HOST = cfg.elasticsearchHost;
    ES_PORT = toString(cfg.elasticsearchPort);
  };

in {

  options = {
    services.mastodon = {
      enable = lib.mkEnableOption "Mastodon federated social network";
      configureNginx = lib.mkOption {
        description = "Use nginx as reverse proxy for mastodon";
        type = lib.types.bool;
        default = true;
      };
      createUser = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
      user = lib.mkOption {
        type = lib.types.str;
        default = "mastodon";
      };
      group = lib.mkOption {
        type = lib.types.str;
        default = "mastodon";
      };

      streamingPort = lib.mkOption {
        type = lib.types.int;
        default = 55000;
      };
      webPort = lib.mkOption {
        type = lib.types.int;
        default = 55001;
      };
      sidekiqPort = lib.mkOption {
        type = lib.types.int;
        default = 55002;
      };

      secretKeyBase = lib.mkOption {
        type = lib.types.str;
      };
      otpSecret = lib.mkOption {
        type = lib.types.str;
      };
      vapidPrivateKey = lib.mkOption {
        type = lib.types.str;
      };
      vapidPublicKey = lib.mkOption {
        type = lib.types.str;
      };
      dbUser = lib.mkOption {
        type = lib.types.str;
        default = "mastodon";
      };
      dbPass = lib.mkOption {
        type = lib.types.str;
      };
      smtpLogin = lib.mkOption {
        type = lib.types.str;
      };
      smtpPassword = lib.mkOption {
        type = lib.types.str;
      };

      redisHost = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
      };
      redisPort = lib.mkOption {
        type = lib.types.int;
        default = 6379;
      };
      dbHost = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
      };
      dbPort = lib.mkOption {
        type = lib.types.int;
        default = 5432;
      };
      dbName = lib.mkOption {
        type = lib.types.str;
        default = "mastodon";
      };
      localDomain = lib.mkOption {
        type = lib.types.str;
      };
      smtpServer = lib.mkOption {
        type = lib.types.str;
      };
      smtpPort = lib.mkOption {
        type = lib.types.int;
        default = 587;
      };
      smtpFromAddress = lib.mkOption {
        type = lib.types.str;
      };
      elasticsearchHost = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
      };
      elasticsearchPort = lib.mkOption {
        type = lib.types.int;
        default = 9200;
      };
      dataDir = lib.mkOption {
        type = lib.types.str;
        default = "/var/lib/mastodon";
      };

    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.mastodon-init-dirs = {
      script = ''
        mkdir -p ${tmpDir}
        mkdir -p ${logDir}
        mkdir -p ${cfg.dataDir}
        chown ${cfg.user}:${cfg.group} ${tmpDir}
        chown ${cfg.user}:${cfg.group} ${logDir}
        chown ${cfg.user}:${cfg.group} ${cfg.dataDir}
      '';
      serviceConfig = {
        Type = "oneshot";
      };
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
    };

    systemd.services.mastodon-init-db = {
      script = ''
        cd ${pkgs.mastodon}
        rake db:migrate
      '';
      path = [ pkgs.mastodon ];
      environment = env;
      serviceConfig = {
        Type = "oneshot";
        User = cfg.user;
        Group = cfg.group;
      };
      after = [ "mastodon-init-dirs.service" "network.target" ];
      wantedBy = [ "multi-user.target" ];
    };

    systemd.services.mastodon-streaming = {
      after = [ "mastodon-init-db.service" "network.target" ];
      description = "Mastodon streaming";
      wantedBy = [ "multi-user.target" ];
      environment = env // {
        PORT = toString(cfg.streamingPort);
      };
      serviceConfig = {
        ExecStart = "${pkgs.nodejs-slim}/bin/node streaming";
        Restart = "always";
        RestartSec = 20;
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = pkgs.mastodon;
      };
    };

    systemd.services.mastodon-web = {
      after = [ "mastodon-init-db.service" "network.target" ];
      description = "Mastodon web";
      wantedBy = [ "multi-user.target" ];
      environment = env // {
        PORT = toString(cfg.webPort);
      };
      serviceConfig = {
        ExecStart = "${pkgs.mastodon}/bin/puma -C config/puma.rb";
        Restart = "always";
        RestartSec = 20;
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = pkgs.mastodon;
      };
      path = with pkgs; [ file imagemagick ffmpeg ];
    };

    systemd.services.mastodon-sidekiq = {
      after = [ "mastodon-init-db.service" "network.target" ];
      description = "Mastodon sidekiq";
      wantedBy = [ "multi-user.target" ];
      environment = env // {
        PORT = toString(cfg.sidekiqPort);
      };
      serviceConfig = {
        ExecStart = "${pkgs.mastodon}/bin/sidekiq -c 25 -r ${pkgs.mastodon}";
        Restart = "always";
        RestartSec = 20;
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = pkgs.mastodon;
      };
    };

    services.nginx = lib.mkIf cfg.configureNginx {
      enable = true;
      virtualHosts."${cfg.localDomain}" = {
        root = "${pkgs.mastodon}/public/";
  
        locations."/system/".alias = "${cfg.dataDir}/public-system/";
  
        locations."/" = {
          tryFiles = "$uri @proxy";
        };
  
        locations."@proxy" = {
          proxyPass = "http://127.0.0.1:${toString(cfg.webPort)}";
          proxyWebsockets = true;
        };
  
        locations."/api/v1/streaming/" = {
          proxyPass = "http://127.0.0.1:${toString(cfg.streamingPort)}/";
          proxyWebsockets = true;
        };
      };
    };

    users = lib.mkIf cfg.createUser {
      users."${cfg.user}" = {
        group = cfg.group;
        isSystemUser = true;
      };
      groups."${cfg.group}" = {};
    };
  };

}
