{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.wealthfolio;
in
{
  options.services.wealthfolio = {
    enable = lib.mkEnableOption "Wealthfolio personal investment tracker";
    package = lib.mkPackageOption pkgs "wealthfolio-server" { };

    address = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = "The IP address the Wealthfolio server binds to.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8088;
      description = "The port the Wealthfolio server listens on.";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to automatically open the specified port in the system firewall.";
    };

    secretKeyFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = lib.literalExpression "config.age.secrets.wealthfolio-key.path";
      description = ''
        Path to a file containing the 32-byte secret key used for encrypting sensitive data
        at rest (broker credentials, API keys) and signing JWT tokens.

        Generate with: `openssl rand -base64 32`.

        Note: Losing this key means losing access to all stored encrypted secrets.
        There is no recovery.
      '';
    };

    authPasswordHashFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = lib.literalExpression "config.age.secrets.wealthfolio-hash.path";
      description = ''
        Path to a file containing the Argon2id PHC string defining the login password.
        Required for web access unless `authRequired` is false.

        Generate with: `printf 'your-password' | argon2 yoursalt16chars! -id -e`
      '';
    };

    authRequired = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Whether to require internal authentication.

        Security Note: The server panics at startup if the listener is bound to a
        non-loopback address and authentication is disabled. Set this to `false`
        only if a reverse proxy handles authentication for you.
      '';
    };

    corsAllowOrigins = lib.mkOption {
      type = lib.types.str;
      default = "*";
      example = "https://wealthfolio.example.com";
      description = ''
        Comma-separated list of allowed CORS origins.

        Security Note: The server panics at startup if `*` is used while authentication
        is enabled, as this is a CSRF vector. Set explicit origins matching your
        deployment URL (scheme + host + port).
      '';
    };

    authTokenTtlMinutes = lib.mkOption {
      type = lib.types.ints.positive;
      default = 60;
      description = "JWT access token lifetime in minutes. (e.g., 1440 for 24h, 10080 for 7d).";
    };

    cookieSecure = lib.mkOption {
      type = lib.types.enum [
        "auto"
        "true"
        "false"
      ];
      default = "auto";
      description = ''
        Controls the Secure attribute on the authentication session cookie.
        - auto: Sets Secure based on HTTPS protocol.
        - true: Always sets Secure (Use behind a reverse proxy that terminates HTTPS).
        - false: Never sets Secure (Not recommended).
      '';
    };

    requestTimeoutMs = lib.mkOption {
      type = lib.types.ints.positive;
      default = 300000;
      description = "HTTP request timeout in milliseconds. Default (5m) accommodates large broker syncs.";
    };

    logFormat = lib.mkOption {
      type = lib.types.enum [
        "text"
        "json"
      ];
      default = "text";
      description = "Log output format. `json` is recommended if shipping to log aggregators.";
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = lib.optional cfg.openFirewall cfg.port;

    assertions = [
      {
        assertion = cfg.secretKeyFile != null;
        message = "services.wealthfolio: secretKeyFile must be provided.";
      }
      {
        assertion = cfg.authRequired -> cfg.authPasswordHashFile != null;
        message = "services.wealthfolio: authPasswordHashFile must be provided when authRequired is true.";
      }
      {
        assertion = cfg.authRequired -> cfg.corsAllowOrigins != "*";
        message = "services.wealthfolio: corsAllowOrigins cannot be '*' when authRequired is true. Provide an explicit domain.";
      }
    ];

    systemd.services.wealthfolio = {
      description = "Wealthfolio server service daemon.";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      environment = {
        WF_LISTEN_ADDR = "${cfg.address}:${toString cfg.port}";
        WF_DB_PATH = "/var/lib/wealthfolio/wealthfolio.db";
        WF_AUTH_REQUIRED = lib.boolToString cfg.authRequired;
        WF_CORS_ALLOW_ORIGINS = cfg.corsAllowOrigins;
        WF_AUTH_TOKEN_TTL_MINUTES = toString cfg.authTokenTtlMinutes;
        WF_COOKIE_SECURE = cfg.cookieSecure;
        WF_REQUEST_TIMEOUT_MS = toString cfg.requestTimeoutMs;
        WF_LOG_FORMAT = cfg.logFormat;
      };

      script = ''
        ${lib.optionalString (
          cfg.secretKeyFile != null
        ) "export WF_SECRET_KEY=$(<\"$CREDENTIALS_DIRECTORY/secret_key\")"}
        ${lib.optionalString (
          cfg.authPasswordHashFile != null
        ) "export WF_AUTH_PASSWORD_HASH=$(<\"$CREDENTIALS_DIRECTORY/auth_hash\")"}

        exec ${lib.getExe cfg.package}
      '';

      serviceConfig = {
        LoadCredential =
          lib.optional (cfg.secretKeyFile != null) "secret_key:${cfg.secretKeyFile}"
          ++ lib.optional (cfg.authPasswordHashFile != null) "auth_hash:${cfg.authPasswordHashFile}";

        DynamicUser = true;
        StateDirectory = "wealthfolio";
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
      };
    };
  };

  meta = {
    maintainers = with lib.maintainers; [ luuumine ];
  };
}
