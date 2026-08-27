{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.libvirtd.autoSnapshot;

  # Function to get VM config with defaults
  getVMConfig =
    vm:
    if lib.isString vm then
      {
        name = vm;
        inherit (cfg) snapshotType keep;
      }
    else
      {
        inherit (vm) name;
        snapshotType = if vm.snapshotType != null then vm.snapshotType else cfg.snapshotType;
        keep = if vm.keep != null then vm.keep else cfg.keep;
      };

  # Main backup script combining all VM scripts
  backupScript = ''
    set -eo pipefail

    # Initialize failure tracking
    failed=""

    # Define the VM snapshot function
    function snap_vm() {
      local vmName="$1"
      local snapshotType="$2"
      local keep="$3"

      # Add validation for VM name
      if ! echo "$vmName" | ${pkgs.gnugrep}/bin/grep -qE '^[a-zA-Z0-9_.-]+$'; then
        echo "Invalid VM name: '$vmName'"
        failed="$failed $vmName"
        return
      fi

      echo "Processing VM: $vmName"

      # Check if VM exists
      if ! ${pkgs.libvirt}/bin/virsh dominfo "$vmName" >/dev/null 2>&1; then
        echo "VM '$vmName' does not exist, skipping"
        return
      fi

      # Create new snapshot
      local snapshot_name
      snapshot_name="${cfg.prefix}_$(date +%Y-%m-%d_%H%M%S)"
      local snapshot_opts=""
      [[ "$snapshotType" == "external" ]] && snapshot_opts="--disk-only"
      if ! ${pkgs.libvirt}/bin/virsh snapshot-create-as \
        "$vmName" \
        "$snapshot_name" \
        "Automatic backup snapshot" \
        $snapshot_opts \
        --atomic; then
        echo "Failed to create snapshot for $vmName"
        failed="$failed $vmName"
        return
      fi

      # List all automatic snapshots for this VM
      readarray -t SNAPSHOTS < <(${pkgs.libvirt}/bin/virsh snapshot-list "$vmName" --name | ${pkgs.gnugrep}/bin/grep "^${cfg.prefix}_")

      # Count snapshots
      local snapshot_count=''${#SNAPSHOTS[@]}

      # Delete old snapshots if we have more than the keep limit
      if [[ $snapshot_count -gt $keep ]]; then
        # Sort snapshots by date (they're named with date prefix)
        readarray -t TO_DELETE < <(printf '%s\n' "''${SNAPSHOTS[@]}" | ${pkgs.coreutils}/bin/sort | ${pkgs.coreutils}/bin/head -n -$keep)
        for snap in "''${TO_DELETE[@]}"; do
          echo "Removing old snapshot $snap from $vmName"

          # Check if snapshot is internal or external
          local snapshot_location
          snapshot_location=$(${pkgs.libvirt}/bin/virsh snapshot-info "$vmName" --snapshotname "$snap" | ${pkgs.gnugrep}/bin/grep "Location:" | ${pkgs.gawk}/bin/awk '{print $2}')

          local delete_opts=""
          [[ "$snapshot_location" == "internal" ]] && delete_opts="--metadata"

          if ! ${pkgs.libvirt}/bin/virsh snapshot-delete "$vmName" "$snap" $delete_opts; then
            echo "Failed to remove snapshot $snap from $vmName"
            failed="$failed $vmName(cleanup)"
          fi
        done
      fi
    }

    ${
      if cfg.vms == null then
        ''
          # Process all VMs
          ${pkgs.libvirt}/bin/virsh list --all --name | while read -r vm; do
            # Skip empty lines
            [ -z "$vm" ] && continue

            # Call snap_vm function with default settings
            snap_vm "$vm" ${cfg.snapshotType} ${toString cfg.keep}
          done
        ''
      else
        ''
          # Process specific VMs from the list
          ${lib.concatMapStrings (
            vm: with getVMConfig vm; "snap_vm '${name}' ${snapshotType} ${toString keep}\n"
          ) cfg.vms}
        ''
    }

    # Report any failures
    if [ -n "$failed" ]; then
      echo "Snapshot operation failed for:$failed"
      exit 1
    fi

    exit 0
  '';
in
{
  options = {
    services.libvirtd.autoSnapshot = {
      enable = lib.mkEnableOption "LibVirt VM snapshots";

      calendar = lib.mkOption {
        type = lib.types.str;
        default = "04:15:00";
        description = ''
          When to create snapshots (systemd calendar format).
          Default is 4:15 AM.
        '';
      };

      prefix = lib.mkOption {
        type = lib.types.str;
        default = "autosnap";
        description = ''
          Prefix for automatic snapshot names.
          This is used to identify and manage automatic snapshots
          separately from manual ones.
        '';
      };

      keep = lib.mkOption {
        type = lib.types.int;
        default = 2;
        description = "Default number of snapshots to keep for VMs that don't specify a keep value.";
      };

      snapshotType = lib.mkOption {
        type = lib.types.enum [
          "internal"
          "external"
        ];
        default = "internal";
        description = "Type of snapshot to create (internal or external).";
      };

      vms = lib.mkOption {
        type = lib.types.nullOr (
          lib.types.listOf (
            lib.types.oneOf [
              lib.types.str
              (lib.types.submodule {
                options = {
                  name = lib.mkOption {
                    type = lib.types.str;
                    description = "Name of the VM";
                  };
                  snapshotType = lib.mkOption {
                    type = lib.types.nullOr (
                      lib.types.enum [
                        "internal"
                        "external"
                      ]
                    );
                    default = null;
                    description = ''
                      Type of snapshot to create (internal or external).
                      If not specified, uses global snapshotType (${toString cfg.snapshotType}).
                    '';
                  };
                  keep = lib.mkOption {
                    type = lib.types.nullOr lib.types.int;
                    default = null;
                    description = ''
                      Number of snapshots to keep for this VM.
                      If not specified, uses global keep (${toString cfg.keep}).
                    '';
                  };
                };
              })
            ]
          )
        );
        default = null;
        description = ''
          If specified only the list of VMs will be snapshotted else all existing one. Each entry can be either:
          - A string (VM name, uses default settings)
          - An attribute set with VM configuration
        '';
        example = lib.literalExpression ''
          [
            "myvm1"              # Uses defaults
            {
              name = "myvm2";
              keep = 30;         # Override retention
            }
          ]
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = (cfg.vms == null) || (lib.isList cfg.vms && cfg.vms != [ ]);
        message = "'services.libvirtd.autoSnapshot.vms' must either be null for all VMs or a non-empty list of VM configurations";
      }
      {
        assertion = config.virtualisation.libvirtd.enable;
        message = "virtualisation.libvirtd must be enabled to use services.libvirtd.autoSnapshot";
      }
    ];

    systemd = {
      timers.libvirtd-autosnapshot = {
        description = "LibVirt VM snapshot timer";
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = cfg.calendar;
          AccuracySec = "5m";
          Unit = "libvirtd-autosnapshot.service";
        };
      };

      services.libvirtd-autosnapshot = {
        description = "LibVirt VM snapshot service";
        after = [ "libvirtd.service" ];
        requires = [ "libvirtd.service" ];
        serviceConfig = {
          Type = "oneshot";
          User = "root";
        };
        script = backupScript;
      };
    };
  };

  meta.maintainers = [ lib.maintainers._6543 ];
}
