{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.hardware.nvidia.datacenter.nvlink5;
  fm = config.hardware.nvidia.package.fabricmanager;
  nvlsm = config.hardware.nvidia.package.nvlsm or null;
  runtime = "/run/nvidia-fabricmanager";
  socket = "${runtime}/fm_sm_ipc.socket";

  # Set the NVLink5 defaults
  fmConfig = (pkgs.formats.keyValue { }).generate "fabricmanager-nvlink5.cfg" (
    {
      DATABASE_PATH = "/var/lib/nvidia-fabricmanager";
    }
    // config.hardware.nvidia.datacenter.settings
    // {
      FM_SM_IPC_INTERFACE = "unix:${socket}";
      DAEMONIZE = 0;
      LOG_USE_SYSLOG = 1;
      FM_SM_MGMT_PORT_GUID = "0x0"; # replaced at activation time
      TOPOLOGY_FILE_PATH = "${fm}/share/nvidia-fabricmanager/nvidia/nvswitch";
    }
  );

  # Generate a NVLink5 config at system build time
  nvlsmGeneratedConfig =
    pkgs.runCommandLocal "nvlsm-nvlink5.conf"
      {
        nativeBuildInputs = with pkgs; [
          coreutils
          findutils
          gawk
          gnugrep
        ];
      }
      ''
        set -eu

        vendor_cfg=""
        for candidate in \
          ${nvlsm}/share/nvidia/nvlsm/nvlsm.conf \
          ${nvlsm}/share/nvidia/nvswitch/nvlsm.conf \
          ${nvlsm}/etc/nvlsm/nvlsm.conf \
          ${nvlsm}/share/nvidia/nvlsm/nvlsm.cfg; do
          if [ -f "$candidate" ]; then
            vendor_cfg="$candidate"
            break
          fi
        done
        if [ -z "$vendor_cfg" ]; then
          vendor_cfg="$(find ${nvlsm} -type f \
            \( -name nvlsm.conf -o -name nvlsm.cfg \) -print -quit)"
        fi
        if [ -z "$vendor_cfg" ]; then
          echo "NVLSM vendor configuration was not found in ${nvlsm}" >&2
          exit 1
        fi

        device_cfg=${nvlsm}/share/nvidia/nvlsm/device_configuration.conf
        if [ ! -r "$device_cfg" ]; then
          echo "NVLSM device configuration is missing: $device_cfg" >&2
          exit 1
        fi

        # We keep as many upstream settings except those managed here, guid is
        # appended at runtime
        awk '
          $1 ~ /^(guid|daemon|plugin_name|plugin_options|log_file|syslog_log_flags|device_configuration_file)$/ { next }
          { print }
        ' "$vendor_cfg" > "$out"
        if ! grep -Eiq '^[[:space:]]*nvlink_enable[[:space:]]+(true|1)([[:space:]]|$)' "$out"; then
          echo "NVLSM vendor configuration does not enable NVLink management: $vendor_cfg" >&2
          exit 1
        fi
        cat >> "$out" <<'NVLSM_CONF'
        daemon false
        plugin_name grpc_mgr
        plugin_options grpc_mgr --grpc_server_address unix:${socket}
        log_file /var/log/nvlsm.log
        syslog_log_flags 0x3
        device_configuration_file ${nvlsm}/share/nvidia/nvlsm/device_configuration.conf
        NVLSM_CONF
      '';

  # Wait for nvlsm to create its grpc socket before starting fabricmanager.
  waitForNvlsm = pkgs.writeShellScript "wait-for-nvlsm-grpc" ''
    for ((i=0; i<90; ++i)); do
      [ -S "${socket}" ] && exit 0
      ${pkgs.coreutils}/bin/sleep 1
    done
    echo "NVLSM never created ${socket}; inspect the early NVLSM log lines" >&2
    exit 1
  '';

in
{
  options.hardware.nvidia.datacenter.nvlink5.enable = lib.mkEnableOption ''
    the NVLink5 subnet manager used by HGX B200/B300 GPUs
  '';

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.hardware.nvidia.datacenter.enable;
        message = "NVLink5 requires hardware.nvidia.datacenter.enable = true.";
      }
      {
        assertion = nvlsm != null;
        message = "NVLink5 needs an NVIDIA package with paired NVLSM; choose dc_580 or a driver package exposing .nvlsm.";
      }
    ];

    # Load the RDMA devices used by the NVLink5 management bridge.
    boot.kernelModules = [
      "mlx5_ib"
      "ib_umad"
    ];

    environment.systemPackages = lib.optional (nvlsm != null) nvlsm;

    # Prepare the shared FM/NVLSM runtime configuration.
    systemd.services.nvidia-nlink5-configgen = {
      description = "Generate NVLink5 Fabric Manager and NVLSM configuration";
      after = [
        "systemd-modules-load.service"
        "systemd-udev-trigger.service"
      ];
      path = with pkgs; [
        coreutils
        gnugrep
        gnused
      ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        TimeoutStartSec = 90;
        RuntimeDirectory = "nvidia-fabricmanager";
        RuntimeDirectoryMode = "0755";
      };
      script = ''
        set -euo pipefail

        # PCI/IB device numbering can change across reboots. Instead, we read
        # port capabilities from sysfs.
        chosen_guid=""
        chosen_dev=""
        for ((attempt = 0; attempt < 60; attempt++)); do
          for ib in /sys/class/infiniband/mlx5_*; do
            [ -d "$ib" ] || continue
            [ -r "$ib/device/vpd" ] || continue
            [ -r "$ib/ports/1/cap_mask" ] || continue
            [ -r "$ib/ports/1/gids/0" ] || continue
            [ -r "$ib/device/vendor" ] || continue
            [ "$(cat "$ib/device/vendor")" = "0x15b3" ] || continue
            grep -a -q 'SMDL=SW_MNG' "$ib/device/vpd" || continue

            # 2=INIT and 4=ACTIVE are expected for management-capable ports;
            # do not select an FC PF whose port is DOWN.
            state="$(cat "$ib/ports/1/state")"
            case "$state" in
              '2: INIT'|'4: ACTIVE') ;;
              *) continue ;;
            esac
            [ "$(cat "$ib/ports/1/phys_state")" = "5: LinkUp" ] || continue

            # The two FC functions may also advertise SW_MNG and LinkUp,
            # but have no userspace MAD device. Require a usable UMAD node.
            ibdev="$(basename "$ib")"
            has_umad=false
            for mad in /sys/class/infiniband_mad/umad*; do
              [ -r "$mad/ibdev" ] && [ -r "$mad/port" ] || continue
              [ "$(cat "$mad/ibdev")" = "$ibdev" ] || continue
              [ "$(cat "$mad/port")" = "1" ] || continue
              [ -c "/dev/infiniband/$(basename "$mad")" ] || continue
              has_umad=true
              break
            done
            [ "$has_umad" = true ] || continue

            # PortInfo.CapabilityMask bit 10 is IsSMDisabled.
            mask="$(cat "$ib/ports/1/cap_mask")"
            [[ "$mask" =~ ^0x[0-9a-fA-F]+$ ]] || continue
            if (( (mask & 0x400) != 0 )); then continue; fi

            # Port GUID is the last 64 bits of the GID (not the full GID).
            gid="$(cat "$ib/ports/1/gids/0")"
            hex="$(printf '%s' "$gid" | cut -d: -f5-8 | tr -d ':')"
            [[ "$hex" =~ ^[0-9a-fA-F]{16}$ ]] || continue
            chosen_guid="0x$hex"
            chosen_dev="$(basename "$ib")"
            break
          done
          [ -n "$chosen_guid" ] && break
          sleep 1
        done

        if [ -z "$chosen_guid" ]; then
          echo 'No suitable SW_MNG port: check mlx5_ib/ib_umad, PCI VPD, cap_mask and port state' >&2
          exit 1
        fi

        echo "NVLink5 management: $chosen_dev, GUID $chosen_guid"
        printf '%s\n' "$chosen_guid" > ${runtime}/port-guid

        cp ${fmConfig} ${runtime}/fabricmanager.cfg
        chmod 0644 ${runtime}/fabricmanager.cfg
        sed -i "s/^FM_SM_MGMT_PORT_GUID=.*/FM_SM_MGMT_PORT_GUID=$chosen_guid/" \
          ${runtime}/fabricmanager.cfg

        # The only runtime value is the management port GUID.
        cp ${nvlsmGeneratedConfig} ${runtime}/nvlsm.conf
        chmod 0644 ${runtime}/nvlsm.conf
        printf 'guid %s\n' "$chosen_guid" >> ${runtime}/nvlsm.conf
      '';
    };

    # Start NVLSM with the NVLink configuration then wait for gRPC.
    # FM's Requires=/After= will not complete until this check succeeds.
    systemd.services.nvidia-nvlsm = {
      description = "NVIDIA NVLink5 Subnet Manager";
      requires = [ "nvidia-nlink5-configgen.service" ];
      after = [ "nvidia-nlink5-configgen.service" ];
      environment.LD_LIBRARY_PATH = "${nvlsm}/lib";
      serviceConfig = {
        Type = "exec";
        ExecStartPre = "${pkgs.coreutils}/bin/rm -f ${socket}";
        ExecStart = "${lib.getExe' nvlsm "nvlsm"} -F ${runtime}/nvlsm.conf";
        ExecStartPost = waitForNvlsm;
        TimeoutStartSec = 150;
        Restart = "no";
        RestartSec = 5;
        StateDirectory = "nvlsm";
        CacheDirectory = "nvlsm";
        WorkingDirectory = "/var/lib/nvlsm";
        LimitMEMLOCK = "infinity";
        LimitCORE = "infinity";
      };
    };

    # Re-enable fabricmanager for nvlink5..
    systemd.services.nvidia-fabricmanager = {
      enable = true;
      description = "NVIDIA NVLink5 Fabric Manager";
      wantedBy = [ "multi-user.target" ];
      bindsTo = [ "nvidia-nvlsm.service" ];
      after = [ "nvidia-nvlsm.service" ];
      requires = [ "nvidia-nvlsm.service" ];
      serviceConfig = {
        Type = "simple";
        TimeoutStartSec = 240;
        ExecStart = "${lib.getExe fm} -c ${runtime}/fabricmanager.cfg";
        Restart = "on-failure";
        RestartSec = 10;
        # FM's LMDB database must be writable.
        StateDirectory = "nvidia-fabricmanager";
        StateDirectoryMode = "0700";
        LimitMEMLOCK = "infinity";
      };
    };
  };
}
