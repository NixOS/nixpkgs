{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.changedetection-io;
in
{
  options.services.changedetection-io = {
    enable = mkEnableOption "changedetection-io";

    user = mkOption {
      default = "changedetection-io";
      type = types.str;
      description = ''
        User account under which changedetection-io runs.
      '';
    };

    group = mkOption {
      default = "changedetection-io";
      type = types.str;
      description = ''
        Group account under which changedetection-io runs.
      '';
    };

    listenAddress = mkOption {
      type = types.str;
      default = "localhost";
      description = "Address the server will listen on.";
    };

    port = mkOption {
      type = types.port;
      default = 5000;
      description = "Port the server will listen on.";
    };

    datastorePath = mkOption {
      type = types.str;
      default = "/var/lib/changedetection-io";
      description = ''
        The directory used to store all data for changedetection-io.
      '';
    };

    baseURL = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "https://changedetection-io.example";
      description = ''
        The base url used in notifications and `{base_url}` token.
      '';
    };

    behindProxy = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable this option when changedetection-io runs behind a reverse proxy, so that it trusts X-* headers.
        It is recommend to run changedetection-io behind a TLS reverse proxy.
      '';
    };

    environmentFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/run/secrets/changedetection-io.env";
      description = ''
        Securely pass environment variabels to changedetection-io.

        This can be used to set for example a frontend password reproducible via `SALTED_PASS`
        which convinetly also deactivates nags about the hosted version.
        `SALTED_PASS` should be 64 characters long while the first 32 are the salt and the second the frontend password.
        It can easily be retrieved from the settings file when first set via the frontend with the following command:
        ``jq -r .settings.application.password /var/lib/changedetection-io/url-watches.json``
      '';
    };

    webDriverSupport = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable support for fetching web pages using WebDriver and Chromium.
        This starts a headless chromium controlled by puppeteer in an oci container.

        ::: {.note}
        Playwright can currently leak memory.
        See https://github.com/dgtlmoon/changedetection.io/wiki/Playwright-content-fetcher#playwright-memory-leak
        :::
      '';
    };

    playwrightSupport = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable support for fetching web pages using playwright and Chromium.
        This starts a headless Chromium controlled by puppeteer in an oci container.

        ::: {.note}
        Playwright can currently leak memory.
        See https://github.com/dgtlmoon/changedetection.io/wiki/Playwright-content-fetcher#playwright-memory-leak
        :::
      '';
    };

    chromePort = mkOption {
      type = types.port;
      default = 4444;
      description = ''
        A free port on which webDriverSupport or playwrightSupport listen on localhost.
      '';
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = !((cfg.webDriverSupport == true) && (cfg.playwrightSupport == true));
        message = "'services.changedetection-io.webDriverSupport' and 'services.changedetection-io.playwrightSupport' cannot be used together.";
      }
    ];

    systemd =
      let
        defaultStateDir = cfg.datastorePath == "/var/lib/changedetection-io";
      in
      {
        services.changedetection-io = {
          wantedBy = [ "multi-user.target" ];
          after = [ "network.target" ];
          preStart = ''
            mkdir -p ${cfg.datastorePath}
          '';
          serviceConfig = {
            User = cfg.user;
            Group = cfg.group;
            StateDirectory = mkIf defaultStateDir "changedetection-io";
            StateDirectoryMode = mkIf defaultStateDir "0750";
            WorkingDirectory = cfg.datastorePath;
            Environment =
              [ "HIDE_REFERER=true" ]
              ++ lib.optional (cfg.baseURL != null) "BASE_URL=${cfg.baseURL}"
              ++ lib.optional cfg.behindProxy "USE_X_SETTINGS=1"
              ++ lib.optional cfg.webDriverSupport "WEBDRIVER_URL=http://127.0.0.1:${toString cfg.chromePort}/wd/hub"
              ++ lib.optional cfg.playwrightSupport "PLAYWRIGHT_DRIVER_URL=ws://127.0.0.1:${toString cfg.chromePort}/?stealth=1&--disable-web-security=true";
            EnvironmentFile = mkIf (cfg.environmentFile != null) cfg.environmentFile;
            ExecStart = ''
              ${pkgs.changedetection-io}/bin/changedetection.py \
                -h ${cfg.listenAddress} -p ${toString cfg.port} -d ${cfg.datastorePath}
            '';
            ProtectHome = true;
            ProtectSystem = true;
            Restart = "on-failure";
          };
        };
        tmpfiles.rules = mkIf defaultStateDir [
          "d ${cfg.datastorePath} 0750 ${cfg.user} ${cfg.group} - -"
        ];
      };

    users = {
      users = optionalAttrs (cfg.user == "changedetection-io") {
        "changedetection-io" = {
          isSystemUser = true;
          group = "changedetection-io";
        };
      };

      groups = optionalAttrs (cfg.group == "changedetection-io") {
        "changedetection-io" = { };
      };
    };

    virtualisation = {
      oci-containers.containers = lib.mkMerge [
        (mkIf cfg.webDriverSupport {
          changedetection-io-webdriver = {
            image = "selenium/standalone-chrome";
            environment = {
              VNC_NO_PASSWORD = "1";
              SCREEN_WIDTH = "1920";
              SCREEN_HEIGHT = "1080";
              SCREEN_DEPTH = "24";
            };
            ports = [
              "127.0.0.1:${toString cfg.chromePort}:4444"
            ];
            volumes = [
              "/dev/shm:/dev/shm"
            ];
            extraOptions = [ "--network=bridge" ];
          };
        })

        (mkIf cfg.playwrightSupport {
          changedetection-io-playwright = {
            image = "browserless/chrome";
            environment = {
              SCREEN_WIDTH = "1920";
              SCREEN_HEIGHT = "1024";
              SCREEN_DEPTH = "16";
              ENABLE_DEBUGGER = "false";
              PREBOOT_CHROME = "true";
              CONNECTION_TIMEOUT = "300000";
              MAX_CONCURRENT_SESSIONS = "10";
              CHROME_REFRESH_TIME = "600000";
              DEFAULT_BLOCK_ADS = "true";
              DEFAULT_STEALTH = "true";
            };
            ports = [
              "127.0.0.1:${toString cfg.chromePort}:3000"
            ];
            extraOptions = [ "--network=bridge" ];
          };
        })
      ];
      podman.defaultNetwork.settings.dns_enabled = true;
    };
  };
}
