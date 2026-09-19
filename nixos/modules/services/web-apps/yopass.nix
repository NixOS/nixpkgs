{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.yopass;

  defaultUser = "yopass";
  defaultGroup = "yopass";

  toEnvValue =
    v:
    if lib.isBool v then
      lib.boolToString v
    else if lib.isAttrs v || lib.isList v then
      builtins.toJSON v
    else
      toString v;

  # Named options below map 1:1 onto yopass-server's env vars (see
  # upstream docs/server-options.md).
  namedEnv = {
    ADDRESS = cfg.address;
    PORT = toString cfg.port;
    LOG_LEVEL = cfg.logLevel;
    METRICS_PORT = if cfg.metricsPort == null then null else toString cfg.metricsPort;
    HEALTH_CHECK = lib.boolToString cfg.healthCheck;

    DATABASE = cfg.database.backend;
    MEMCACHED = if cfg.database.backend == "memcached" then cfg.database.memcached else null;
    REDIS = if cfg.database.backend == "redis" then cfg.database.redis else null;

    MAX_LENGTH = toString cfg.maxLength;
    DEFAULT_EXPIRY = cfg.defaultExpiry;
    FORCE_EXPIRATION = cfg.forceExpiration;
    FORCE_ONETIME_SECRETS = lib.boolToString cfg.forceOnetimeSecrets;
    PREFETCH_SECRET = lib.boolToString cfg.prefetchSecret;
    ARGON2 = lib.boolToString cfg.argon2;

    MAX_FILE_SIZE = cfg.fileStorage.maxFileSize;
    DISABLE_UPLOAD = lib.boolToString cfg.fileStorage.disableUpload;
    FILE_STORE = cfg.fileStorage.backend;
    FILE_STORE_PATH = if cfg.fileStorage.backend == "disk" then cfg.fileStorage.path else null;
    FILE_STORE_S3_BUCKET = cfg.fileStorage.s3.bucket;
    FILE_STORE_S3_PREFIX = cfg.fileStorage.s3.prefix;
    FILE_STORE_S3_ENDPOINT = cfg.fileStorage.s3.endpoint;
    FILE_STORE_S3_REGION = cfg.fileStorage.s3.region;
    CLEANUP_INTERVAL = toString cfg.fileStorage.cleanupInterval;
    DISABLE_FILE_CLEANUP = lib.boolToString cfg.fileStorage.disableCleanup;

    TLS_CERT = cfg.tls.cert;
    TLS_KEY = cfg.tls.key;

    CORS_ALLOW_ORIGIN = cfg.corsAllowOrigin;
    TRUSTED_PROXIES =
      if cfg.trustedProxies == [ ] then null else lib.concatStringsSep "," cfg.trustedProxies;

    READ_ONLY = lib.boolToString cfg.readOnly;
    DISABLE_FEATURES = lib.boolToString cfg.disableFeatures;
    NO_LANGUAGE_SWITCHER = lib.boolToString cfg.noLanguageSwitcher;
    PRIVACY_NOTICE_URL = cfg.privacyNoticeUrl;
    IMPRINT_URL = cfg.imprintUrl;
    PUBLIC_URL = cfg.publicUrl;
  };

  # `null` in namedEnv means "let yopass-server use its own default"
  # and is filtered out here rather than exported empty; settings has
  # no such convention since its freeform type excludes null.
  env = lib.filterAttrs (_: v: v != null) namedEnv // lib.mapAttrs (_: toEnvValue) cfg.settings;
in
{
  options.services.yopass = {
    enable = lib.mkEnableOption "Yopass, a secure way to share secrets and files";

    package = lib.mkPackageOption pkgs "yopass" { };

    user = lib.mkOption {
      type = lib.types.str;
      default = defaultUser;
      description = "User account under which yopass-server runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = defaultGroup;
      description = "Group under which yopass-server runs.";
    };

    address = lib.mkOption {
      type = lib.types.str;
      default = "0.0.0.0";
      description = "Listen address.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 1337;
      description = "Listen port.";
    };

    logLevel = lib.mkOption {
      type = lib.types.enum [
        "debug"
        "info"
        "warn"
        "error"
      ];
      default = "info";
      description = "Log level.";
    };

    metricsPort = lib.mkOption {
      type = lib.types.nullOr lib.types.port;
      default = null;
      description = ''
        Port for the Prometheus metrics server. Left unset (`null`)
        disables the metrics server, matching upstream's `-1` default.
      '';
    };

    healthCheck = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Check database connectivity and exit, rather than serving requests.";
    };

    database = {
      backend = lib.mkOption {
        type = lib.types.enum [
          "memcached"
          "redis"
        ];
        default = "memcached";
        description = "Storage backend for secrets.";
      };

      memcached = lib.mkOption {
        type = lib.types.str;
        default = "localhost:11211";
        description = "Memcached address (`host:port`), used when `database.backend` is `memcached`.";
      };

      redis = lib.mkOption {
        type = lib.types.str;
        default = "redis://localhost:6379/0";
        description = ''
          Redis connection URL, used when `database.backend` is `redis`.

          If this points at a local `services.redis.servers.<name>`,
          add `systemd.services.yopass.after = [ "redis-<name>.service" ];`
          yourself to avoid a startup race -- this module doesn't
          create or own the backend, so it can't infer that ordering.
        '';
      };
    };

    maxLength = lib.mkOption {
      type = lib.types.ints.positive;
      default = 10000;
      description = "Maximum encrypted secret size in bytes.";
    };

    defaultExpiry = lib.mkOption {
      type = lib.types.enum [
        "1h"
        "1d"
        "1w"
      ];
      default = "1h";
      description = "Default expiration pre-selected in the UI.";
    };

    forceExpiration = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "1h"
          "1d"
          "1w"
        ]
      );
      default = null;
      description = ''
        Force all secrets and file uploads to this fixed expiration.
        The server rejects any create request specifying a different
        value.
      '';
    };

    forceOnetimeSecrets = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Reject secrets that are not set to one-time viewing.";
    };

    prefetchSecret = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Show a warning that the secret may be one-time use before revealing it.";
    };

    argon2 = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Use Argon2id for password key derivation instead of iterated
        SHA-256. Loosens the Content-Security-Policy to allow
        WebAssembly compilation (`'wasm-unsafe-eval'`) — a reverse
        proxy that overrides the CSP header must add that keyword
        itself, or decryption breaks in the browser.
      '';
    };

    fileStorage = {
      maxFileSize = lib.mkOption {
        type = lib.types.str;
        default = "512KB";
        example = "10MB";
        description = ''
          Maximum file upload size. Capped at 1 MB without a license
          key regardless of this setting.
        '';
      };

      disableUpload = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Disable the `/create/file` upload endpoint entirely.";
      };

      backend = lib.mkOption {
        type = lib.types.nullOr (
          lib.types.enum [
            "disk"
            "s3"
          ]
        );
        default = null;
        description = ''
          File storage backend. Left unset (`null`) stores files in
          the same database backend used for text secrets.
        '';
      };

      path = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/yopass/files";
        description = "Base directory for the disk file store, used when `fileStorage.backend` is `disk`.";
      };

      s3 = {
        bucket = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "S3 bucket name. Required when `fileStorage.backend` is `s3`.";
        };

        prefix = lib.mkOption {
          type = lib.types.str;
          default = "yopass/";
          description = "Key prefix for objects stored in S3.";
        };

        endpoint = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          example = "http://minio:9000";
          description = "S3-compatible endpoint URL.";
        };

        region = lib.mkOption {
          type = lib.types.str;
          default = "us-east-1";
          description = "S3 region.";
        };
      };

      cleanupInterval = lib.mkOption {
        type = lib.types.ints.positive;
        default = 60;
        description = "How often (seconds) the built-in file cleanup runs.";
      };

      disableCleanup = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Disable the built-in cleanup goroutine, e.g. when relying on S3 lifecycle rules instead.";
      };
    };

    tls = {
      cert = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "Path to the TLS certificate file.";
      };

      key = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "Path to the TLS private key file.";
      };
    };

    corsAllowOrigin = lib.mkOption {
      type = lib.types.str;
      default = "*";
      description = "Value for the `Access-Control-Allow-Origin` response header.";
    };

    trustedProxies = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [
        "192.168.1.0/24"
        "10.0.0.0/8"
      ];
      description = "IP addresses or CIDR ranges whose `X-Forwarded-For` headers are trusted.";
    };

    readOnly = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Disable secret creation endpoints. Retrieval and deletion remain active.";
    };

    disableFeatures = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Hide the features section on the homepage.";
    };

    noLanguageSwitcher = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Hide the language switcher in the navigation bar.";
    };

    privacyNoticeUrl = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "URL linked from the privacy notice in the footer.";
    };

    imprintUrl = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "URL linked from the imprint / legal notice in the footer.";
    };

    publicUrl = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        Base URL of the public read-only instance. Secret links
        generated by the creation instance use this URL instead.
      '';
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/run/secrets/yopass";
      description = ''
        Path to a file in systemd `EnvironmentFile` format, for
        settings that shouldn't land in the Nix store: `API_TOKEN`,
        `WEBHOOK_SECRET`, `LICENSE_KEY`, `OIDC_CLIENT_SECRET`,
        `OIDC_SESSION_KEY`.
      '';
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType =
          with lib.types;
          attrsOf (
            let
              typeList = [
                bool
                float
                int
                str
                path
              ];
            in
            oneOf (typeList ++ [ (listOf (oneOf typeList)) ])
          );
      };
      default = { };
      description = ''
        Extra yopass-server settings, as environment variables. See
        [the upstream documentation](https://github.com/jhaals/yopass/blob/master/docs/server-options.md)
        for available flags — this option takes their env var form
        (e.g. `--oidc-issuer` is `OIDC_ISSUER`). Prefer the type-checked
        options above where one exists; use this for anything not yet
        modeled, including license-gated settings like OIDC and
        branding.
      '';
      example = {
        OIDC_ISSUER = "https://accounts.google.com";
        OIDC_ALLOWED_DOMAINS = "example.com";
        APP_NAME = "Secrets";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.yopass = {
      description = "Yopass - Share secrets securely";
      documentation = [ "https://github.com/jhaals/yopass" ];
      wantedBy = [ "multi-user.target" ];
      # memcached.service is always that exact unit name in nixpkgs, so
      # it's safe to order after unconditionally when used. redis has no
      # equivalent default here -- see database.redis's description.
      after = [
        "network.target"
      ]
      ++ lib.optional (cfg.database.backend == "memcached") "memcached.service";

      environment = env;

      serviceConfig = {
        ExecStart = lib.getExe' cfg.package "yopass-server";
        User = cfg.user;
        Group = cfg.group;
        Restart = "on-failure";
        EnvironmentFile = lib.optional (cfg.environmentFile != null) cfg.environmentFile;
        StateDirectory = "yopass";

        # Hardening
        CapabilityBoundingSet = "";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
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
          "~@privileged @setuid @keyring"
        ];
        UMask = "0077";
      };
    };

    users.users = lib.mkIf (cfg.user == defaultUser) {
      ${defaultUser} = {
        isSystemUser = true;
        group = cfg.group;
        home = "/var/lib/yopass";
      };
    };

    users.groups = lib.mkIf (cfg.group == defaultGroup) {
      ${defaultGroup} = { };
    };
  };
}
