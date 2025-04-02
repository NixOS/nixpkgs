{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.cloudflare-ddns;

  boolToString = b: if b then "true" else "false";
  formatList = l: concatStringsSep "," l;
  formatDuration = d: d.String;

in
{
  options.services.cloudflare-ddns = {
    enable = mkEnableOption (mdDoc "Cloudflare Dynamic DNS service");

    package = mkOption {
      type = types.package;
      default = pkgs.cloudflare-ddns;
      defaultText = literalExpression "pkgs.cloudflare-ddns";
      description = mdDoc "The cloudflare-ddns package to use.";
    };

    credentialsFile = mkOption {
      type = types.path;
      description = mdDoc ''
        Path to a file containing the Cloudflare API authentication token.
        The file content should be in the format `CLOUDFLARE_API_TOKEN=YOUR_SECRET_TOKEN`.
        The service user `${cfg.user}` needs read access to this file.
        Ensure permissions are secure (e.g., `0400` or `0440`) and ownership is appropriate
        (e.g., `owner = root`, `group = ${cfg.group}`).
        Using `CLOUDFLARE_API_TOKEN` is preferred over the deprecated `CF_API_TOKEN`.
      '';
      example = "/run/secrets/cloudflare-ddns-token";
    };

    domains = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = mdDoc ''
        List of domain names (FQDNs) to manage. Wildcards like `*.example.com` are supported.
        These domains will be managed for both IPv4 and IPv6 unless overridden by
        `ip4Domains` or `ip6Domains`, or if the respective providers are disabled.
        This corresponds to the `DOMAINS` environment variable.
      '';
      example = [
        "home.example.com"
        "*.dynamic.example.org"
      ];
    };

    ip4Domains = mkOption {
      type = types.nullOr (types.listOf types.str);
      default = null;
      description = mdDoc ''
        Explicit list of domains to manage only for IPv4. If set, overrides `domains` for IPv4.
        Corresponds to the `IP4_DOMAINS` environment variable.
      '';
      example = [ "ipv4.example.com" ];
    };

    ip6Domains = mkOption {
      type = types.nullOr (types.listOf types.str);
      default = null;
      description = mdDoc ''
        Explicit list of domains to manage only for IPv6. If set, overrides `domains` for IPv6.
        Corresponds to the `IP6_DOMAINS` environment variable.
      '';
      example = [ "ipv6.example.com" ];
    };

    wafLists = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = mdDoc ''
        List of WAF IP Lists to manage, in the format `account-id/list-name`.
        (Experimental feature as of cloudflare-ddns 1.14.0).
      '';
      example = [ "YOUR_ACCOUNT_ID/allowed_dynamic_ips" ];
    };

    provider = {
      ipv4 = mkOption {
        type = types.str;
        default = "cloudflare.trace";
        description = mdDoc ''
          IP detection provider for IPv4. Common values: `cloudflare.trace`, `cloudflare.doh`, `local`, `url:URL`, `none`.
          Use `none` to disable IPv4 updates.
          See cloudflare-ddns documentation for all options.
        '';
      };
      ipv6 = mkOption {
        type = types.str;
        default = "cloudflare.trace";
        description = mdDoc ''
          IP detection provider for IPv6. Common values: `cloudflare.trace`, `cloudflare.doh`, `local`, `url:URL`, `none`.
          Use `none` to disable IPv6 updates.
          See cloudflare-ddns documentation for all options.
        '';
      };
    };

    updateCron = mkOption {
      type = types.str;
      default = "@every 5m";
      description = mdDoc ''
        Cron expression for how often to check and update IPs.
        Use "@once" to run only once and then exit.
      '';
      example = "@hourly";
    };

    updateOnStart = mkOption {
      type = types.bool;
      default = true;
      description = mdDoc "Whether to perform an update check immediately on service start.";
    };

    deleteOnStop = mkOption {
      type = types.bool;
      default = false;
      description = mdDoc ''
        Whether to delete the managed DNS records and clear WAF lists when the service is stopped gracefully.
        Warning: Setting this to true with `updateCron = "@once"` will cause immediate deletion.
      '';
    };

    cacheExpiration = mkOption {
      type = types.str;
      default = "6h";
      description = mdDoc ''
        Duration for which API responses (like Zone ID, Record IDs) are cached.
        Uses Go's duration format (e.g., "6h", "1h30m").
      '';
    };

    ttl = mkOption {
      type = types.int;
      default = 1;
      description = mdDoc ''
        Time To Live (TTL) for the DNS records in seconds.
        Must be 1 (for automatic) or between 30 and 86400.
      '';
    };

    proxied = mkOption {
      type = types.str;
      default = "false";
      description = mdDoc ''
        Whether the managed DNS records should be proxied through Cloudflare ('orange cloud').
        Accepts boolean values (`true`, `false`) or a domain expression.
        See cloudflare-ddns documentation for expression syntax (e.g., "is(a.com) || sub(b.org)").
      '';
      example = "true";
    };

    recordComment = mkOption {
      type = types.str;
      default = "";
      description = mdDoc "Comment to add to managed DNS records.";
    };

    wafListDescription = mkOption {
      type = types.str;
      default = "";
      description = mdDoc "Description for managed WAF lists (used when creating or verifying lists).";
    };

    detectionTimeout = mkOption {
      type = types.str;
      default = "5s";
      description = mdDoc "Timeout for detecting the public IP address.";
    };

    updateTimeout = mkOption {
      type = types.str;
      default = "30s";
      description = mdDoc "Timeout for updating records via the Cloudflare API.";
    };

    healthchecks = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = mdDoc "URL for Healthchecks.io monitoring endpoint (optional).";
      example = "https://hc-ping.com/your-uuid";
    };

    uptimeKuma = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = mdDoc "URL for Uptime Kuma push monitor endpoint (optional).";
      example = "https://status.example.com/api/push/tag?status=up&msg=OK&ping=";
    };

    shoutrrr = mkOption {
      type = types.nullOr (types.listOf types.str);
      default = null;
      description = mdDoc "List of Shoutrrr notification service URLs (optional).";
      example = [
        "discord://token@id"
        "gotify://host/token"
      ];
    };

    user = mkOption {
      type = types.str;
      default = "cloudflare-ddns";
      description = mdDoc "User account under which the service runs.";
    };

    group = mkOption {
      type = types.str;
      default = "cloudflare-ddns";
      description = mdDoc "Group under which the service runs.";
    };

  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.ttl == 1 || (cfg.ttl >= 30 && cfg.ttl <= 86400);
        message = "services.cloudflare-ddns.ttl must be 1 or between 30 and 86400";
      }
      {
        assertion = cfg.updateCron == "@once" -> !cfg.deleteOnStop;
        message = "services.cloudflare-ddns.deleteOnStop cannot be true when updateCron is \"@once\"";
      }
      {
        assertion =
          cfg.domains != [ ] || cfg.ip4Domains != null || cfg.ip6Domains != null || cfg.wafLists != [ ];
        message = "services.cloudflare-ddns requires at least one domain (domains, ip4Domains, ip6Domains) or WAF list (wafLists) to be specified";
      }
      {
        assertion = cfg.provider.ipv4 != "none" || cfg.provider.ipv6 != "none";
        message = "services.cloudflare-ddns requires at least one provider (ipv4 or ipv6) to be enabled (not 'none')";
      }
    ];

    users.users.${cfg.user} = {
      description = "Cloudflare DDNS service user";
      isSystemUser = true;
      group = cfg.group;
      home = "/var/lib/${cfg.user}";
    };
    users.groups.${cfg.group} = { };

    systemd.tmpfiles.rules = [
      "d /var/lib/${cfg.user} 0750 ${cfg.user} ${cfg.group} - -"
    ];

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
              optionalString pred (toEnv name value);
            toEnvMaybeList =
              pred: name: value:
              optionalString pred (toEnvList name value);
          in
          lib.filter (envVar: envVar != "") [
            (toEnvList "DOMAINS" cfg.domains)
            (toEnvMaybeList (cfg.ip4Domains != null) "IP4_DOMAINS" cfg.ip4Domains)
            (toEnvMaybeList (cfg.ip6Domains != null) "IP6_DOMAINS" cfg.ip6Domains)

            (toEnv "IP4_PROVIDER" cfg.provider.ipv4)
            (toEnv "IP6_PROVIDER" cfg.provider.ipv6)

            (toEnvMaybeList (cfg.wafLists != [ ]) "WAF_LISTS" cfg.wafLists)
            (toEnvMaybe (cfg.wafListDescription != "") "WAF_LIST_DESCRIPTION" cfg.wafListDescription)

            (toEnv "UPDATE_CRON" cfg.updateCron)
            (toEnvBool "UPDATE_ON_START" cfg.updateOnStart)
            (toEnvBool "DELETE_ON_STOP" cfg.deleteOnStop)
            (toEnv "CACHE_EXPIRATION" cfg.cacheExpiration)

            (toEnv "TTL" cfg.ttl)
            (toEnv "PROXIED" cfg.proxied)
            (toEnvMaybe (cfg.recordComment != "") "RECORD_COMMENT" cfg.recordComment)

            (toEnv "DETECTION_TIMEOUT" cfg.detectionTimeout)
            (toEnv "UPDATE_TIMEOUT" cfg.updateTimeout)

            (toEnvMaybe (cfg.healthchecks != null) "HEALTHCHECKS" cfg.healthchecks)
            (toEnvMaybe (cfg.uptimeKuma != null) "UPTIMEKUMA" cfg.uptimeKuma)
            (toEnvMaybeList (cfg.shoutrrr != null) "SHOUTRRR" (concatStringsSep "\n" cfg.shoutrrr))
          ];

        ExecStart = "${cfg.package}/bin/ddns";

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
        ];
      };
    };
  };
}
