{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.opengym;
in
{
  options.services.opengym = {
    enable = lib.mkEnableOption "openGym workout tracker";

    package = lib.mkPackageOption pkgs "opengym" { };

    rpId = lib.mkOption {
      type = lib.types.str;
      default = "localhost";
      description = "Hostname passkeys are bound to. A bare hostname: no scheme, no port, no slash.";
    };

    origin = lib.mkOption {
      type = lib.types.str;
      default = "http://localhost:8080";
      description = ''
        Full URL the app is served from ; with scheme, without trailing slash.
        Must match the address bar exactly.'';
    };

    rpName = lib.mkOption {
      type = lib.types.str;
      default = "openGym";
      description = "Name shown in the passkey prompt.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 3000;
      description = ''
        Port the API listens on.
        You either need to proxy it yourself or activate `reverseProxy` to serve the frontend.
      '';
    };

    sessionDays = lib.mkOption {
      type = lib.types.ints.positive;
      default = 90;
      description = "How long a sign-in lasts, in days.";
    };

    adminUids = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Comma-separated user ids that get the admin dashboard.";
    };

    inviteOnly = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Set true and new profiles need an invite code you generate from the dashboard. Existing accounts keep working.";
    };

    allowGuest = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Set false to remove Continue without account. Guest data isn't deleted — it stays in that browser and returns if you re-enable guests, or moves into a profile created on the same device.";
    };

    passwordLogin = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable password sign-in. Give the API at least 256 MB of memory when it is on.";
    };

    trustProxy = lib.mkOption {
      type = lib.types.bool;
      default = cfg.reverseProxy.enable;
      defaultText = lib.literalExpression "config.services.opengym.reverseProxy.enable";
      description = "Let the sign-in throttle read the client's address from X-Forwarded-For.";
    };

    defaultLang = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "en";
      description = "The instance's default language for the sign-in screen and profiles that never chose one.";
    };

    media = {
      uploads = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable exercise and workout photos and videos uploads.";
      };

      quotaMb = lib.mkOption {
        type = lib.types.ints.unsigned;
        default = 200;
        description = "Media quota per profile in megabytes.";
      };

      minFreeMb = lib.mkOption {
        type = lib.types.nullOr lib.types.ints.unsigned;
        default = 512;
        description = "Uploads stop below this much free disk space (MB). 0 = no floor.";
      };

      imageMaxMb = lib.mkOption {
        type = lib.types.ints.unsigned;
        default = 2;
        description = "Max size for a photo (after shrinking) and thumbnails in MB.";
      };

      gifMaxMb = lib.mkOption {
        type = lib.types.ints.unsigned;
        default = 8;
        description = "Max size for an animated GIF in MB.";
      };

      videoMaxMb = lib.mkOption {
        type = lib.types.ints.unsigned;
        default = 40;
        description = "Max size for a video (as recorded) in MB.";
      };

      videoMaxSec = lib.mkOption {
        type = lib.types.ints.unsigned;
        default = 60;
        description = "Maximum allowed video length in seconds.";
      };

      gcGraceDays = lib.mkOption {
        type = lib.types.ints.unsigned;
        default = 14;
        description = "How long an unused file is kept before garbage collection.";
      };

      uploadsPerHour = lib.mkOption {
        type = lib.types.ints.unsigned;
        default = 600;
        description = "Uploads permitted per profile per hour.";
      };
    };

    auditLog = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Record sign-ins and admin actions to the activity log — set false to record nothing.";
    };

    auditMax = lib.mkOption {
      type = lib.types.ints.unsigned;
      default = 5000;
      description = "Events kept in the activity log; 0 for no limit.";
    };

    auditDays = lib.mkOption {
      type = lib.types.ints.unsigned;
      default = 90;
      description = "Days kept in the activity log; 0 to keep until AUDIT_MAX.";
    };

    auditIp = lib.mkOption {
      type = lib.types.enum [
        "off"
        "net"
        "full"
      ];
      default = "off";
      description = "Record the caller's address: off, net (network only, e.g. 203.0.113.0/24) or full.";
    };

    vapidSubject = lib.mkOption {
      type = lib.types.str;
      default = cfg.origin;
      defaultText = lib.literalExpression "config.services.opengym.origin";
      description = "Contact URL sent with push notifications.";
    };

    coachDisabled = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Set true to switch the AI Coach off.";
    };

    coachJobTimeoutSeconds = lib.mkOption {
      type = lib.types.nullOr lib.types.ints.unsigned;
      default = null;
      description = ''
        Raise the job budget for slow local AI models.
        Defaults to 5min if null.'';
    };

    firstUserAdmin = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "The first profile created on an empty instance becomes its admin.";
    };

    basePath = lib.mkOption {
      type = lib.types.str;
      default = "/";
      example = "/gym";
      description = "Serve openGym under a sub-path. Must match the reverse proxy routing.";
    };

    allowedPrivateIps = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [
        "192.168.1.0/24"
        "10.0.0.0/8"
      ];
      description = "List of private IPs/CIDRs the server is allowed to push to (e.g., for webhooks).";
    };

    reverseProxy = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to automatically configure a reverse proxy to serve the frontend and proxy the API.";
      };

      server = lib.mkOption {
        type = lib.types.enum [
          "caddy"
          "nginx"
        ];
        default = "caddy";
        description = "Which web server to configure.";
      };

      host = lib.mkOption {
        type = lib.types.str;
        default = "localhost";
        description = ''
          The site address the reverse proxy should bind to.

          * **Caddy**: This can include a scheme to enable automatic HTTPS (e.g., `https://gym.example.com`).
          * **Nginx**: This must be a bare hostname or IP address (e.g., `gym.example.com` or `127.0.0.1`).
        '';
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 8080;
        description = "The port the reverse proxy should listen on.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.opengym = {
      description = "openGym Backend API";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      environment = {
        PORT = toString cfg.port;
        DATA_DIR = "/var/lib/opengym";
        RP_ID = cfg.rpId;
        ORIGIN = cfg.origin;
        RP_NAME = cfg.rpName;
        SESSION_DAYS = toString cfg.sessionDays;
        ADMIN_UIDS = lib.concatStringsSep "," cfg.adminUids;
        INVITE_ONLY = if cfg.inviteOnly then "1" else "0";
        ALLOW_GUEST = if cfg.allowGuest then "1" else "0";
        PASSWORD_LOGIN = if cfg.passwordLogin then "1" else "0";
        TRUST_PROXY = if cfg.trustProxy then "1" else "0";
        MEDIA_UPLOADS = if cfg.media.uploads then "1" else "0";
        MEDIA_QUOTA_MB = toString cfg.media.quotaMb;
        AUDIT_LOG = if cfg.auditLog then "1" else "0";
        AUDIT_MAX = toString cfg.auditMax;
        AUDIT_DAYS = toString cfg.auditDays;
        AUDIT_IP = cfg.auditIp;
        VAPID_SUBJECT = cfg.vapidSubject;
        COACH_DISABLED = if cfg.coachDisabled then "1" else "0";
        COACH_JOB_TIMEOUT_MS = lib.mkIf (cfg.coachJobTimeoutSeconds != null) (
          toString (cfg.coachJobTimeoutSeconds * 1000)
        );
        DEFAULT_LANG = lib.mkIf (cfg.defaultLang != null) cfg.defaultLang;
        MEDIA_MIN_FREE_MB = lib.mkIf (cfg.media.minFreeMb != null) (toString cfg.media.minFreeMb);
        FIRST_USER_ADMIN = if cfg.firstUserAdmin then "1" else "0";
        BASE_PATH = cfg.basePath;
        ALLOWED_PRIVATE_IPS = lib.mkIf (cfg.allowedPrivateIps != [ ]) (
          lib.concatStringsSep "," cfg.allowedPrivateIps
        );
        MEDIA_IMAGE_MAX_MB = toString cfg.media.imageMaxMb;
        MEDIA_GIF_MAX_MB = toString cfg.media.gifMaxMb;
        MEDIA_VIDEO_MAX_MB = toString cfg.media.videoMaxMb;
        MEDIA_VIDEO_MAX_SEC = toString cfg.media.videoMaxSec;
        MEDIA_GC_GRACE_DAYS = toString cfg.media.gcGraceDays;
        MEDIA_UPLOADS_PER_HOUR = toString cfg.media.uploadsPerHour;
      };

      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package}";
        StateDirectory = "opengym";
        DynamicUser = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
      };
    };

    services.caddy = lib.mkIf (cfg.reverseProxy.enable && cfg.reverseProxy.server == "caddy") {
      enable = true;
      virtualHosts."${cfg.reverseProxy.host}:${toString cfg.reverseProxy.port}".extraConfig = ''
        handle /api/* {
          reverse_proxy localhost:${toString cfg.port}
        }

        # Intercept built-in frontend media requests and map them to the Nix store path
        handle_path /media/* {
          root * ${cfg.package.passthru.frontend}/exercise-media
          file_server
        }

        # Catch-all for React static files and SPA fallback
        handle {
          root * ${cfg.package.passthru.frontend}
          try_files {path} /index.html
          file_server
        }
      '';
    };

    services.nginx = lib.mkIf (cfg.reverseProxy.enable && cfg.reverseProxy.server == "nginx") {
      enable = true;
      virtualHosts."${cfg.reverseProxy.host}" = {
        listen = [
          {
            addr = if cfg.reverseProxy.host == "localhost" then "127.0.0.1" else "0.0.0.0";
            port = cfg.reverseProxy.port;
          }
        ];
        locations."/api/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.port}";
          extraConfig = ''
            client_max_body_size ${if cfg.media.uploads then "48M" else "5M"};
            proxy_read_timeout 300s;
          '';
        };

        locations."/media/" = {
          alias = "${cfg.package.passthru.frontend}/exercise-media/";
        };

        locations."/" = {
          root = cfg.package.passthru.frontend;
          tryFiles = "$uri /index.html";
        };
      };
    };
  };

  meta = {
    maintainers = with lib.maintainers; [ luuumine ];
  };
}
