{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.porxie;
in
{
  options.services.porxie = {
    enable = lib.mkEnableOption "Porxie, an ATProto blob proxy for secure content delivery";

    package = lib.mkPackageOption pkgs "porxie" { };

    environmentFiles = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [ ];
      description = ''
        Files to load environment variables from. Use for secrets such as
        {env}`PORXIE_SERVER_AUTH_TOKEN` and {env}`PORXIE_POLICY_REQUEST_HEADERS`.
      '';
    };

    settings = lib.mkOption {
      default = { };
      description = ''
        Configuration for Porxie as environment variables. See the
        [README](https://codeberg.org/Blooym/porxie/src/branch/main/README.md)
        for detailed information about application configuration.

        Secrets such as {option}`settings.PORXIE_SERVER_AUTH_TOKEN` should be set via
        {option}`environmentFiles` rather than here, as values set here will
        be readable in the Nix store.
      '';
      type = lib.types.submodule {
        freeformType = lib.types.attrsOf (
          lib.types.nullOr (
            lib.types.oneOf [
              lib.types.str
              lib.types.bool
              lib.types.int
            ]
          )
        );

        options = {
          # Server.
          PORXIE_SERVER_ADDRESS = lib.mkOption {
            type = lib.types.str;
            default = "ip:127.0.0.1:6314";
            description = ''
              Address to bind the server to.

              Use the `ip:` prefix for an IP address (e.g. `ip:127.0.0.1:6314`), or on UNIX
              systems, the `unix:` prefix for a UNIX socket path (e.g. `unix:/run/porxie/porxie.sock`).
            '';
          };
          PORXIE_SERVER_AUTH_TOKEN = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = ''
              Bearer token for authenticating admin requests.

              When unset, all authenticated endpoints will reject requests with HTTP 401.

              Should be set via {option}`environmentFiles` rather than directly.
            '';
          };

          # Blobs.
          PORXIE_BLOB_ALLOWED_MIMETYPES = lib.mkOption {
            type = lib.types.nullOr (lib.types.listOf lib.types.str);
            default = null;
            apply = v: if v != null then lib.concatStringsSep "," v else null;
            description = ''
              Blob MIME types that can be served.

              Validation is done loosely via content inference. Further validation can be done by
              a layer above this proxy, such as an image transformation service. When inference
              fails, the blob's type falls back to `application/octet-stream`. When that type is
              allowed, blobs failing inference can still be served.
            '';
          };
          PORXIE_BLOB_MAX_SIZE = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = ''
              Maximum blob size that can be fetched and served.

              Blobs that exceed this limit will return HTTP 413. Setting this too high can
              exhaust process or system memory. The minimum value is 512kb and the maximum is
              the system's total memory.
            '';
          };
          PORXIE_BLOB_CACHE_HEADER = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = ''
              The `Cache-Control` header value to send alongside blob responses.

              This does not affect internal cache lifetimes, only how downstream clients such as
              CDNs and browsers are instructed to cache responses. Intermediary caches may need
              to be cleared manually for changes to take effect quickly.
            '';
          };
          PORXIE_BLOB_PROCESSING_TIMEOUT = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "Maximum duration a blob can be processed by this server before aborting.";
          };
          PORXIE_BLOB_HTTP_TIMEOUT = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "Maximum duration before blob fetch requests are timed out.";
          };
          PORXIE_BLOB_HTTP_CONNECT_TIMEOUT = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = ''
              Maximum duration before an attempted connection to a blob upstream is aborted.

              This value should be lower than {option}`settings.PORXIE_BLOB_HTTP_TIMEOUT`.
            '';
          };

          # Identity.
          PORXIE_IDENTITY_PLC_URL = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = ''
              URL of the PLC instance used for `did:plc` lookups.

              Can typically be left as default unless using a custom or local development setup.
            '';
          };
          PORXIE_IDENTITY_HTTP_TIMEOUT = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "Maximum duration before identity resolution requests are timed out.";
          };
          PORXIE_IDENTITY_HTTP_CONNECT_TIMEOUT = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = ''
              Maximum duration before a connection attempt to an identity upstream is aborted.

              This value should be lower than {option}`settings.PORXIE_IDENTITY_HTTP_TIMEOUT`.
            '';
          };

          # Cache.
          PORXIE_CACHE_ALLOCATION = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = ''
              Total memory allocation for the internal cache.

              Blobs are cached using an LFU policy. The most frequently requested blobs are kept
              longest when the cache approaches its limit.

              For production deployments, a CDN or caching layer in front of this server is
              recommended for lower latency and better global availability.

              Setting this too high can exhaust process or system memory. The minimum value is
              8mb and the maximum is the system's total memory.
            '';
          };
          PORXIE_CACHE_BLOB_TTI = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "How long blobs can be idle in the cache before expiring.";
          };
          PORXIE_CACHE_OWNERSHIP_TTL = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "How long blob ownership can be cached before expiring.";
          };
          PORXIE_CACHE_POLICY_TTL = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "How long policy decisions can be cached before expiring.";
          };
          PORXIE_CACHE_IDENTITY_TTL = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "How long identity lookups (DID resolution, etc.) can be cached before expiring.";
          };

          # Policy.
          PORXIE_POLICY_URL = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = ''
              Policy service URL that DID+CID pairs will be checked against.

              Requests are sent as HTTP GET `<url>/<did>/<cid>`. The service is expected to
              return HTTP 200 (OK) if permitted or HTTP 410 (GONE) if restricted.
            '';
          };
          PORXIE_POLICY_REQUEST_HEADERS = lib.mkOption {
            type = lib.types.nullOr (lib.types.listOf lib.types.str);
            default = null;
            apply = v: if v != null then lib.concatStringsSep "|" v else null;
            description = ''
              Headers sent alongside all requests to the policy service.
              Each header must be in the format `Name: value`.

              Should be set via {option}`environmentFiles` for sensitive values such as API keys.
            '';
          };
          PORXIE_POLICY_FAIL_OPEN = lib.mkOption {
            type = lib.types.nullOr lib.types.bool;
            default = null;
            apply = v: if v != null then lib.boolToString v else null;
            description = ''
              Allow requests to proceed if the policy service is unavailable or returns an
              unexpected status code.

              Warning: enabling this means restricted blobs may be served when the policy
              service is unreachable.
            '';
          };
          PORXIE_POLICY_HTTP_TIMEOUT = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "Maximum duration before policy service requests are timed out.";
          };
          PORXIE_POLICY_HTTP_CONNECT_TIMEOUT = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = ''
              Maximum duration before an attempted connection to the policy service is aborted.

              This value should be lower than {option}`settings.PORXIE_POLICY_HTTP_TIMEOUT`.
            '';
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion =
          (cfg.settings.PORXIE_POLICY_REQUEST_HEADERS != null || cfg.settings.PORXIE_POLICY_FAIL_OPEN != null)
          -> cfg.settings.PORXIE_POLICY_URL != null;
        message = "services.porxie: PORXIE_POLICY_URL must be set when using any other policy options";
      }
    ];

    systemd.services.porxie = {
      description = "Porxie - ATProto blob proxy";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        User = "porxie";
        DynamicUser = true;

        ExecStart = lib.getExe cfg.package;
        Environment = lib.mapAttrsToList (k: v: "${k}=${lib.escapeShellArg (toString v)}") (
          lib.filterAttrs (_: v: v != null) cfg.settings
        );
        EnvironmentFile = cfg.environmentFiles;
        Restart = "on-failure";
        RestartSec = 5;
        RuntimeDirectory = "porxie";
        RuntimeDirectoryMode = "0750";

        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProcSubset = "all";
        ProtectSystem = "strict";

        PrivateDevices = true;
        PrivateTmp = true;
        PrivateUsers = true;

        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];

        MemoryDenyWriteExecute = true;
        LockPersonality = true;
        NoNewPrivileges = true;
        AmbientCapabilities = "";
        RemoveIPC = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "~@resources"
        ];
        UMask = "0077";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ blooym ];
}
