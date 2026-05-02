# SPDX-License-Identifier: MIT
# Lore Sync Service
#
# Periodically syncs patches from lore.kernel.org for monitored kernel subsystems.
# Useful for kernel developers and security teams tracking upstream patches.
#
# Basic usage:
#   services.lore-sync.enable = true;
#
# Monitor specific subsystems:
#   services.lore-sync = {
#     enable = true;
#     subsystems = [ "dri-devel" "netdev" "rust-for-linux" ];
#   };

{ config, lib, pkgs, ... }:

let
  cfg = config.services.lore-sync;

  # Kernel subsystem mailing list configurations
  mailingLists = {
    all = {
      url = "https://lore.kernel.org/all";
      email = "linux-kernel@vger.kernel.org";
      description = "All kernel mailing lists";
    };
    dri-devel = {
      url = "https://lore.kernel.org/dri-devel";
      email = "dri-devel@lists.freedesktop.org";
      description = "DRM/Graphics subsystem";
    };
    netdev = {
      url = "https://lore.kernel.org/netdev";
      email = "netdev@vger.kernel.org";
      description = "Networking subsystem";
    };
    linux-fsdevel = {
      url = "https://lore.kernel.org/linux-fsdevel";
      email = "linux-fsdevel@vger.kernel.org";
      description = "Filesystem development";
    };
    linux-mm = {
      url = "https://lore.kernel.org/linux-mm";
      email = "linux-mm@kvack.org";
      description = "Memory management";
    };
    linux-security-module = {
      url = "https://lore.kernel.org/linux-security-module";
      email = "linux-security-module@vger.kernel.org";
      description = "Security modules (LSM)";
    };
    linux-hardening = {
      url = "https://lore.kernel.org/linux-hardening";
      email = "linux-hardening@vger.kernel.org";
      description = "Kernel hardening (KSPP)";
    };
    rust-for-linux = {
      url = "https://lore.kernel.org/rust-for-linux";
      email = "rust-for-linux@vger.kernel.org";
      description = "Rust for Linux development";
    };
    linux-block = {
      url = "https://lore.kernel.org/linux-block";
      email = "linux-block@vger.kernel.org";
      description = "Block layer and storage";
    };
    linux-btrfs = {
      url = "https://lore.kernel.org/linux-btrfs";
      email = "linux-btrfs@vger.kernel.org";
      description = "Btrfs filesystem";
    };
    linux-ext4 = {
      url = "https://lore.kernel.org/linux-ext4";
      email = "linux-ext4@vger.kernel.org";
      description = "ext4 filesystem";
    };
    linux-xfs = {
      url = "https://lore.kernel.org/linux-xfs";
      email = "linux-xfs@vger.kernel.org";
      description = "XFS filesystem";
    };
    linux-usb = {
      url = "https://lore.kernel.org/linux-usb";
      email = "linux-usb@vger.kernel.org";
      description = "USB subsystem";
    };
    linux-pci = {
      url = "https://lore.kernel.org/linux-pci";
      email = "linux-pci@vger.kernel.org";
      description = "PCI subsystem";
    };
  };

  # Generate sync script
  syncScript = pkgs.writeShellScript "lore-sync" ''
    set -euo pipefail

    LORE_DIR="${cfg.dataDir}"
    LOG_FILE="${cfg.logDir}/sync.log"

    log() { echo "[$(date -Iseconds)] $*" | tee -a "$LOG_FILE"; }

    mkdir -p "$LORE_DIR" "$(dirname "$LOG_FILE")"

    log "Starting lore sync for subsystems: ${lib.concatStringsSep ", " cfg.subsystems}"

    ${lib.concatMapStrings (subsystem: ''
      log "Syncing ${subsystem}..."
      SUBSYSTEM_DIR="$LORE_DIR/${subsystem}"
      mkdir -p "$SUBSYSTEM_DIR"

      ${if cfg.useLei then ''
      # Use public-inbox/lei for full mbox sync (preferred)
      if command -v lei >/dev/null 2>&1; then
        lei q -o "$SUBSYSTEM_DIR" \
          --threads \
          -f mboxrd \
          "l:${mailingLists.${subsystem}.email} AND dt:${toString cfg.lookbackDays}d.." \
          2>&1 | tee -a "$LOG_FILE" || {
          log "WARNING: lei query failed for ${subsystem}, falling back to Atom"
        }
      else
        log "WARNING: lei not found, using Atom feed fallback"
      fi
      '' else ""}

      # Fetch Atom feed (always, for quick overview)
      ${pkgs.curl}/bin/curl -sf \
        "${mailingLists.${subsystem}.url}/new.atom" \
        -o "$SUBSYSTEM_DIR/feed.atom" 2>&1 || {
        log "WARNING: Failed to fetch Atom feed for ${subsystem}"
      }

      # Generate summary
      if [[ -f "$SUBSYSTEM_DIR/feed.atom" ]]; then
        ENTRY_COUNT=$(${pkgs.gnugrep}/bin/grep -c '<entry>' "$SUBSYSTEM_DIR/feed.atom" 2>/dev/null || echo 0)
        log "${subsystem}: $ENTRY_COUNT recent entries in feed"
      fi

    '') cfg.subsystems}

    # Generate overall summary
    log "Sync complete. Data stored in $LORE_DIR"

    ${lib.optionalString cfg.generateIndex ''
    # Generate index of all synced data
    log "Generating index..."
    {
      echo "# Lore Sync Index - $(date -Iseconds)"
      echo ""
      for subsystem in ${lib.concatStringsSep " " cfg.subsystems}; do
        echo "## $subsystem"
        if [[ -f "$LORE_DIR/$subsystem/feed.atom" ]]; then
          ${pkgs.gnugrep}/bin/grep -oP '(?<=<title>).*(?=</title>)' \
            "$LORE_DIR/$subsystem/feed.atom" 2>/dev/null | head -20 || true
        fi
        echo ""
      done
    } > "$LORE_DIR/INDEX.md"
    log "Index written to $LORE_DIR/INDEX.md"
    ''}
  '';

in
{
  options.services.lore-sync = {
    enable = lib.mkEnableOption "lore.kernel.org patch synchronization" // {
      description = ''
        Enable periodic synchronization of kernel patches from lore.kernel.org.

        This service fetches patch discussions from kernel mailing lists,
        useful for kernel developers, security teams, and anyone tracking
        upstream kernel development.
      '';
    };

    subsystems = lib.mkOption {
      type = lib.types.listOf (lib.types.enum (builtins.attrNames mailingLists));
      default = [ "linux-hardening" "rust-for-linux" ];
      example = [ "dri-devel" "netdev" "linux-fsdevel" ];
      description = ''
        Kernel subsystem mailing lists to monitor.

        Available subsystems:
        ${lib.concatMapStrings (name: "\n- `${name}`: ${mailingLists.${name}.description}")
          (builtins.attrNames mailingLists)}
      '';
    };

    interval = lib.mkOption {
      type = lib.types.str;
      default = "6h";
      example = "1d";
      description = ''
        How often to sync patches. Uses systemd calendar format.
        See {manpage}`systemd.time(7)` for format details.
      '';
    };

    lookbackDays = lib.mkOption {
      type = lib.types.int;
      default = 7;
      example = 30;
      description = "Number of days to look back for patches.";
    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/lore-sync";
      description = "Directory to store synced patch data.";
    };

    logDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/log/lore-sync";
      description = "Directory for log files.";
    };

    useLei = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Use public-inbox/lei for fetching full mbox archives.
        This provides complete patch threads but requires more storage.
        Falls back to Atom feeds if lei is unavailable.
      '';
    };

    generateIndex = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Generate an index file summarizing synced patches.";
    };
  };

  config = lib.mkIf cfg.enable {
    # Install public-inbox for lei support
    environment.systemPackages = lib.mkIf cfg.useLei [
      pkgs.public-inbox
    ];

    # Create directories
    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir} 0755 root root -"
      "d ${cfg.logDir} 0755 root root -"
    ];

    # Timer for periodic sync
    systemd.timers.lore-sync = {
      description = "Lore kernel patch sync timer";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "5min";
        OnUnitActiveSec = cfg.interval;
        RandomizedDelaySec = "10min";
        Persistent = true;
      };
    };

    # Sync service
    systemd.services.lore-sync = {
      description = "Lore kernel patch synchronization";
      documentation = [ "https://lore.kernel.org/" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];

      serviceConfig = {
        Type = "oneshot";
        ExecStart = syncScript;
        TimeoutStartSec = "30min";

        # Security hardening
        DynamicUser = true;
        StateDirectory = "lore-sync";
        LogsDirectory = "lore-sync";
        PrivateTmp = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ReadWritePaths = [ cfg.dataDir cfg.logDir ];
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
  };

  meta.maintainers = [ ];  # TODO: Add maintainer handle
}
