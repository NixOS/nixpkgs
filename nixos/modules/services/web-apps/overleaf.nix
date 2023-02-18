{ config, lib, pkgs, ... }:

let
  cfg = config.services.overleaf;
  env = {
CHAT_HOST="localhost";
CLSI_HOST="localhost";
CONTACTS_HOST="localhost";
DOCSTORE_HOST="localhost";
DOCUMENT_UPDATER_HOST="localhost";
FILESTORE_HOST="localhost";
GRACEFUL_SHUTDOWN_DELAY="0";
LISTEN_ADDRESS="localhost";
MONGO_HOST="localhost";
MONGO_CONNECTION_STRING="mongodb://localhost:27017/overleaf";
NOTIFICATIONS_HOST="localhost";
REALTIME_HOST="localhost";
REDIS_HOST="localhost";
SPELLING_HOST="localhost";
TRACK_CHANGES_HOST="localhost";
WEBPACK_HOST="localhost";
WEB_API_PASSWORD="overleaf";
WEB_API_USER="overleaf";
WEB_API_PORT="3032";
WEB_API_HOST="localhost";
WEB_HOST="localhost";
WEB_PORT="3032";
DATA_DIR="/var/lib/overleaf";
NODE_ENV="production";
OVERLEAF_CONFIG = "${pkgs.overleaf}/share/server-ce/config/settings.js";
OVERLEAF_FPH_DISPLAY_NEW_PROJECTS = "true";
OVERLEAF_MONGO_URL = "mongodb://localhost:27017/overleaf";
OVERLEAF_REDIS_HOST="localhost";
OVERLEAF_SESSION_SECRET="hello";
OVERLEAF_HISTORY_BACKEND="fs";
OVERLEAF_HISTORY_BLOBS_BUCKET="/var/lib/overleaf/data/history/overleaf-blobs";
OVERLEAF_HISTORY_PROJECT_BLOBS_BUCKET="/var/lib/overleaf/data/history/overleaf-project-blobs";
OVERLEAF_HISTORY_CHUNKS_BUCKET="/var/lib/overleaf/data/history/overleaf-chunks";
OVERLEAF_HISTORY_ZIPS_BUCKET="/var/lib/overleaf/data/history/overleaf-zips";
OVERLEAF_HISTORY_ANALYTICS_BUCKET="/var/lib/overleaf/data/history/overleaf-analytics";
ADMIN_PRIVILEGE_AVAILABLE="true";
OVERLEAF_SITE_URL= "https://verso.saumon.network";
OVERLEAF_ADMIN_EMAIL="postmaster@mondon.me";
#OVERLEAF_SITE_LANGUAGE = "fr";
OVERLEAF_APP_NAME = "Verso, powered by SaumonNetwork";
#OVERLEAF_EMAIL_FROM_ADDRESS="";
#OVERLEAF_EMAIL_SMTP_HOST="";
#OVERLEAF_EMAIL_SMTP_PORT= "587";
#OVERLEAF_EMAIL_SMTP_SECURE= "true";
#OVERLEAF_EMAIL_SMTP_USER="";
#OVERLEAF_EMAIL_SMTP_PASS="";
OVERLEAF_IS_SERVER_PRO="true";
};
in
with lib;

{
  meta.maintainers = with maintainers; [ julienmalka camillemndn ];

  options.services.overleaf = {
    enable = mkEnableOption (mdDoc ''Overleaf'');
    enableFerretDB = mkEnableOption (mdDoc ''FerretDB, an open-source implementation of MongoDB. Experimental!'');
  };

  config = mkIf cfg.enable {
    services.nginx = {
      enable = true;
      recommendedOptimisation = mkDefault true;
      recommendedGzipSettings = mkDefault true;
    };

   services.postgresql = {
     enable = true;
     ensureDatabases = [ "ferretdb" ];
     ensureUsers = [ {
       name = "ferretdb";
       ensurePermissions."DATABASE ferretdb" = "ALL PRIVILEGES";
     }];
   };
   services.mongodb = {
      enable = true;
      package = pkgs.mongodb-4_2;
    };

    users.users.ferretdb = {
      isSystemUser = true;
      group = "ferretdb";
      home = "/var/lib/ferretdb";
      createHome = true;
    };

    users.groups.ferretdb = { };


    services.redis.servers."".enable = true;

    systemd.services =
    let activateServices = s: {
      "overleaf-${s}" = {
        description = "Overleaf ${s}";
	wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.overleaf}/bin/overleaf-${s}";
	  StateDirectory = "overleaf";
	  WorkingDirectory = "/var/lib/overleaf";
          User = "overleaf";
        };
        environment = env;
	path = with pkgs; [ texlive.combined.scheme-full R ];
      };
    };
    in
    mkMerge ((map activateServices [ "chat" "clsi" "contacts" "docstore" "document-updater" "filestore" "notifications" "project-history" "real-time" "spelling" "track-changes" "web" ]) ++ [{
    ferretdb = mkIf cfg.enableFerretDB {
      description = "FerretDB";
      environment.LC_COLLATE = "en_US.UTF-8";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
	ExecStart = "${pkgs.ferretdb}/bin/ferretdb --postgresql-url=\"postgres://localhost/ferretdb?host=/run/postgresql\"";
        StateDirectory = "ferretdb";
	WorkingDirectory = "/var/lib/ferretdb";
	User = "ferretdb";
      };
    };
    postgresql.environment.LC_ALL = "en_US.UTF-8";
    }]);

    users.users.overleaf = {
      isSystemUser = true;
      group = "overleaf";
      home = "/var/lib/overleaf";
      createHome = true;
    };
    users.groups.overleaf = { };

    networking.firewall.allowedTCPPorts = [ 27017 ];
  };
}
