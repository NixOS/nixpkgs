{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    optionalAttrs
    ;

  inherit (lib.types)
    nullOr
    submodule
    bool
    str
    port
    enum
    ;

  cfg = config.services.bulwark;
in
{
  options.services.bulwark = {
    enable = mkEnableOption "Bulwark, a modern, self-hosted webmail client for Stalwart Mail Server.";
    package = mkPackageOption pkgs "bulwark" { };

    app_name = mkOption {
      type = str;
      default = "Webmail";
      description = "App name displayed in the UI, browser tab title, and PWA manifest.";
    };
    jmap_server_url = mkOption {
      type = nullOr str;
      default = null;
      description = "URL of your JMAP-compatible mail server (required unless `allow_custom_jmap_endpoint` is set).";
    };
    allow_custom_jmap_endpoint = mkOption {
      type = bool;
      default = false;
      description = ''
        Allow users to specify a custom JMAP server URL on the login form.
        When enabled, a "JMAP Server" field appears on the login page.
        Users can connect to any JMAP-compatible server.
      '';
    };

    stalwart_features = mkOption {
      type = bool;
      default = true;
      description = ''
        Enable Stalwart-specific features (password change, sieve filters, etc.).
        Set to `false` to disable if using a non-Stalwart JMAP server.
      '';
    };

    oauth = mkOption {
      type = submodule {
        options = {
          enabled = mkOption {
            type = bool;
            default = false;
            description = "Set to `true` to use OAuth instead of basic JMAP authentication.";
          };
          only = mkOption {
            type = bool;
            default = false;
            description = "Set to `true` to only allow OAuth login (hides username/password form).";
          };
          client_id = mkOption {
            type = str;
            description = "OAuth client ID registered with your identity provider.";
          };
          client_secret_file = mkOption {
            type = nullOr str;
            default = null;
            description = "Path to a file containing the OAuth client secret (server-side only, never exposed to the browser).";
          };
          issuer_url = mkOption {
            type = str;
            description = "OpenID Connect issuer URL for discovery.";
          };
        };
        config = mkIf config.enabled { };
      };
      default = { };
      description = "OAuth / OpenID Connect";
    };

    session_secret_file = mkOption {
      type = nullOr str;
      default = null;
      description = ''
        Path to a file containing the secret key for encrypting "Remember me" sessions and settings sync data.
        Required for both "Remember me" and settings sync features.
        Generate with: openssl rand -base64 32
      '';
    };

    settings_sync = mkOption {
      type = submodule {
        options = {
          enabled = mkOption {
            type = bool;
            default = false;
            description = ''
              Enable server-side settings persistence (requires `session_secret_file`).
              When enabled, user settings are encrypted and stored on the server,
              allowing them to sync across browsers and devices.
            '';
          };
          data_dir = mkOption {
            type = str;
            default = "/var/lib/bulwark/settings";
            description = "Directory for storing encrypted settings files.";
          };
        };
        config = mkIf config.enabled { };
      };
      default = { };
      description = "Settings Sync";
    };

    telemetry = mkOption {
      type = submodule {
        options = {
          enabled = mkOption {
            type = bool;
            default = true;
            description = ''
              Anonymous instance telemetry is enabled by default. Heartbeats contain no PII:
              version, platform, bucketed account counts, and feature toggles only. See
              https://bulwarkmail.org/docs/legal/privacy/telemetry for the full schema.
            '';
          };
          data_dir = mkOption {
            type = str;
            default = "/var/lib/bulwark/telemetry";
            description = "Directory for telemetry state: instance id, consent, login HMACs.";
          };
        };
        config = mkIf config.enabled { };
      };
      default = { };
      description = "Anonymous Telemetry";
    };

    admin_data_dir = mkOption {
      type = str;
      default = "/var/lib/bulwark/admin";
      description = ''
        Directory for admin dashboard state: config overrides, admin password hash,
        installed plugins/themes, and audit logs.
      '';
    };

    hostname = mkOption {
      type = str;
      default = "::";
      description = "Hostname the server binds to.";
    };
    port = mkOption {
      type = port;
      default = 3000;
      description = "Port the server listens on.";
    };

    log = {
      format = mkOption {
        type = enum [
          "text"
          "json"
        ];
        default = "text";
        description = "Log format: `text` (colored, human-readable) or `json` (structured, for log aggregation)";
      };
      level = mkOption {
        type = enum [
          "error"
          "warn"
          "info"
          "debug"
        ];
        default = "info";
        description = "Log level: `error`, `warn`, `info`, or `debug`";
      };
    };

    branding = {
      app_short_name = mkOption {
        type = nullOr str;
        default = null;
        description = ''
          Short name for the app, used in contexts where space is limited
          (e.g. home screen label on mobile). Defaults to `app_name` if not set.
        '';
      };
      app_description = mkOption {
        type = str;
        default = "Your personal webmail";
        description = "Description shown in the PWA manifest (displayed by the OS during install).";
      };
      favicon_url = mkOption {
        type = str;
        default = "/branding/Bulwark_Favicon.svg";
        description = ''
          Custom favicon shown in the browser tab.
          Supported formats: SVG (recommended), PNG, ICO.
          Can be an absolute URL (https://...) or a path relative to the public/ directory.
        '';
      };
      pwa = {
        icon_url = mkOption {
          type = nullOr str;
          default = null;
          description = ''
            Source image used to auto-generate PWA icons (192×192 and 512×512 PNG).
            Supported formats: SVG (recommended for best quality) or PNG (≥512×512px recommended).
            Can be an absolute URL (https://...) or a path relative to the public/ directory.
            Falls back to `branding.favicon_url` if not set, and to the default Bulwark icons if neither is set.
          '';
        };
        theme_color = mkOption {
          type = str;
          default = "#ffffff";
          description = ''
            Color applied to the browser UI chrome when the app is installed as a PWA
            (address bar, status bar on Android).
          '';
        };
        background_color = mkOption {
          type = str;
          default = "#ffffff";
          description = ''
            Background color shown on the PWA splash screen while the app is loading.
            Should match your app's main background color.
          '';
        };
      };
      app_logo_light_url = mkOption {
        type = nullOr str;
        default = "/branding/Bulwark_Logo_Color.svg";
        description = ''
          Logos shown in the sidebar (main app, after login).
          Supported formats: SVG (recommended), PNG, WebP.
          Recommended size: min 24×24px, max 128×128px.
          Can be absolute URLs or paths relative to the public/ directory.
          If not set, no logo is shown in the sidebar.
        '';
      };
      app_logo_dark_url = mkOption {
        type = nullOr str;
        default = "/branding/Bulwark_Logo_White.svg";
        description = ''
          Logos shown in the sidebar (main app, after login).
          Supported formats: SVG (recommended), PNG, WebP.
          Recommended size: min 24×24px, max 128×128px.
          Can be absolute URLs or paths relative to the public/ directory.
          If not set, no logo is shown in the sidebar.
        '';
      };
      login = {
        logo_light_url = mkOption {
          type = str;
          default = "/branding/Bulwark_Logo_Color.svg";
          description = ''
            Logos shown on the login page.
            Supported formats: SVG (recommended), PNG, WebP.
            Recommended size: min 32×32px, max 512×512px.
            Can be absolute URLs or paths relative to the public/ directory.
            Light mode logo (shown on light backgrounds).
          '';
        };
        logo_dark_url = mkOption {
          type = str;
          default = "/branding/Bulwark_Logo_White.svg";
          description = ''
            Logos shown on the login page.
            Supported formats: SVG (recommended), PNG, WebP.
            Recommended size: min 32×32px, max 512×512px.
            Can be absolute URLs or paths relative to the public/ directory.
            Dark mode logo (shown on dark backgrounds).
          '';
        };
        company_name = mkOption {
          type = nullOr str;
          default = null;
          description = "Company name shown above the version number on the login page.";
        };
        imprint_url = mkOption {
          type = nullOr str;
          default = null;
          description = "URL for the imprint / legal notice link on the login page.";
        };
        privacy_policy_url = mkOption {
          type = nullOr str;
          default = null;
          description = "URL for the privacy policy link on the login page.";
        };
        website_url = mkOption {
          type = nullOr str;
          default = null;
          description = "URL for the company website link on the login page.";
        };
      };
    };

    extension_directory = mkOption {
      type = submodule {
        options = {
          enabled = mkOption {
            type = bool;
            default = true;
            description = "Enable the BulwarkMail extension directory to browse and install plugins/themes from the directory.";
          };
          url = mkOption {
            type = str;
            default = "https://extensions.bulwarkmail.org";
            description = "URL of the BulwarkMail extension directory for the admin marketplace.";
          };
        };
        config = mkIf config.enabled { };
      };
      default = { };
      description = "Extension Directory / Marketplace";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.jmap_server_url != null || cfg.allow_custom_jmap_endpoint == true;
        message = ''
          <option>services.bulwark.jmap_server_url</option> needs to be set when <option>services.bulwark.allow_custom_jmap_endpoint</option> is `false`.
        '';
      }
      {
        assertion = cfg.settings_sync.enabled == false || cfg.session_secret_file != null;
        message = ''
          <option>services.bulwark.session_secret_file</option> needs to be set when <option>services.bulwark.settings_sync.enabled</option> is `true`.
        '';
      }
    ];

    users.users.bulwark = {
      isSystemUser = true;
      group = "bulwark";
    };
    users.groups.bulwark = { };

    systemd.services.bulwark = {
      description = "bulwark service";
      wantedBy = [ "multi-user.target" ];
      after = [
        "network-online.target"
      ];
      wants = [
        "network-online.target"
      ];
      serviceConfig = {
        ExecStart = lib.getExe cfg.package;
        User = "bulwark";
        Group = "bulwark";
        DynamicUser = true;

        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
        StateDirectory = "bulwark";
        BindReadOnlyPaths = [
          "/nix/store"
        ];
        CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
        LockPersonality = true;
        NoNewPrivileges = true;
        PrivateUsers = true;
        PrivateMounts = true;
        PrivateTmp = true;
        PrivateDevices = true;
        DevicePolicy = "closed";
        ProcSubset = "pid";
        ProtectSystem = "strict";
        ProtectClock = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectControlGroups = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        RemoveIPC = true;
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
        ];
      };

      environment = {
        APP_NAME = cfg.app_name;
        JMAP_SERVER_URL = cfg.jmap_server_url;
        ALLOW_CUSTOM_JMAP_ENDPOINT = if cfg.allow_custom_jmap_endpoint then "true" else "false";
        STALWART_FEATURES = if cfg.stalwart_features then "true" else "false";
        SESSION_SECRET_FILE = cfg.session_secret_file;
        ADMIN_DATA_DIR = cfg.admin_data_dir;
        BULWARK_TELEMETRY = if cfg.telemetry.enabled then "on" else "off";
        HOSTNAME = cfg.hostname;
        PORT = toString cfg.port;
        LOG_FORMAT = cfg.log.format;
        LOG_LEVEL = cfg.log.level;
        APP_SHORT_NAME = cfg.branding.app_short_name;
        APP_DESCRIPTION = cfg.branding.app_description;
        FAVICON_URL = cfg.branding.favicon_url;
        PWA_ICON_URL = cfg.branding.pwa.icon_url;
        PWA_THEME_COLOR = cfg.branding.pwa.theme_color;
        PWA_BACKGROUND_COLOR = cfg.branding.pwa.background_color;
        APP_LOGO_LIGHT_URL = cfg.branding.app_logo_light_url;
        APP_LOGO_DARK_URL = cfg.branding.app_logo_dark_url;
        LOGIN_LOGO_LIGHT_URL = cfg.branding.login.logo_light_url;
        LOGIN_LOGO_DARK_URL = cfg.branding.login.logo_dark_url;
        LOGIN_COMPANY_NAME = cfg.branding.login.company_name;
        LOGIN_IMPRINT_URL = cfg.branding.login.imprint_url;
        LOGIN_PRIVACY_POLICY_URL = cfg.branding.login.privacy_policy_url;
        LOGIN_WEBSITE_URL = cfg.branding.login.website_url;
      }
      // optionalAttrs cfg.oauth.enabled {
        OAUTH_ENABLED = "true";
        OAUTH_ONLY = if cfg.oauth.only then "true" else "false";
        OAUTH_CLIENT_ID = cfg.oauth.client_id;
        OAUTH_CLIENT_SECRET_FILE = cfg.oauth.client_secret_file;
        OAUTH_ISSUER_URL = cfg.oauth.issuer_url;
      }
      // optionalAttrs cfg.settings_sync.enabled {
        SETTINGS_SYNC_ENABLED = "true";
        SETTINGS_DATA_DIR = cfg.settings_sync.data_dir;
      }
      // optionalAttrs cfg.telemetry.enabled {
        TELEMETRY_DATA_DIR = cfg.telemetry.data_dir;
      }
      // optionalAttrs cfg.extension_directory.enabled {
        EXTENSION_DIRECTORY_URL = cfg.extension_directory.url;
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ Cameo007 ];
}
