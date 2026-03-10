{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    concatStringsSep
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    mkPackageOption
    types
    ;
  cfg = config.services.crowdsec-blocklist-import;

  # Source: https://github.com/wolffcatskyy/crowdsec-blocklist-import/blob/main/import.sh#L127C24-L164C3
  feedGroupsNames = [
    "IPsum"
    "Spamhaus"
    "Blocklist.de"
    "Firehol"
    "Abuse.ch"
    "Emerging Threats"
    "Binary Defense"
    "Bruteforce Blocker"
    "DShield"
    "CI Army"
    "Botvrij"
    "GreenSnow"
    "StopForumSpam"
    "Tor"
    "Scanners"
    "Abuse IPDB"
    "Cybercrime Tracker"
    "Monty Security C2"
    "VXVault"
    "Sentinel"
  ];

  toEnvVarName =
    f: lib.strings.replaceStrings [ " " "." "(" ")" ] [ "_" "_" "" "" ] (lib.strings.toUpper f);
in
{
  options.services.crowdsec-blocklist-import = {
    enable = mkEnableOption "CrowdSec blocklist import service";

    package = mkPackageOption pkgs "crowdsec-blocklist-import" { };

    crowdsecLapiUrl = mkOption {
      type = types.str;
      default = "http://localhost:8080";
      description = "URL of the CrowdSec local API";
    };

    crowdsecLapiKey = mkOption {
      type = types.str;
      default = "";
      description = "CrowdSec local API key";
    };

    crowdsecLapiKeyFile = mkOption {
      type = types.str;
      default = "";
      description = "CrowdSec local API key file path";
    };

    crowdsecMachineId = mkOption {
      type = types.str;
      default = "";
      description = "CrowdSec machine ID";
    };

    crowdsecMachinePassword = mkOption {
      type = types.str;
      default = "";
      description = "CrowdSec machine password";
    };

    crowdsecMachinePasswordFile = mkOption {
      type = types.str;
      default = "";
      example = "/var/lib/crowdsec/local_api_credentials.yaml";
      description = "CrowdSec machine password file path";
    };

    decisionDuration = mkOption {
      type = types.str;
      default = "24h";
      description = ''
        How long decisions last.
        Examples: "24h", "12h", "48h"
      '';
    };

    fetchTimeout = mkOption {
      type = types.int;
      default = 60;
      description = "Timeout in seconds for fetching blocklists (increase for slow connections)";
    };

    logLevel = mkOption {
      type = types.enum [
        "DEBUG"
        "INFO"
        "WARN"
        "ERROR"
      ];
      default = "INFO";
      description = "Logging verbosity";
    };

    telemetryEnabled = mkOption {
      type = types.bool;
      default = false;
      description = "Send anonymous usage statistics to upstream";
    };

    dryRun = mkOption {
      type = types.bool;
      default = false;
      description = "Preview mode - shows what would be imported without making changes";
    };

    disabledSources = mkOption {
      type = types.listOf (types.enum feedGroupsNames);
      default = [ ];
      description = ''
        Which threat feeds to disable. Available feeds:
        ${concatStringsSep "\n\t" feedGroupsNames}
      '';
      example = [
        "Spamhaus DROP"
        "Firehol level1"
        "Emerging Threats"
      ];
    };

    customBlockLists = mkOption {
      type = types.listOf (types.str);
      default = [ ];
      description = "Import your own threat feed URLs";
      example = [
        "https://example.com/list1.txt"
        "https://example.com/list2.txt"
      ];
    };

    allowList = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Inline allow-list as comma-separated values (e.g. \"1.1.1.1,8.8.8.8,192.168.1.0/24\")";
    };

    allowListGithub = mkEnableOption "allow all github IPs";

    consolidateAlerts = mkOption {
      type = types.bool;
      default = false;
      description = "Combine all IPs into a single CrowdSec alert per run";
    };

    metrics = {
      enable = mkEnableOption "Prometheus metrics";

      pushGatewayUrl = mkOption {
        type = types.str;
        default = "localhost:9091";
        description = "Push URL for Prometheus metrics endpoint (default: localhost:9091)";
      };
    };

    webhookUrl = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Webhook URL for notifications (Discord/Slack/generic)";
    };

    webhookType = mkOption {
      type = types.enum [
        "generic"
        "discord"
        "slack"
      ];
      default = "generic";
      description = "Webhook format: generic, discord, slack (default: generic)";
    };

    abuseIpDbKey = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "AbuseIPDB API key, for direct blacklist queries";
    };

    abuseIpDbKeyFile = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "AbuseIPDB API key file path, for direct blacklist queries";
    };

    abuseIpDbMinConfidence = mkOption {
      type = types.int;
      default = 90;
      description = "WebMinimum confidence score 1-100 (default: 90)";
    };

    schedule = mkOption {
      type = types.str;
      default = "*-*-* 04:00:00";
      description = ''
        When to run the import of non-rate limited sources (systemd calendar syntax). See {manpage}`systemd.time(7)` for the format.
        Examples:
        - "*-*-* *:00:00" (every hour)
        - "*-*-* 04:00:00"  (daily at 4 AM)
        - "*-*-* 04,16:00:00"  (twice daily)
        - "Mon *-*-* 04:00:00"  (weekly)
      '';
    };

    scheduleRateLimited = mkOption {
      type = types.str;
      default = "*-*-* 00,05,10,15,20:00:00"; # 5x/day, every ~5 hours
      description = ''
        When to run the import of rate limited sources (systemd calendar syntax). See {manpage}`systemd.time(7)` for the format.
        Examples:
        - "*-*-* 00,05,10,15,20:00:00"  (5x/day, every ~5 hours)
        - "*-*-* *:00:00"  (every hour)
        - "*-*-* 04:00:00"  (daily at 4 AM)
        - "*-*-* 04,16:00:00"  (twice daily)
        - "Mon *-*-* 04:00:00"  (weekly)
      '';
    };

    refreshPeriodFrequentMn = mkOption {
      type = types.int;
      default = 60;
      description = "Refresh IPs expiring under this delay";
    };

    refreshPeriodLimitedMn = mkOption {
      type = types.int;
      default = 300;
      description = "Refresh IPs expiring under this delay";
    };

    randomizedDelay = mkOption {
      type = types.str;
      default = "15min";
      description = "Random delay before starting to prevent thundering herd effect.";
    };

    runAt = mkOption {
      type = types.enum [
        "timer"
        "manual"
      ];
      default = "timer";
      description = ''
        When to run the service:
        - timer: Use systemd timer with schedule option, also run at boot
        - manual: Never auto-run, use 'systemctl start' manually
      '';
    };
  };

  config =
    let
      apiKeyFile =
        if config.services.crowdsec-firewall-bouncer.registerBouncer.enable then
          "/var/lib/crowdsec-firewall-bouncer-register/api-key.cred"
        else
          config.services.crowdsec-firewall-bouncer.secrets.apiKeyPath;

      mkScript = arg: {
        description = "Import threat intelligence blocklists into CrowdSec (${arg})";
        documentation = [ "https://github.com/wolffcatskyy/crowdsec-blocklist-import" ];

        wantedBy = mkIf (cfg.runAt == "timer") [ "multi-user.target" ];
        after = mkIf (cfg.runAt == "timer") [
          "crowdsec.service"
          "crowdsec-firewall-bouncer.service"
        ];
        wants = mkIf (cfg.runAt == "timer") [
          "crowdsec.service"
          "crowdsec-firewall-bouncer.service"
        ];

        script = "${lib.getExe cfg.package} --mode ${arg}";

        environment = mkMerge [
          {
            ABUSEIPDB_API_KEY = cfg.abuseIpDbKey;
            ABUSEIPDB_API_KEY_FILE = cfg.abuseIpDbKeyFile;
            ABUSEIPDB_MIN_CONFIDENCE = toString cfg.abuseIpDbMinConfidence;
            ALLOWLIST = lib.concatStringsSep "," cfg.allowList;
            ALLOWLIST_GITHUB = if cfg.allowListGithub then "true" else "false";
            CONSOLIDATE_ALERTS = if cfg.consolidateAlerts then "true" else "false";
            CROWDSEC_LAPI_KEY = cfg.crowdsecLapiKey;
            CROWDSEC_LAPI_KEY_FILE = cfg.crowdsecLapiKeyFile;
            CROWDSEC_LAPI_URL = cfg.crowdsecLapiUrl;
            CROWDSEC_MACHINE_ID = cfg.crowdsecMachineId;
            CROWDSEC_MACHINE_PASSWORD = cfg.crowdsecMachinePassword;
            CROWDSEC_MACHINE_PASSWORD_FILE = cfg.crowdsecMachinePasswordFile;
            CUSTOM_BLOCKLISTS = lib.concatStringsSep "," cfg.customBlockLists;
            DECISION_DURATION = cfg.decisionDuration;
            DRY_RUN = if cfg.dryRun then "true" else "false";
            FETCH_TIMEOUT = toString cfg.fetchTimeout;
            LOG_LEVEL = cfg.logLevel;
            LOG_TIMESTAMPS = "false";
            METRICS_ENABLED = if cfg.metrics.enable then "true" else "false";
            METRICS_PUSHGATEWAY_URL = cfg.metrics.pushGatewayUrl;
            REFRESH_PERIOD_FREQUENT_MN = toString cfg.refreshPeriodFrequentMn;
            REFRESH_PERIOD_LIMITED_MN = toString cfg.refreshPeriodLimitedMn;
            TELEMETRY_ENABLED = if cfg.telemetryEnabled then "true" else "false";
            WEBHOOK_TYPE = cfg.webhookType;
            WEBHOOK_URL = cfg.webhookUrl;
          }
          (lib.listToAttrs (
            lib.map (source: {
              name = "ENABLE_${toEnvVarName source}";
              value = "false";
            }) cfg.disabledSources
          ))
        ];

        serviceConfig = {
          Type = "oneshot";

          ExecStartPost = "+systemctl reload crowdsec.service";

          # Run as crowdsec user to be able to use cscli
          User = config.services.crowdsec.user;
          Group = config.services.crowdsec.group;

          StateDirectory = "crowdsec crowdsec-firewall-bouncer-register";
          StateDirectoryMode = "0750";

          DynamicUser = true;
          LockPersonality = true;
          NoNewPrivileges = true;
          PrivateDevices = true;
          PrivateTmp = true;
          ProcSubset = "pid";
          ProtectClock = true;
          ProtectControlGroups = true;
          ProtectHome = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectProc = "invisible";
          ProtectSystem = "strict";
          RestrictNamespaces = true;
          RestrictRealtime = true;
          SystemCallArchitectures = "native";
          UMask = "0077";

          StandardOutput = "journal";
          StandardError = "journal";
          SyslogIdentifier = "crowdsec-blocklist-import";
        };
      };
    in
    mkIf cfg.enable {
      services.crowdsec-blocklist-import = {
        crowdsecLapiUrl = lib.mkDefault "http://${config.services.crowdsec.settings.config.api.server.listen_uri}";
        crowdsecLapiKeyFile = lib.mkDefault apiKeyFile;
        crowdsecMachineId = lib.mkDefault config.services.crowdsec.name;
        crowdsecMachinePasswordFile = lib.mkDefault config.services.crowdsec.settings.config.api.client.credentials_path;
      };

      systemd.timers = mkIf (cfg.runAt == "timer") {
        crowdsec-blocklist-import-frequent = {
          description = "CrowdSec blocklist import timer (frequent)";
          wantedBy = [ "timers.target" ];
          timerConfig = {
            OnCalendar = cfg.schedule;
            RandomizedDelaySec = cfg.randomizedDelay;
            Unit = "crowdsec-blocklist-import-frequent.service";
          };
        };
        crowdsec-blocklist-import-limited = {
          description = "CrowdSec blocklist import timer (rate-limited)";
          wantedBy = [ "timers.target" ];
          timerConfig = {
            OnCalendar = cfg.scheduleRateLimited;
            RandomizedDelaySec = cfg.randomizedDelay;
            Unit = "crowdsec-blocklist-import-limited.service";
          };
        };
      };

      systemd.services.crowdsec-blocklist-import-frequent = mkScript "frequent";

      systemd.services.crowdsec-blocklist-import-limited = mkScript "limited";
    };

  meta.maintainers = with lib.maintainers; [ gaelj ];
}
