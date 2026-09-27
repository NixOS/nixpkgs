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
      description = "Set 1 and new profiles need an invite code you generate from the dashboard. Existing accounts keep working.";
    };

    allowGuest = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Set 0 to remove Continue without account. Guest data isn't deleted — it stays in that browser and returns if you re-enable guests, or moves into a profile created on the same device.";
    };

    auditLog = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Record sign-ins and admin actions to the activity log — set 0 to record nothing.";
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
        AUDIT_LOG = if cfg.auditLog then "1" else "0";
        AUDIT_MAX = toString cfg.auditMax;
        AUDIT_DAYS = toString cfg.auditDays;
        AUDIT_IP = cfg.auditIp;
        VAPID_SUBJECT = cfg.vapidSubject;
        COACH_DISABLED = if cfg.coachDisabled then "1" else "0";
      }
      // lib.optionalAttrs (cfg.coachJobTimeoutSeconds != null) {
        COACH_JOB_TIMEOUT_MS = toString (cfg.coachJobTimeoutSeconds * 1000);
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
        handle_path /img/* {
          root * ${cfg.package.passthru.media}/img
          file_server
        }
        handle_path /gif/* {
          root * ${cfg.package.passthru.media}/gif
          file_server
        }
        handle /api/* {
          reverse_proxy localhost:${toString cfg.port}
        }
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
        locations."/img/" = {
          alias = "${cfg.package.passthru.media}/img/";
        };
        locations."/gif/" = {
          alias = "${cfg.package.passthru.media}/gif/";
        };
        locations."/api/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.port}";
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
