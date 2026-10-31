# SPDX-License-Identifier: MIT
# NVD CVE Sync Service
#
# Periodically syncs CVE data from NIST National Vulnerability Database.
# Useful for security monitoring, kernel vulnerability tracking, and
# automated security auditing.
#
# Basic usage:
#   services.nvd-sync.enable = true;
#
# Track specific products:
#   services.nvd-sync = {
#     enable = true;
#     products = [ "cpe:2.3:o:linux:linux_kernel" ];
#     outputDir = "/var/lib/nvd-sync";
#   };

{ config, lib, pkgs, ... }:

let
  cfg = config.services.nvd-sync;

  # NVD API 2.0 base URL
  nvdApiUrl = "https://services.nvd.nist.gov/rest/json/cves/2.0";

  syncScript = pkgs.writeShellScript "nvd-cve-sync" ''
    set -euo pipefail

    OUTPUT_DIR="${cfg.outputDir}"
    LOG_FILE="/var/log/nvd-sync/sync.log"
    STATE_FILE="$OUTPUT_DIR/.last-sync"
    API_KEY="${lib.optionalString (cfg.apiKeyFile != null) "$(cat ${cfg.apiKeyFile})"}"

    log() { echo "[$(date -Iseconds)] $*" | tee -a "$LOG_FILE"; }

    mkdir -p "$OUTPUT_DIR" "$(dirname "$LOG_FILE")"

    log "Starting NVD CVE sync..."

    # Determine date range
    if [[ -f "$STATE_FILE" ]] && [[ "${toString cfg.fullSync}" != "true" ]]; then
      LAST_SYNC=$(cat "$STATE_FILE")
      log "Incremental sync since $LAST_SYNC"
      DATE_PARAMS="&lastModStartDate=$LAST_SYNC&lastModEndDate=$(date -u +%Y-%m-%dT%H:%M:%S.000)"
    else
      # Full sync: last ${toString cfg.lookbackDays} days
      START_DATE=$(date -u -d "${toString cfg.lookbackDays} days ago" +%Y-%m-%dT00:00:00.000 2>/dev/null || \
                   date -u -v-${toString cfg.lookbackDays}d +%Y-%m-%dT00:00:00.000)
      DATE_PARAMS="&lastModStartDate=$START_DATE&lastModEndDate=$(date -u +%Y-%m-%dT%H:%M:%S.000)"
      log "Full sync from $START_DATE"
    fi

    # Build API URL with optional filters
    API_URL="${nvdApiUrl}?resultsPerPage=2000$DATE_PARAMS"

    ${lib.concatMapStrings (product: ''
    # Filter by product CPE: ${product}
    API_URL="$API_URL&cpeName=${product}"
    '') cfg.products}

    # Add API key header if provided
    CURL_OPTS=(-sf --retry 3 --retry-delay 10)
    if [[ -n "$API_KEY" ]]; then
      CURL_OPTS+=(-H "apiKey: $API_KEY")
      log "Using NVD API key for higher rate limits"
    else
      log "No API key configured (rate limited to 5 requests/30s)"
      # Respect rate limits without API key
      sleep 6
    fi

    # Fetch CVE data
    TIMESTAMP=$(date -u +%Y%m%d-%H%M%S)
    OUTPUT_FILE="$OUTPUT_DIR/cves-$TIMESTAMP.json"

    log "Fetching from NVD API..."
    if ${pkgs.curl}/bin/curl "''${CURL_OPTS[@]}" "$API_URL" -o "$OUTPUT_FILE"; then
      CVE_COUNT=$(${pkgs.jq}/bin/jq '.totalResults // 0' "$OUTPUT_FILE")
      log "Retrieved $CVE_COUNT CVEs"

      # Update state file
      date -u +%Y-%m-%dT%H:%M:%S.000 > "$STATE_FILE"

      # Create latest symlink
      ln -sf "$(basename "$OUTPUT_FILE")" "$OUTPUT_DIR/latest.json"

      # Cleanup old files (keep last N)
      cd "$OUTPUT_DIR"
      ls -t cves-*.json 2>/dev/null | tail -n +${toString (cfg.keepFiles + 1)} | xargs -r rm -f

      ${lib.optionalString cfg.extractKernelCves ''
      # Extract kernel-specific CVEs to separate file
      ${pkgs.jq}/bin/jq '[.vulnerabilities[] | select(
        .cve.descriptions[]?.value | test("kernel|linux"; "i")
      )]' "$OUTPUT_FILE" > "$OUTPUT_DIR/kernel-cves-$TIMESTAMP.json"
      ln -sf "kernel-cves-$TIMESTAMP.json" "$OUTPUT_DIR/kernel-latest.json"
      KERNEL_COUNT=$(${pkgs.jq}/bin/jq 'length' "$OUTPUT_DIR/kernel-cves-$TIMESTAMP.json")
      log "Extracted $KERNEL_COUNT kernel-related CVEs"
      ''}

      log "NVD sync complete"
    else
      log "ERROR: Failed to fetch from NVD API"
      exit 1
    fi
  '';

in
{
  options.services.nvd-sync = {
    enable = lib.mkEnableOption "NVD CVE synchronization service" // {
      description = ''
        Enable periodic synchronization of CVE data from the
        NIST National Vulnerability Database (NVD).

        CVE data is stored as JSON files in {option}`outputDir`.
      '';
    };

    outputDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/nvd-sync";
      description = "Directory to store downloaded CVE data.";
    };

    interval = lib.mkOption {
      type = lib.types.str;
      default = "daily";
      example = "hourly";
      description = ''
        How often to sync CVEs. Uses systemd calendar format.
        See {manpage}`systemd.time(7)` for format details.
      '';
    };

    onBoot = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Run sync shortly after boot.";
    };

    fullSync = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Perform full CVE sync instead of incremental.
        Fetches all CVEs from the last {option}`lookbackDays` days.
      '';
    };

    lookbackDays = lib.mkOption {
      type = lib.types.int;
      default = 120;
      description = ''
        Number of days to look back for full sync.
        NVD API limits queries to 120-day windows.
      '';
    };

    products = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "cpe:2.3:o:linux:linux_kernel" ];
      description = ''
        List of CPE product names to filter CVEs.
        Leave empty to fetch all CVEs.

        Common CPEs:
        - `cpe:2.3:o:linux:linux_kernel` - Linux kernel
        - `cpe:2.3:a:mozilla:firefox` - Firefox
        - `cpe:2.3:a:apache:http_server` - Apache HTTPD
      '';
    };

    extractKernelCves = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Extract kernel-related CVEs to a separate file for
        easier security monitoring of kernel vulnerabilities.
      '';
    };

    apiKeyFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/run/secrets/nvd-api-key";
      description = ''
        Path to file containing NVD API key.
        Without an API key, requests are rate-limited to 5 per 30 seconds.
        Request a free API key at https://nvd.nist.gov/developers/request-an-api-key
      '';
    };

    keepFiles = lib.mkOption {
      type = lib.types.int;
      default = 30;
      description = "Number of historical CVE snapshots to keep.";
    };
  };

  config = lib.mkIf cfg.enable {
    # Create directories
    systemd.tmpfiles.rules = [
      "d ${cfg.outputDir} 0755 root root -"
      "d /var/log/nvd-sync 0755 root root -"
    ];

    # Timer for periodic sync
    systemd.timers.nvd-sync = {
      description = "NVD CVE sync timer";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = cfg.interval;
        Persistent = true;
        RandomizedDelaySec = "30min";
      } // lib.optionalAttrs cfg.onBoot {
        OnBootSec = "5min";
      };
    };

    # Sync service
    systemd.services.nvd-sync = {
      description = "NVD CVE synchronization";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];

      serviceConfig = {
        Type = "oneshot";
        ExecStart = syncScript;
        TimeoutStartSec = "15min";

        # Security hardening
        DynamicUser = true;
        StateDirectory = "nvd-sync";
        LogsDirectory = "nvd-sync";
        PrivateTmp = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ReadWritePaths = [
          cfg.outputDir
          "/var/log/nvd-sync"
        ] ++ lib.optional (cfg.apiKeyFile != null) (builtins.dirOf cfg.apiKeyFile);
        NoNewPrivileges = true;
        PrivateDevices = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        RestrictNamespaces = true;
        RestrictSUIDSGID = true;
        MemoryDenyWriteExecute = true;
        LockPersonality = true;
        SystemCallFilter = [ "@system-service" ];
        SystemCallArchitectures = "native";
      };
    };

    # Install jq for JSON processing
    environment.systemPackages = [ pkgs.jq ];
  };

  meta.maintainers = [ ];  # TODO: Add maintainer handle after nixpkgs PR
}
