{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.opengym;

  apiEnv = lib.filterAttrs (_: v: v != null) {
    PORT = toString cfg.apiPort;
    DATA_DIR = cfg.dataDir;
    RP_ID = cfg.rpId;
    ORIGIN = cfg.origin;
    RP_NAME = cfg.rpName;
    SESSION_DAYS = toString cfg.sessionDays;
    ALLOW_GUEST = if cfg.allowGuest then "1" else "0";
    INVITE_ONLY = if cfg.inviteOnly then "1" else "0";
    TRUST_PROXY = if cfg.trustProxy then "1" else "0";
    PASSWORD_LOGIN = if cfg.passwordLogin then "1" else "0";
    FIRST_USER_ADMIN = if cfg.firstUserAdmin then "1" else "0";
    DEFAULT_LANG = if cfg.defaultLang != null then cfg.defaultLang else null;
    AUDIT_LOG = if cfg.auditLog then "1" else "0";
    AUDIT_MAX = toString cfg.auditMax;
    AUDIT_DAYS = toString cfg.auditDays;
    AUDIT_IP = cfg.auditIp;
    VAPID_SUBJECT = if cfg.vapidSubject != "" then cfg.vapidSubject else null;
    ADMIN_UIDS = if cfg.adminUids != [ ] then (lib.concatStringsSep "," cfg.adminUids) else null;
    MEDIA_UPLOADS = if cfg.uploads.enabled then "1" else "0";
    MEDIA_QUOTA_MB = toString cfg.uploads.quotaMb;
    MEDIA_MIN_FREE_MB = toString cfg.uploads.minFreeMb;
    MEDIA_IMAGE_MAX_MB = toString cfg.uploads.imageMaxMb;
    MEDIA_GIF_MAX_MB = toString cfg.uploads.gifMaxMb;
    MEDIA_VIDEO_MAX_MB = toString cfg.uploads.videoMaxMb;
    MEDIA_VIDEO_MAX_SEC = toString cfg.uploads.videoMaxSec;
    MEDIA_GC_GRACE_DAYS = toString cfg.uploads.gcGraceDays;
    MEDIA_UPLOADS_PER_HOUR = toString cfg.uploads.perHour;
    COACH_DISABLED = if cfg.coachDisabled then "1" else "0";
    COACH_JOB_TIMEOUT_MS =
      if cfg.coachJobTimeoutSeconds != null then toString (cfg.coachJobTimeoutSeconds * 1000) else null;
    ALLOWED_PRIVATE_IPS =
      if cfg.allowedPrivateIps != [ ] then lib.concatStringsSep "," cfg.allowedPrivateIps else null;
  };

  serviceHardening = {
    NoNewPrivileges = true;
    ProtectSystem = "strict";
    ProtectHome = true;
    PrivateTmp = true;
    PrivateDevices = true;
    ProtectKernelTunables = true;
    ProtectKernelModules = true;
    ProtectKernelLogs = true;
    ProtectControlGroups = true;
    ProtectHostname = true;
    ProtectClock = true;
    RestrictNamespaces = true;
    RestrictSUIDSGID = true;
    RestrictRealtime = true;
    LockPersonality = true;
    RemoveIPC = true;
    UMask = "0077";
    CapabilityBoundingSet = "";
    SystemCallArchitectures = "native";
    RestrictAddressFamilies = [
      "AF_INET"
      "AF_INET6"
      "AF_UNIX"
      "AF_NETLINK"
    ];
    SystemCallFilter = [
      "@system-service"
      "~@privileged"
    ];
  };

  removedMedia = name: why: lib.mkRemovedOptionModule [ "services" "opengym" "media" name ] why;

in
{
  imports = [
    (removedMedia "fetchAtBuild" "The exercise media are part of the frontend package now; nothing is fetched.")
    (removedMedia "dataDir" "The exercise media are part of the frontend package now; there is no runtime media directory.")
    (removedMedia "imageRoot" "Use services.opengym.media.root (stills in still/, animations in clip/).")
    (removedMedia "gifRoot" "Use services.opengym.media.root (stills in still/, animations in clip/).")
  ];

  options.services.opengym = {
    enable = lib.mkEnableOption "openGym self-hosted gym tracker";

    package = lib.mkPackageOption pkgs "opengym" { };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/opengym";
      description = "Persistent data directory (db.json, state files, secrets).";
    };

    apiPort = lib.mkOption {
      type = lib.types.port;
      default = 3000;
      description = "Port the API listens on (internal, proxied by nginx).";
    };

    rpId = lib.mkOption {
      type = lib.types.str;
      default = "localhost";
      description = "WebAuthn Relying Party ID (bare hostname, must match address bar).";
    };

    origin = lib.mkOption {
      type = lib.types.str;
      default = "http://localhost:8080";
      description = "Full origin URL for CSRF validation (must match address bar).";
    };

    rpName = lib.mkOption {
      type = lib.types.str;
      default = "openGym";
      description = "Display name for passkey registration prompts.";
    };

    sessionDays = lib.mkOption {
      type = lib.types.ints.unsigned;
      default = 90;
      description = "Session cookie lifetime in days.";
    };

    adminUids = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "u-abc123" ];
      description = "User IDs granted admin access, as a list (ADMIN_UIDS, comma-joined).";
    };

    inviteOnly = lib.mkEnableOption "require invite code for new signups";

    passwordLogin = lib.mkEnableOption "offer name-and-password sign-in next to passkeys (PASSWORD_LOGIN)";

    firstUserAdmin = lib.mkEnableOption "grant the first profile created on an empty instance admin access (FIRST_USER_ADMIN)";

    trustProxy = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Let the sign-in throttle and audit log read the client address from the headers a proxy
        sets (TRUST_PROXY). Defaults to true because this module always fronts the API with a
        reverse proxy. Set false only if the API port is directly reachable, where those headers
        could be spoofed.
      '';
    };

    defaultLang = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "en";
      description = ''
        Default language for the sign-in screen and new profiles, as a language tag such as
        `pt-BR` or `de` (DEFAULT_LANG). `null` keeps the browser default.
      '';
    };

    allowGuest = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Allow 'Continue without account' (guest mode).";
    };

    auditLog = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable activity audit log.";
    };

    auditMax = lib.mkOption {
      type = lib.types.ints.unsigned;
      default = 5000;
      description = "Max audit events kept (0 = unlimited).";
    };

    auditDays = lib.mkOption {
      type = lib.types.ints.unsigned;
      default = 90;
      description = "Max days of audit events kept.";
    };

    auditIp = lib.mkOption {
      type = lib.types.enum [
        "off"
        "net"
        "full"
      ];
      default = "off";
      description = "IP recording mode: off, net (masked), full.";
    };

    vapidSubject = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "VAPID subject for push notifications (defaults to ORIGIN).";
    };

    coachDisabled = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Switch the AI Coach off (COACH_DISABLED).";
    };

    coachJobTimeoutSeconds = lib.mkOption {
      type = lib.types.nullOr lib.types.ints.unsigned;
      default = null;
      description = ''
        Raise the AI Coach's job budget for slow local models, in seconds (COACH_JOB_TIMEOUT_MS).
        `null` keeps the app's five-minute default; a set value is a floor of one minute.
      '';
    };

    allowedPrivateIps = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [
        "192.168.1.0/24"
        "10.0.0.0/8"
      ];
      description = "Private addresses and CIDR blocks the server may push to (webhooks), as a list (ALLOWED_PRIVATE_IPS).";
    };

    environment = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = ''
        Extra environment variables set on the opengym-api systemd unit. Useful for variables the
        module does not manage yet. Variables this module already derives from its own options take
        precedence. Mutually exclusive with environmentFile.
      '';
    };

    environmentFile = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = ''
        Path to an env file (KEY=VALUE per line) read by the opengym-api systemd unit. Mutually
        exclusive with environment.
      '';
    };

    nginx = {
      enable = lib.mkEnableOption "an nginx virtualHost for openGym, managed via services.nginx";

      hostName = lib.mkOption {
        type = lib.types.str;
        default = "localhost";
        defaultText = lib.literalExpression "config.services.opengym.rpId";
        description = "Server name the nginx virtualHost listens on (defaults to rpId).";
      };

      enableACME = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Serve openGym over TLS with a Let's Encrypt certificate (services.nginx enableACME +
          forceSSL). Also requires security.acme.acceptTerms = true in your configuration.
        '';
      };
    };

    media = {
      root = lib.mkOption {
        type = lib.types.path;
        readOnly = true;
        description = ''
          Directory with the exercise stills (still/<id>.webp) and animations (clip/<id>.mp4).
          It is the exercise-media/ directory inside web.root, so a web server serving web.root
          already serves it; the option is only there for setups that need the path on its own.
        '';
      };
    };

    uploads = {
      enabled = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Allow profiles to upload exercise and workout photos and videos (MEDIA_UPLOADS).";
      };

      quotaMb = lib.mkOption {
        type = lib.types.ints.unsigned;
        default = 200;
        description = "Media quota per profile, in MB (MEDIA_QUOTA_MB). 0 = no cap.";
      };

      minFreeMb = lib.mkOption {
        type = lib.types.ints.unsigned;
        default = 512;
        description = "Uploads stop below this much free disk space, in MB (MEDIA_MIN_FREE_MB). 0 = no floor.";
      };

      imageMaxMb = lib.mkOption {
        type = lib.types.ints.unsigned;
        default = 2;
        description = "Max size for a photo and its thumbnails, in MB (MEDIA_IMAGE_MAX_MB).";
      };

      gifMaxMb = lib.mkOption {
        type = lib.types.ints.unsigned;
        default = 8;
        description = "Max size for an animated GIF, in MB (MEDIA_GIF_MAX_MB).";
      };

      videoMaxMb = lib.mkOption {
        type = lib.types.ints.unsigned;
        default = 100;
        description = "Max size for a video, in MB (MEDIA_VIDEO_MAX_MB).";
      };

      videoMaxSec = lib.mkOption {
        type = lib.types.ints.unsigned;
        default = 60;
        description = "Maximum allowed video length, in seconds (MEDIA_VIDEO_MAX_SEC).";
      };

      gcGraceDays = lib.mkOption {
        type = lib.types.ints.unsigned;
        default = 14;
        description = "Days an unused upload is kept before garbage collection (MEDIA_GC_GRACE_DAYS).";
      };

      perHour = lib.mkOption {
        type = lib.types.ints.unsigned;
        default = 600;
        description = "Uploads permitted per profile per hour (MEDIA_UPLOADS_PER_HOUR).";
      };
    };

    web = {
      root = lib.mkOption {
        type = lib.types.path;
        readOnly = true;
        description = "Built frontend directory (static SPA). For use by a web server.";
      };
    };

    mcp = {
      enable = lib.mkEnableOption "openGym MCP server (stdio bridge for LLM clients)";

      uid = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          The openGym user ID (from db.json "users"[].id) the MCP server serves.
          When null, the server auto-picks when exactly one user exists; with multiple
          users this option must be set. Use the `environment` escape hatch for the
          same effect.
        '';
      };
    };
  };

  config = lib.mkMerge [
    {
      assertions = [
        {
          assertion = cfg.environment == { } || cfg.environmentFile == "";
          message = "services.opengym.environment and services.opengym.environmentFile are mutually exclusive; use only one.";
        }
        {
          assertion = !cfg.nginx.enable || cfg.nginx.hostName != "";
          message = "services.opengym.nginx.hostName must be set when services.opengym.nginx.enable is true.";
        }
        {
          assertion = !cfg.nginx.enableACME || cfg.nginx.enable;
          message = "services.opengym.nginx.enable must be true to use services.opengym.nginx.enableACME.";
        }
      ];
    }
    (lib.mkIf cfg.enable (
      lib.mkMerge [
        {
          users.users.opengym = {
            isSystemUser = true;
            group = "opengym";
            description = "openGym service user";
          };

          users.groups.opengym = { };

          systemd.tmpfiles.rules = [
            "d ${cfg.dataDir} 0750 opengym opengym - -"
          ];

          systemd.services.opengym-api = {
            description = "openGym API server";
            after = [ "network.target" ];
            wantedBy = [ "multi-user.target" ];
            environment = cfg.environment // apiEnv;
            serviceConfig = lib.mkMerge [
              {
                ExecStart = "${cfg.package}/bin/opengym";
                User = "opengym";
                Group = "opengym";
                Restart = "on-failure";
                RestartSec = 5;
                EnvironmentFile = lib.mkIf (cfg.environmentFile != "") cfg.environmentFile;
                ReadWritePaths = [ cfg.dataDir ];
              }
              serviceHardening
              (lib.mkIf (builtins.toString cfg.dataDir == "/var/lib/opengym") {
                StateDirectory = "opengym";
                StateDirectoryMode = "0750";
              })
            ];
          };

          services.opengym.web.root = "${cfg.package.passthru.frontend}/share/opengym";
          services.opengym.media.root = "${cfg.web.root}/exercise-media";

          systemd.services.opengym-mcp = lib.mkIf cfg.mcp.enable {
            description = "openGym MCP server";
            after = [ "network.target" ];
            wantedBy = [ "multi-user.target" ];
            environment = {
              OPENGYM_DATA = cfg.dataDir;
            }
            // lib.optionalAttrs (cfg.mcp.uid != null) {
              OPENGYM_UID = cfg.mcp.uid;
            };
            serviceConfig = lib.mkMerge [
              {
                ExecStart = "${cfg.package.passthru.mcp}/bin/opengym-mcp";
                StandardInput = "null";
                StandardOutput = "journal";
                User = "opengym";
                Group = "opengym";
                Restart = "on-failure";
                ReadWritePaths = [ cfg.dataDir ];
              }
              serviceHardening
            ];
          };
        }
        (lib.mkIf cfg.nginx.enable {
          services.nginx = {
            enable = true;
            recommendedOptimisation = true;
            recommendedGzipSettings = true;
            virtualHosts.${cfg.nginx.hostName} = {
              root = cfg.web.root;
              locations = {
                "/" = {
                  tryFiles = "$uri $uri/ /index.html";
                };

                "/api/" = {
                  proxyPass = "http://127.0.0.1:${toString cfg.apiPort}";
                  extraConfig = ''
                    proxy_http_version 1.1;
                    proxy_set_header Host $host;
                    proxy_set_header X-Real-IP $remote_addr;
                    proxy_set_header X-Forwarded-For $remote_addr;
                    proxy_set_header X-Forwarded-Proto $scheme;
                    proxy_set_header CF-Connecting-IP "";
                  '';
                };

                "/exercise-media/" = {
                  extraConfig = ''
                    add_header Cache-Control "public, max-age=2592000, immutable";
                    add_header Cross-Origin-Resource-Policy "same-origin" always;
                  '';
                };
              };
            }
            // lib.optionalAttrs cfg.nginx.enableACME {
              enableACME = true;
              forceSSL = true;
            };
          };
        })
      ]
    ))
  ];

  meta = {
    maintainers = with lib.maintainers; [ luuumine ];
  };
}
