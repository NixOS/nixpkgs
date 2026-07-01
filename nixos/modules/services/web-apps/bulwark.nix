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
    attrsToList
    nameValuePair
    ;

  inherit (lib.types)
    nullOr
    submodule
    bool
    str
    port
    enum
    attrsOf
    listOf
    ;

  cfg = config.services.bulwark;
  format = pkgs.formats.json { };

  flattenAttrSet =
    key: keyName: value:
    nameValuePair key (map (it: { "${keyName}" = it.name; } // it.value) (attrsToList value));
  renameOptions =
    parent:
    lib.mapAttrs' (
      name: value: lib.nameValuePair (lib.strings.toCamelCase "${parent}_${name}") value
    ) cfg.settings."${parent}";

  brandingModule = {
    appName = mkOption {
      type = str;
      default = "Webmail";
      description = "App name displayed in the UI, browser tab title, and PWA manifest.";
    };
    appShortName = mkOption {
      type = nullOr str;
      description = ''
        Short name for the app, used in contexts where space is limited
        (e.g. home screen label on mobile). Defaults to `settings.appName` if not set.
      '';
    };
    appDescription = mkOption {
      type = str;
      default = "Your personal webmail";
      description = "Description shown in the PWA manifest (displayed by the OS during install).";
    };
    faviconUrl = mkOption {
      type = str;
      default = "/branding/Bulwark_Favicon.svg";
      description = ''
        Custom favicon shown in the browser tab.
        Supported formats: SVG (recommended), PNG, ICO.
        Can be an absolute URL (https://...) or a path relative to the public/ directory.
      '';
    };
    pwaIconUrl = mkOption {
      type = nullOr str;
      description = ''
        Source image used to auto-generate PWA icons (192×192 and 512×512 PNG).
        Supported formats: SVG (recommended for best quality) or PNG (≥512×512px recommended).
        Can be an absolute URL (https://...) or a path relative to the public/ directory.
        Falls back to `settings.branding.faviconUrl` if not set, and to the default Bulwark icons if neither is set.
      '';
    };
    pwaScreenshotMobileUrl = mkOption {
      type = nullOr str;
      description = ''
        PWA Screenshot (Mobile)
        Supported formats: PNG, JPG, WebP.
        Can be absolute URLs or paths relative to the public/ directory.
      '';
    };
    pwaScreenshotDesktopUrl = mkOption {
      type = nullOr str;
      description = ''
        PWA Screenshot (Desktop)
        Supported formats: PNG, JPG, WebP.
        Can be absolute URLs or paths relative to the public/ directory.
      '';
    };
    pwaThemeColor = mkOption {
      type = str;
      default = "#ffffff";
      description = ''
        Color applied to the browser UI chrome when the app is installed as a PWA
        (address bar, status bar on Android).
      '';
    };
    pwaBackgroundColor = mkOption {
      type = str;
      default = "#ffffff";
      description = ''
        Background color shown on the PWA splash screen while the app is loading.
        Should match your app's main background color.
      '';
    };
    appLogoLightUrl = mkOption {
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
    appLogoDarkUrl = mkOption {
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

    loginLogoLightUrl = mkOption {
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
    loginLogoDarkUrl = mkOption {
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
    loginCompanyName = mkOption {
      type = nullOr str;
      description = "Company name shown above the version number on the login page.";
    };
    loginImprintUrl = mkOption {
      type = nullOr str;
      description = "URL for the imprint / legal notice link on the login page.";
    };
    loginPrivacyPolicyUrl = mkOption {

      type = nullOr str;
      description = "URL for the privacy policy link on the login page.";
    };
    loginWebsiteUrl = mkOption {
      type = nullOr str;
      description = "URL for the company website link on the login page.";
    };
  };
in
{
  options.services.bulwark = {
    enable = mkEnableOption "Bulwark, a modern, self-hosted webmail client for Stalwart Mail Server.";
    package = mkPackageOption pkgs "bulwark" { };

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

    settings_data_dir = mkOption {
      type = str;
      default = "/var/lib/bulwark/settings";
      description = "Directory for storing encrypted settings files.";
    };
    admin_state_dir = mkOption {
      type = str;
      default = "/var/lib/bulwark/admin-state";
      description = ''
        State dir - runtime mutations. Holds admin-state.json (login timestamps),
        audit.log, and the bootstrap setup token. Always read-write.
      '';
    };
    version_check_data_dir = mkOption {
      type = str;
      default = "/var/lib/bulwark/version-check";
      description = ''
        Version check dir - necessary to perform version checks.
      '';
    };

    telemetry = mkOption {
      type = submodule {
        options = {
          enabled = mkOption {
            type = bool;
            default = false;
            description = ''
              Anonymous instance telemetry is OPT-IN and disabled by default. Enabling it
              helps us understand how Bulwark is used so we can make the product better.
              Heartbeats contain no PII: version, platform, bucketed account counts, and
              feature toggles only - never email addresses, hostnames, or IPs. See
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

    settings = mkOption {
      type = submodule {
        freeformType = format.type;

        options = {
          jmapServerUrl = mkOption {
            type = nullOr str;
            description = "URL of your JMAP-compatible mail server (required unless `settings.allowCustomJmapEndpoint` is set).";
          };
          jmapServers = mkOption {
            type = attrsOf (submodule {
              options = {
                label = mkOption {
                  type = str;
                  description = "Server label";
                };
                url = mkOption {
                  type = str;
                  description = "JMAP URL";
                };
                domains = mkOption {
                  type = listOf str;
                  description = "Email domains";
                };
              };
            });
            default = { };
            description = "Allow users to connect to multiple JMAP servers.";
          };
          jmapServerAutoPickByDomain = mkOption {
            type = bool;
            default = false;
            description = "When users type their email, automatically select the matching server from `settings.jmapServers`.";
          };
          allowCustomJmapEndpoint = mkOption {
            type = bool;
            default = false;
            description = ''
              Allow users to specify a custom JMAP server URL on the login form.
              When enabled, a "JMAP Server" field appears on the login page.
              Users can connect to any JMAP-compatible server.
            '';
          };

          stalwartFeaturesEnabled = mkOption {
            type = bool;
            default = true;
            description = ''
              Enable Stalwart-specific features (password change, sieve filters, etc.).
              Set to `false` to disable if using a non-Stalwart JMAP server.
            '';
          };

          searchEngineIndexing = mkOption {
            type = bool;
            default = false;
            description = ''
              Allow search engines to index this webmail. Off (the default) sends noindex/nofollow in the page head, recommended for private deployments.
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
                clientId = mkOption {
                  type = str;
                  description = "OAuth client ID registered with your identity provider.";
                };
                clientSecretFile = mkOption {
                  type = nullOr str;
                  description = "Path to a file containing the OAuth client secret (server-side only, never exposed to the browser).";
                };
                issuerUrl = mkOption {
                  type = str;
                  description = "OpenID Connect issuer URL for discovery.";
                };
                authorizeUrl = mkOption {
                  type = nullOr str;
                  description = ''
                    Overrides only the user-facing authorize endpoint (e.g. a per-brand login
                    host). Discovery, token exchange and refresh keep using `settings.oauth.issuerUrl`.
                    Leave unset to use the authorization_endpoint from discovery.
                  '';
                };
                scopes = mkOption {
                  type = str;
                  default = "openid email profile";
                  description = "OpenID Connect scopes.";
                };
                extraScopes = mkOption {
                  type = str;
                  default = "";
                  description = "Additional OpenID Connect scopes (urn:ietf:params:oauth:...).";
                };
                allowPrivateEndpoints = mkOption {
                  type = bool;
                  default = false;
                  description = ''
                    Allow OAuth discovery to resolve to private (RFC-1918 / loopback) addresses.
                    Off by default as an SSRF guard. Enable for split-DNS deployments where the
                    OAuth issuer's public hostname resolves to an internal IP from this server.
                  '';
                };
              };
              config = mkIf config.enabled { };
            };
            default = { };
            description = "OAuth / OpenID Connect";
          };

          autoSsoEnabled = mkOption {
            type = bool;
            default = false;
            description = "Automatically redirect to SSO provider on load.";
          };
          cookieSameSite = mkOption {
            type = enum [
              "lax"
              "strict"
              "none"
            ];
            default = "lax";
            description = "Value of the `SameSite` attribute for the session cookie.";
          };
          allowedFrameAncestors = mkOption {
            type = nullOr str;
            description = "Specifiy the CSP `frame-ancestors` directive.";
          };
          parentOrigin = mkOption {
            type = nullOr str;
            description = "Parent Origin for embedded mode communication";
          };

          sessionSecretFile = mkOption {
            type = nullOr str;
            description = ''
              Path to a file containing the secret key for encrypting "Remember me" sessions and settings sync data.
              Required for both "Remember me" and settings sync features.
              Generate with: openssl rand -base64 32
            '';
          };

          settingsSyncEnabled = mkOption {
            type = bool;
            default = false;
            description = ''
              Enable server-side settings persistence (requires `settings.sessionSecretFile`).
              When enabled, user settings are encrypted and stored on the server,
              allowing them to sync across browsers and devices.
            '';
          };

          logFormat = mkOption {
            type = enum [
              "text"
              "json"
            ];
            default = "text";
            description = "Log format: `text` (colored, human-readable) or `json` (structured, for log aggregation)";
          };
          logLevel = mkOption {
            type = enum [
              "error"
              "warn"
              "info"
              "debug"
            ];
            default = "info";
            description = "Log level: `error`, `warn`, `info`, or `debug`";
          };

          branding = brandingModule;

          domainBranding = mkOption {
            type = attrsOf (submodule {
              options = brandingModule;
            });
            default = { };
            description = ''
              When you serve the webmail on multiple hostnames, each hostname can override
              a subset of branding fields. Unset fields fall back to the global values.
              Match is on the request's Host (or X-Forwarded-Host) header.

              Use "*." to match any subdomain (e.g. "*.example.com"
              matches mail.example.com and any deeper subdomain, but NOT example.com).
              Exact matches always win over wildcards; the longest wildcard suffix wins
              among multiple wildcard matches.
            '';
          };

          extensionDirectoryUrl = mkOption {
            type = str;
            default = "https://extensions.bulwarkmail.org";
            description = "URL of the BulwarkMail extension directory for the admin marketplace.";
          };
        };
      };
      default = { };
      description = "Bulwark configuration";
    };

    admin = mkOption {
      type = submodule {
        options.passwordHashFile = mkOption {
          type = str;
          description = ''
            File containing the admin password hash

            Generate with
            ```
            SALT=$(openssl rand -hex 32)
            HASH64=$(openssl kdf \
              -kdfopt pass:"YOUR-PASSWORD" \
              -kdfopt hexsalt:$SALT \
              -keylen 64 -kdfopt n:16384 -kdfopt r:8 -kdfopt p:1 \
              -binary SCRYPT | base64)
            SALT64=$(echo $SALT | xxd -r -p | base64)

            echo "\$scrypt\$N=16384,r=8,p=1\$$SALT64\$$HASH64"
            ```
          '';
        };
      };
      default = { };
      description = "Bulwark Admin configuration";
    };

    policies = mkOption {
      type = submodule {
        freeformType = format.type;

        options = {
          features =
            let
              feature =
                description:
                mkOption {
                  type = bool;
                  default = true;
                  description = description;
                };
            in
            {
              pluginsEnabled = feature "Allow the plugin system to load and run plugins for users.";
              requirePluginApproval = feature "User-uploaded plugins must be approved by an admin before they can be enabled.";
              themesEnabled = feature "Allow users to select and apply themes.";
              sidebarAppsEnabled = feature "Allow custom web apps in navigation rail.";
              settingsExportEnabled = feature "Allow users to export and import settings JSON.";
              customKeywordsEnabled = feature "Allow user-created labels and tags.";
              templatesEnabled = feature "Allow email template creation and library.";
              calendarTasksEnabled = feature "Show task panel in calendar view.";
              smimeEnabled = feature "Enable certificate management and email signing.";
              externalContentEnabled = feature "Allow users to choose external content loading policy.";
              debugModeEnabled = feature "Allow users to enable debug/diagnostic mode.";
              folderIconsEnabled = feature "Allow custom folder icon picker.";
              hoverActionsConfigEnabled = feature "Allow users to customize email hover actions.";
              filesEnabled = feature "Enable file storage via WebDAV. WARNING: Large uploads can cause Stalwart/RocksDB instability. Not recommended for production.";
              contactsEnabled = feature "Enable contacts/address book features.";
            };
          restrictions =
            let
              restricted =
                description:
                mkOption {
                  type = submodule {
                    options = {
                      locked = mkOption {
                        type = bool;
                        default = false;
                        description = "Whether this option is locked.";
                      };
                      hidden = mkOption {
                        type = bool;
                        default = false;
                        description = "Whether this option is hidden.";
                      };
                    };
                  };
                  default = { };
                  description = description;
                };
            in
            {
              fontSize = restricted "Appearance: Font Size";
              density = restricted "Appearance: Density";
              animationsEnabled = restricted "Appearance: Animations";
              markAsReadDelay = restricted "Email: Mark as Read Delay";
              deleteAction = restricted "Email: Delete Action";
              showPreview = restricted "Email: Show Preview";
              mailLayout = restricted "Email: Mail Layout";
              emailsPerPage = restricted "Email: Emails Per Page";
              externalContentPolicy = restricted "Email: External Content Policy";
              sendConfirmation = restricted "Composer: Send Confirmation";
              defaultReplyMode = restricted "Composer: Default Reply Mode";
              autoSelectReplyIdentity = restricted "Composer: Auto-select Reply Identity";
              plainTextMode = restricted "Composer: Plain Text Only";
              sessionTimeout = restricted "Privacy: Session Timeout";
              emailNotificationsEnabled = restricted "Notifications: Email Notifications";
              calendarNotificationsEnabled = restricted "Notifications: Calendar Notifications";
              debugMode = restricted "Advanced: Debug Mode";
            };

          pushRelayUrl = mkOption {
            type = str;
            default = "";
            description = "Override the Web Push relay URL shown in user notification settings.";
          };
          pushRelayUrlLocked = mkOption {
            type = bool;
            default = false;
            description = "Whether the Web Push relay URL is locked.";
          };

          themePolicy =
            let
              builtinThemes = [
                "builtin-qui"
                "builtin-nord"
                "builtin-catppuccin"
                "builtin-solarized"
                "builtin-roundcube-elastic"
                "builtin-aurora-glass"
              ];
            in
            {
              disabledBuiltinThemes = mkOption {
                type = listOf (enum builtinThemes);
                default = [ ];
                description = "Disabled builtin Themes";
              };
              disabledThemes = mkOption {
                type = listOf str;
                default = [ ];
                description = "Disabled Themes";
              };
              defaultThemeId = mkOption {
                type = nullOr (enum builtinThemes);
                description = "Theme applied when users have not chosen one.";
              };
            };

          forceEnabledPlugins = mkOption {
            type = listOf str;
            default = [ ];
            description = "Force-enabled Plugins";
          };
          approvedPlugins = mkOption {
            type = listOf str;
            default = [ ];
            description = "Approved Plugins";
          };
          forceEnabledThemes = mkOption {
            type = listOf str;
            default = [ ];
            description = "Force-enabled Themes";
          };
        };
      };
      default = { };
      description = "Bulwark Policy configuration";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.settings.jmapServerUrl != null || cfg.settings.allowCustomJmapEndpoint == true;
        message = ''
          <option>services.bulwark.settings.jmapServerUrl</option> needs to be set when <option>services.bulwark.settings.allowCustomJmapEndpoint</option> is `false`.
        '';
      }
      {
        assertion = cfg.settings.settingsSyncEnabled == false || cfg.settings.sessionSecretFile != null;
        message = ''
          <option>services.bulwark.settings.sessionSecretFile</option> needs to be set when <option>services.bulwark.settingsSyncEnabled</option> is `true`.
        '';
      }
      {
        assertion =
          !builtins.elem cfg.policies.themePolicy.defaultThemeId cfg.policies.themePolicy.disabledBuiltinThemes;
        message = ''
          The default theme specified in <option>services.bulwark.policies.themePolicy.defaultThemeId</option> cannot be disabled via <option>services.bulwark.policies.themePolicy.disabledBuiltinThemes</option>.
        '';
      }
      {
        assertion =
          lib.lists.intersectLists cfg.policies.themePolicy.disabledThemes cfg.policies.forceEnabledThemes
          == [ ];
        message = ''
          The themes disabled via <option>services.bulwark.policies.themePolicy.disabledThemes</option> cannot be enabled at the same time through <option>services.bulwark.policies.forceEnabledThemes</option>.
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
        ADMIN_CONFIG_DIR = toString (
          pkgs.linkFarm "bulwark-admin-config-dir" (
            {
              "config.json" = format.generate "config.json" (
                lib.mapAttrs'
                  (
                    name: value:
                    if name == "jmapServers" then
                      flattenAttrSet name "id" value
                    else if name == "domainBranding" then
                      flattenAttrSet name "host" value
                    else
                      nameValuePair name value
                  )
                  (
                    builtins.removeAttrs
                      (
                        cfg.settings
                        // cfg.settings.branding
                        // optionalAttrs cfg.settings.oauth.enabled (renameOptions "oauth")
                      )
                      [
                        "branding"
                        "oauth"
                      ]
                  )

                // {
                  setupComplete = true;
                }
              );
              "policy.json" = format.generate "policy.json" (
                cfg.policies
                // {
                  features.pluginsUploadEnabled = false;
                  features.userThemesEnabled = false;
                }
              );
            }
            // optionalAttrs (cfg.admin != { }) {
              "admin.json" = format.generate "admin.json" cfg.admin;
            }
          )
        );
        ADMIN_CONFIG_READONLY = "true";

        HOSTNAME = cfg.hostname;
        PORT = toString cfg.port;
        ADMIN_STATE_DIR = cfg.admin_state_dir;
        VERSION_CHECK_DATA_DIR = cfg.version_check_data_dir;
        BULWARK_TELEMETRY = if cfg.telemetry.enabled then "on" else "off";
      }
      // optionalAttrs cfg.settings.settingsSyncEnabled {
        SETTINGS_DATA_DIR = cfg.settings_data_dir;
      }
      // optionalAttrs cfg.telemetry.enabled {
        TELEMETRY_DATA_DIR = cfg.telemetry.data_dir;
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ Cameo007 ];
}
