{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.services.transfer-sh;
in
{
  options = {
    services.transfer-sh = {
      enable = mkEnableOption "transfer-sh setup";

      package = mkPackageOption pkgs "transfer-sh" { };

      environmentFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = lib.mdDoc "Environment file as defined in {manpage}`systemd.exec(5)`.";
      };

      user = mkOption {
        description = "user to run as";
        default = "transfersh";
        type = types.str;
      };

      group = mkOption {
        description = "group to run as";
        default = "transfersh";
        type = types.str;
      };

      provider = mkOption {
        description = "which storage provider to use (s3, storj, gdrive or local)";
        default = "local";
        type = types.enum [ "s3" "storj" "gdrive" "local" ];
      };

      address = mkOption {
        description = "address to listen on";
        default = "127.0.0.1";
        type = types.str;
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = "Open the firewall port";
      };

      LISTENER = mkOption {
        description = "port to use for http";
        default = 6080;
        type = types.port;
      };

      PROFILE_LISTENER = mkOption {
        description = "port to use for profiler";
        default = 6060;
        type = types.nullOr types.port;
      };

      FORCE_HTTPS = mkOption {
        description = "redirect to https";
        default = false;
        type = types.nullOr types.bool;
      };

      TLS_LISTENER = mkOption {
        description = "port to use for https";
        default = null;
        type = types.nullOr types.port;
      };

      TLS_LISTENER_ONLY = mkOption {
        description = "flag to enable tls listener only";
        default = false;
        type = types.nullOr types.bool;
      };

      TLS_CERT_FILE = mkOption {
        description = "path to tls certificate";
        default = null;
        type = types.nullOr types.path;
      };

      TLS_PRIVATE_KEY = mkOption {
        description = "path to tls private key";
        default = null;
        type = types.nullOr types.path;
      };

      HTTP_AUTH_USER = mkOption {
        description = "user for basic http auth on upload";
        default = null;
        type = types.nullOr types.str;
      };

      HTTP_AUTH_PASS = mkOption {
        description = "pass for basic http auth on upload";
        default = null;
        type = types.nullOr types.str;
      };

      HTTP_AUTH_HTPASSWD = mkOption {
        description = "htpasswd file path for basic http auth on upload";
        default = null;
        type = types.nullOr types.path;
      };

      HTTP_AUTH_IP_WHITELIST = mkOption {
        description = "comma separated list of ips allowed to upload without being challenged an http auth";
        default = [ ];
        type = with types; listOf str;
      };

      IP_WHITELIST = mkOption {
        description = "comma separated list of ips allowed to connect to the service";
        default = [ ];
        type = with types; listOf str;
      };

      IP_BLACKLIST = mkOption {
        description = "comma separated list of ips not allowed to connect to the service";
        default = [ ];
        type = with types; listOf str;
      };

      TEMP_PATH = mkOption {
        description = "path to temp folder";
        default = null;
        type = types.nullOr types.str;
      };

      WEB_PATH = mkOption {
        description = "path to static web files (for development or custom front end)";
        default = null;
        type = types.nullOr types.str;
      };

      PROXY_PATH = mkOption {
        description = "path prefix when service is run behind a proxy";
        default = null;
        type = types.nullOr types.str;
      };

      PROXY_PORT = mkOption {
        description = "port of the proxy when the service is run behind a proxy";
        default = null;
        type = types.nullOr types.port;
      };

      EMAIL_CONTACT = mkOption {
        description = "email contact for the front end";
        default = null;
        type = types.nullOr types.str;
      };

      GA_KEY = mkOption {
        description = "google analytics key for the front end";
        default = null;
        type = types.nullOr types.str;
      };

      USERVOICE_KEY = mkOption {
        description = "user voice key for the front end";
        default = null;
        type = types.nullOr types.str;
      };

      AWS_ACCESS_KEY = mkOption {
        description = "aws access key";
        default = null;
        type = types.nullOr types.str;
      };

      AWS_SECRET_KEY = mkOption {
        description = "aws access key";
        default = null;
        type = types.nullOr types.str;
      };

      BUCKET = mkOption {
        description = "aws bucket";
        default = null;
        type = types.nullOr types.str;
      };

      S3_ENDPOINT = mkOption {
        description = "Custom S3 endpoint.";
        default = null;
        type = types.nullOr types.str;
      };

      S3_REGION = mkOption {
        description = "region of the s3 bucket";
        default = "eu-west-1";
        type = types.nullOr types.str;
      };

      S3_NO_MULTIPART = mkOption {
        description = "disables s3 multipart upload";
        default = false;
        type = types.nullOr types.bool;
      };

      S3_PATH_STYLE = mkOption {
        description = "Forces path style URLs, required for Minio.";
        default = false;
        type = types.nullOr types.bool;
      };

      STORJ_ACCESS = mkOption {
        description = "Access for the project";
        default = null;
        type = types.nullOr types.str;
      };

      STORJ_BUCKET = mkOption {
        description = "Bucket to use within the project";
        default = null;
        type = types.nullOr types.str;
      };

      BASEDIR = mkOption {
        description = "path storage for local/gdrive provider";
        default = "${cfg.stateDir}/store";
        type = types.nullOr types.str;
      };

      GDRIVE_CLIENT_JSON_FILEPATH = mkOption {
        description = "path to oauth client json config for gdrive provider";
        default = null;
        type = types.nullOr types.str;
      };

      GDRIVE_LOCAL_CONFIG_PATH = mkOption {
        description = "path to store local transfer.sh config cache for gdrive provider";
        default = null;
        type = types.nullOr types.str;
      };

      GDRIVE_CHUNK_SIZE = mkOption {
        description = "chunk size for gdrive upload in megabytes, must be lower than available memory (8 MB)";
        default = null;
        type = types.nullOr types.str;
      };

      HOSTS = mkOption {
        description = "hosts to use for lets encrypt certificates (comma seperated)";
        default = null;
        type = types.nullOr types.str;
      };

      LOG = mkOption {
        description = "path to log file";
        default = "${cfg.stateDir}/transfer-sh.log";
        type = types.nullOr types.str;
      };

      CORS_DOMAINS = mkOption {
        description = "comma separated list of domains for CORS, setting it enable CORS";
        default = null;
        type = types.nullOr types.str;
      };

      CLAMAV_HOST = mkOption {
        description = "host for clamav feature";
        default = null;
        type = types.nullOr types.str;
      };

      PERFORM_CLAMAV_PRESCAN = mkOption {
        description = "prescan every upload through clamav feature (clamav-host must be a local clamd unix socket)";
        default = false;
        type = types.nullOr types.bool;
      };

      RATE_LIMIT = mkOption {
        description = "request per minute";
        default = null;
        type = types.nullOr types.str;
      };

      MAX_UPLOAD_SIZE = mkOption {
        description = "max upload size in kilobytes";
        default = null;
        type = types.nullOr types.str;
      };

      PURGE_DAYS = mkOption {
        description = "number of days after the uploads are purged automatically";
        default = "7";
        type = types.nullOr types.str;
      };

      PURGE_INTERVAL = mkOption {
        description = "interval in hours to run the automatic purge for (not applicable to S3 and Storj)";
        default = 1;
        type = types.nullOr types.int;
      };

      RANDOM_TOKEN_LENGTH = mkOption {
        description = "length of the random token for the upload path (double the size for delete path)";
        default = "6";
        type = types.nullOr types.str;
      };

      stateDir = mkOption {
        type = types.path;
        description = "Variable state directory";
        default = "/var/lib/transfer.sh";
      };
    };
  };

  config = mkIf cfg.enable
    {
      users.users = mkIf (cfg.user == "transfersh") {
        transfersh = {
          description = "transfer-sh service user";
          home = cfg.stateDir;
          group = cfg.group;
          isSystemUser = true;
        };
      };

      users.groups = mkIf (cfg.group == "transfersh") { transfersh = { }; };

      systemd.tmpfiles.rules = [
        "d ${cfg.stateDir} 0750 ${cfg.user} ${cfg.group} - -"
        "d ${cfg.BASEDIR} 0750 ${cfg.user} ${cfg.group} - -"
      ];

      systemd.services.transfer-sh = {
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        serviceConfig = {
          User = cfg.user;
          Group = cfg.group;
          ExecStart = "${lib.getExe fg.package} --provider=${cfg.provider}";
          EnvironmentFile = lib.mkIf (cfg.environmentFile != null) cfg.environmentFile;
        };

        environment =
          {
            LISTENER = "${cfg.address}:${toString cfg.LISTENER}";
            PROFILE_LISTENER = toString cfg.PROFILE_LISTENER;
            HTTP_AUTH_USER = cfg.HTTP_AUTH_USER;
            HTTP_AUTH_PASS = cfg.HTTP_AUTH_PASS;
            HTTP_AUTH_HTPASSWD = cfg.HTTP_AUTH_HTPASSWD;
            HTTP_AUTH_IP_WHITELIST = concatStringsSep "," cfg.HTTP_AUTH_IP_WHITELIST;
            IP_WHITELIST = concatStringsSep "," cfg.IP_WHITELIST;
            IP_BLACKLIST = concatStringsSep "," cfg.IP_BLACKLIST;
            TEMP_PATH = cfg.TEMP_PATH;
            WEB_PATH = cfg.WEB_PATH;
            PROXY_PATH = cfg.PROXY_PATH;
            PROXY_PORT = toString cfg.PROXY_PORT;
            EMAIL_CONTACT = cfg.EMAIL_CONTACT;
            GA_KEY = cfg.GA_KEY;
            USERVOICE_KEY = cfg.USERVOICE_KEY;
            HOSTS = cfg.HOSTS;
            LOG = cfg.LOG;
            CORS_DOMAINS = cfg.CORS_DOMAINS;
            CLAMAV_HOST = cfg.CLAMAV_HOST;
            PERFORM_CLAMAV_PRESCAN = lib.boolToString cfg.PERFORM_CLAMAV_PRESCAN;
            RATE_LIMIT = cfg.RATE_LIMIT;
            MAX_UPLOAD_SIZE = cfg.MAX_UPLOAD_SIZE;
            PURGE_DAYS = cfg.PURGE_DAYS;
            RANDOM_TOKEN_LENGTH = cfg.RANDOM_TOKEN_LENGTH;
            BASEDIR = cfg.BASEDIR;
            PURGE_INTERVAL = toString cfg.PURGE_INTERVAL;
          } // lib.optionalAttrs (cfg.provider == "s3") {
            # Options specific to s3 backend
            AWS_ACCESS_KEY = cfg.AWS_ACCESS_KEY;
            AWS_SECRET_KEY = cfg.AWS_SECRET_KEY;
            BUCKET = cfg.BUCKET;
            S3_REGION = cfg.S3_REGION;
            S3_ENDPOINT = cfg.S3_ENDPOINT;
            S3_NO_MULTIPART = lib.boolToString cfg.S3_NO_MULTIPART;
            S3_PATH_STYLE = lib.boolToString cfg.S3_PATH_STYLE;
          } // lib.optionalAttrs (cfg.provider == "storj") {
            # Options specific to storj backend
            STORJ_ACCESS = cfg.STORJ_ACCESS;
            STORJ_BUCKET = cfg.STORJ_BUCKET;
          } // lib.optionalAttrs (cfg.provider == "gdrive") {
            # Options specific to google drive backend
            GDRIVE_CLIENT_JSON_FILEPATH = cfg.GDRIVE_CLIENT_JSON_FILEPATH;
            GDRIVE_LOCAL_CONFIG_PATH = cfg.GDRIVE_LOCAL_CONFIG_PATH;
            GDRIVE_CHUNK_SIZE = cfg.GDRIVE_CHUNK_SIZE;
          } // lib.optionalAttrs (cfg.TLS_LISTENER != null) {
            # TLS specific options
            TLS_LISTENER = "${cfg.address}:${toString cfg.TLS_LISTENER}";
            TLS_LISTENER_ONLY = lib.boolToString cfg.TLS_LISTENER_ONLY;
            TLS_CERT_FILE = cfg.TLS_CERT_FILE;
            TLS_PRIVATE_KEY = cfg.TLS_PRIVATE_KEY;
            FORCE_HTTPS = lib.boolToString cfg.FORCE_HTTPS;
          };
      };

      networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall
        ([ cfg.LISTENER cfg.PROFILE_LISTENER ] ++ optionals (cfg.TLS_LISTENER != null) [ cfg.TLS_LISTENER ]);

      warnings =
        let
          sensitiveVars = [
            "GA_KEY"
            "HTTP_AUTH_PASS"
            "USERVOICE_KEY"
            "AWS_SECRET_KEY"
            "STORJ_ACCESS"
          ];
        in

        lib.lists.forEach (filter (i: cfg."${i}" != null) sensitiveVars) (x:
          ''
            config.services.transfer-sh.${x} will be stored as plaintext in the Nix store.
            Use services.transfer-sh.environmentFile instead to prevent this.
          ''
        );
    };
  meta.maintainers = with lib.maintainers; [ pinpox ];
}
