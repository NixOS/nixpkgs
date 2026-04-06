{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.cloudflare-ddns;

  boolToString = b: if b then "true" else "false";
  formatList = l: lib.concatStringsSep "," l;
  formatDuration = d: d.String;
in
{
  options.services.cloudflare-ddns = {
    enable = lib.mkEnableOption "Cloudflare Dynamic DNS service";

    package = lib.mkPackageOption pkgs "cloudflare-ddns" { };

    credentialsFile = lib.mkOption {
      type = lib.types.path;
      description = ''
        Path to a file containing the Cloudflare API authentication token.
        The file content should be in the format `CLOUDFLARE_API_TOKEN=YOUR_SECRET_TOKEN`.
        The service user needs read access to this file.
        Ensure permissions are secure (e.g., `0400` or `0440`) and ownership is appropriate.
        Using `CLOUDFLARE_API_TOKEN` is preferred over the deprecated `CF_API_TOKEN`.
      '';
      example = "/run/secrets/cloudflare-ddns-token";
    };

    domains = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = ''
        List of domain names (FQDNs) to manage for both IPv4 (`A`) and IPv6 (`AAAA`) records.
        Wildcards like `*.example.com` are supported.
        These are combined with (not overridden by) `ip4Domains` and `ip6Domains`.
        This corresponds to the `DOMAINS` environment variable.
      '';
      example = [
        "home.example.com"
        "*.dynamic.example.org"
      ];
    };

    ip4Domains = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = ''
        Additional list of domains to manage only for IPv4 (`A` records).
        These are combined with domains listed in `domains`.
        Corresponds to the `IP4_DOMAINS` environment variable.
      '';
      example = [ "ipv4.example.com" ];
    };

    ip6Domains = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = ''
        Additional list of domains to manage only for IPv6 (`AAAA` records).
        These are combined with domains listed in `domains`.
        Corresponds to the `IP6_DOMAINS` environment variable.
      '';
      example = [ "ipv6.example.com" ];
    };

    managedRecordsCommentRegex = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = ''
        Regex that selects which DNS records this updater manages by their comments.
        Matched records are updated or deleted as needed; new records are created with comments that match.
        Uses RE2 syntax (the Go `regexp` syntax, not Perl/PCRE).
        When empty, the updater manages all DNS records for the configured domains.
        Corresponds to the `MANAGED_RECORDS_COMMENT_REGEX` environment variable.
      '';
      example = "^managed-by-ddns$";
    };

    wafLists = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = ''
        List of WAF IP Lists to manage, in the format `account-id/list-name`.
        (Experimental feature as of cloudflare-ddns 1.14.0).
      '';
      example = [ "YOUR_ACCOUNT_ID/allowed_dynamic_ips" ];
    };

    managedWafListItemsCommentRegex = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = ''
        Regex that selects which WAF list items this updater manages by their comments.
        Matched items are updated or deleted as needed, and new items are created with comments that match.
        This lets multiple updater instances share one WAF list safely.
        Uses RE2 syntax (the Go `regexp` syntax, not Perl/PCRE).
        When empty, the updater manages all WAF list items.
        Corresponds to the `MANAGED_WAF_LIST_ITEMS_COMMENT_REGEX` environment variable.
      '';
      example = "^managed-by-ddns$";
    };

    provider = {
      ipv4 = lib.mkOption {
        type = lib.types.str;
        default = "cloudflare.trace";
        description = ''
          IP detection provider for IPv4. Common values: `cloudflare.trace`, `local`, `url:URL`, `none`.
          Use `none` to disable IPv4 updates; use `static.empty` to clear managed IPv4 content.
          See cloudflare-ddns documentation for all options.
        '';
      };
      ipv6 = lib.mkOption {
        type = lib.types.str;
        default = "cloudflare.trace";
        description = ''
          IP detection provider for IPv6. Common values: `cloudflare.trace`, `local`, `url:URL`, `none`.
          Use `none` to disable IPv6 updates; use `static.empty` to clear managed IPv6 content.
          See cloudflare-ddns documentation for all options.
        '';
      };
    };

    ip4DefaultPrefixLen = lib.mkOption {
      type = lib.types.ints.positive;
      default = 32;
      description = ''
        Default CIDR prefix length for detected bare IPv4 addresses.
        WAF lists use this to determine the stored range (e.g., 24 stores each detection as a /24 range).
        Valid range: 8–32.
        Corresponds to the `IP4_DEFAULT_PREFIX_LEN` environment variable.
        (Experimental feature as of cloudflare-ddns 1.16.0).
      '';
    };

    ip6DefaultPrefixLen = lib.mkOption {
      type = lib.types.ints.positive;
      default = 64;
      description = ''
        Default CIDR prefix length for detected bare IPv6 addresses.
        WAF lists use this to determine the stored range (e.g., 48 stores each detection as a /48 range).
        Valid range: 12–128.
        Corresponds to the `IP6_DEFAULT_PREFIX_LEN` environment variable.
        (Experimental feature as of cloudflare-ddns 1.16.0).
      '';
    };

    updateCron = lib.mkOption {
      type = lib.types.str;
      default = "@every 5m";
      description = ''
        Cron expression for how often to check and update IPs.
        Use "@once" to run only once and then exit.
      '';
      example = "@hourly";
    };

    tz = lib.mkOption {
      type = lib.types.str;
      default = "UTC";
      description = ''
        Timezone used for logging messages and parsing `updateCron`.
        Accepts any IANA Time Zone name.
        Corresponds to the `TZ` environment variable.
      '';
      example = "Asia/Kathmandu";
    };

    updateOnStart = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to perform an update check immediately on service start.";
    };

    deleteOnStop = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to delete managed DNS records and managed WAF content when the service is stopped gracefully.
      '';
    };

    cacheExpiration = lib.mkOption {
      type = lib.types.str;
      default = "6h";
      description = ''
        Duration for which API responses (like Zone ID, Record IDs) are cached.
        Uses Go's duration format (e.g., "6h", "1h30m").
      '';
    };

    ttl = lib.mkOption {
      type = lib.types.ints.positive;
      default = 1;
      description = ''
        Fallback TTL (in seconds) for DNS records managed by the updater.
        The updater preserves existing TTL values when possible.
        Must be 1 (for automatic) or between 30 and 86400.
      '';
    };

    proxied = lib.mkOption {
      type = lib.types.str;
      default = "false";
      description = ''
        Fallback proxy setting for DNS records managed by the updater.
        The updater preserves existing proxy statuses when possible.
        Accepts boolean values (`true`, `false`) or a domain expression.
        See cloudflare-ddns documentation for expression syntax (e.g., "is(a.com) || sub(b.org)").
      '';
      example = "true";
    };

    recordComment = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Fallback comment for DNS records managed by the updater.";
    };

    wafListDescription = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = ''
        Fallback description for WAF lists managed by the updater.
        Only matters when the updater creates a new WAF list.
      '';
    };

    wafListItemComment = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Fallback comment for WAF list items managed by the updater.";
    };

    detectionTimeout = lib.mkOption {
      type = lib.types.str;
      default = "5s";
      description = "Timeout for detecting the public IP address.";
    };

    updateTimeout = lib.mkOption {
      type = lib.types.str;
      default = "30s";
      description = "Timeout for updating records via the Cloudflare API.";
    };

    logging = {
      quiet = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to reduce logging output.";
      };
      emoji = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to use emojis in logging output.";
      };
    };

    healthchecks = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "URL for Healthchecks.io monitoring endpoint (optional).";
      example = "https://hc-ping.com/your-uuid";
    };

    uptimeKuma = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "URL for Uptime Kuma push monitor endpoint (optional).";
      example = "https://status.example.com/api/push/tag?status=up&msg=OK&ping=";
    };

    shoutrrr = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of Shoutrrr notification service URLs (optional).";
      example = [
        "discord://token@id"
        "gotify://host/token"
      ];
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "cloudflare-ddns";
      description = "User account under which the service runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "cloudflare-ddns";
      description = "Group under which the service runs.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion =
          cfg.domains != [ ] || cfg.ip4Domains != [ ] || cfg.ip6Domains != [ ] || cfg.wafLists != [ ];
        message = "services.cloudflare-ddns requires at least one domain (domains, ip4Domains, ip6Domains) or WAF list (wafLists) to be specified";
      }
      {
        assertion = cfg.updateCron == "@once" -> cfg.updateOnStart;
        message = "services.cloudflare-ddns.updateOnStart must be true when updateCron is \"@once\", otherwise nothing will happen";
      }
      {
        assertion =
          let
            ip4Off = cfg.provider.ipv4 == "static.empty" || cfg.provider.ipv4 == "none";
            ip6Off = cfg.provider.ipv6 == "static.empty" || cfg.provider.ipv6 == "none";
          in
          cfg.updateCron == "@once" && cfg.deleteOnStop -> ip4Off && ip6Off;
        message = "services.cloudflare-ddns.deleteOnStop cannot be true when updateCron is \"@once\" unless each provider is either 'none' or 'static.empty'";
      }
      {
        assertion =
          let
            ip4Managed =
              cfg.provider.ipv4 != "none" && (cfg.domains != [ ] || cfg.ip4Domains != [ ] || cfg.wafLists != [ ]);
            ip6Managed =
              cfg.provider.ipv6 != "none" && (cfg.domains != [ ] || cfg.ip6Domains != [ ] || cfg.wafLists != [ ]);
          in
          ip4Managed || ip6Managed;
        message = "services.cloudflare-ddns requires at least one provider (ipv4 or ipv6) to be enabled (not 'none') and actively used";
      }
      {
        assertion = cfg.ip4DefaultPrefixLen >= 8 && cfg.ip4DefaultPrefixLen <= 32;
        message = "services.cloudflare-ddns.ip4DefaultPrefixLen must be between 8 and 32";
      }
      {
        assertion = cfg.ip6DefaultPrefixLen >= 12 && cfg.ip6DefaultPrefixLen <= 128;
        message = "services.cloudflare-ddns.ip6DefaultPrefixLen must be between 12 and 128";
      }
      {
        assertion = cfg.ttl == 1 || (cfg.ttl >= 30 && cfg.ttl <= 86400);
        message = "services.cloudflare-ddns.ttl must be 1 or between 30 and 86400";
      }
    ];

    users.users.${cfg.user} = {
      description = "Cloudflare DDNS service user";
      isSystemUser = true;
      group = cfg.group;
      home = "/var/lib/${cfg.user}";
    };

    users.groups.${cfg.group} = { };

    systemd.tmpfiles.settings."cloudflare-ddns" = {
      "/var/lib/${cfg.user}".d = {
        mode = "0750";
        user = cfg.user;
        group = cfg.group;
      };
    };

    systemd.services.cloudflare-ddns = {
      description = "Cloudflare Dynamic DNS Client Service (favonia)";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;

        WorkingDirectory = "/var/lib/${cfg.user}";

        EnvironmentFile = cfg.credentialsFile;

        Environment =
          let
            toEnv = name: value: "${name}=\"${toString value}\"";
            toEnvList = name: value: "${name}=\"${formatList value}\"";
            toEnvDuration = name: value: "${name}=\"${formatDuration value}\"";
            toEnvBool = name: value: "${name}=\"${boolToString value}\"";
            toEnvMaybe =
              pred: name: value:
              lib.optionalString pred (toEnv name value);
            toEnvMaybeList =
              pred: name: value:
              lib.optionalString pred (toEnvList name value);
          in
          lib.filter (envVar: envVar != "") [
            (toEnvMaybeList (cfg.domains != [ ]) "DOMAINS" cfg.domains)
            (toEnvMaybeList (cfg.ip4Domains != [ ]) "IP4_DOMAINS" cfg.ip4Domains)
            (toEnvMaybeList (cfg.ip6Domains != [ ]) "IP6_DOMAINS" cfg.ip6Domains)
            (toEnvMaybe (
              cfg.managedRecordsCommentRegex != ""
            ) "MANAGED_RECORDS_COMMENT_REGEX" cfg.managedRecordsCommentRegex)

            (toEnvMaybeList (cfg.wafLists != [ ]) "WAF_LISTS" cfg.wafLists)
            (toEnvMaybe (
              cfg.managedWafListItemsCommentRegex != ""
            ) "MANAGED_WAF_LIST_ITEMS_COMMENT_REGEX" cfg.managedWafListItemsCommentRegex)

            (toEnvMaybe (cfg.provider.ipv4 != "") "IP4_PROVIDER" cfg.provider.ipv4)
            (toEnvMaybe (cfg.provider.ipv6 != "") "IP6_PROVIDER" cfg.provider.ipv6)
            (toEnv "IP4_DEFAULT_PREFIX_LEN" cfg.ip4DefaultPrefixLen)
            (toEnv "IP6_DEFAULT_PREFIX_LEN" cfg.ip6DefaultPrefixLen)

            (toEnvMaybe (cfg.updateCron != "") "UPDATE_CRON" cfg.updateCron)
            (toEnvMaybe (cfg.tz != "") "TZ" cfg.tz)
            (toEnvBool "UPDATE_ON_START" cfg.updateOnStart)
            (toEnvBool "DELETE_ON_STOP" cfg.deleteOnStop)
            (toEnvMaybe (cfg.cacheExpiration != "") "CACHE_EXPIRATION" cfg.cacheExpiration)

            (toEnv "TTL" cfg.ttl)
            (toEnvMaybe (cfg.proxied != "") "PROXIED" cfg.proxied)
            (toEnvMaybe (cfg.recordComment != "") "RECORD_COMMENT" cfg.recordComment)
            (toEnvMaybe (cfg.wafListDescription != "") "WAF_LIST_DESCRIPTION" cfg.wafListDescription)
            (toEnvMaybe (cfg.wafListItemComment != "") "WAF_LIST_ITEM_COMMENT" cfg.wafListItemComment)

            (toEnvMaybe (cfg.detectionTimeout != "") "DETECTION_TIMEOUT" cfg.detectionTimeout)
            (toEnvMaybe (cfg.updateTimeout != "") "UPDATE_TIMEOUT" cfg.updateTimeout)

            (toEnvBool "QUIET" cfg.logging.quiet)
            (toEnvBool "EMOJI" cfg.logging.emoji)

            (toEnvMaybe (cfg.healthchecks != "") "HEALTHCHECKS" cfg.healthchecks)
            (toEnvMaybe (cfg.uptimeKuma != "") "UPTIMEKUMA" cfg.uptimeKuma)
            (toEnvMaybe (cfg.shoutrrr != [ ]) "SHOUTRRR" (lib.concatStringsSep "\n" cfg.shoutrrr))
          ];

        ExecStart = lib.getExe cfg.package;

        Restart = "on-failure";
        RestartSec = "30s";

        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        NoNewPrivileges = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_NETLINK"
        ];
      };
    };
  };
  meta.maintainers = with lib.maintainers; [
    shokerplz
  ];
}
