{ config, lib, pkgs, ... }:

let
  cfg = config.virtualisation.lxd.agent;

  # the lxd agent is provided by the lxd daemon through a virtiofs or 9p mount
  # this is a port of the distrobuilder lxd-agent generator
  # https://github.com/lxc/distrobuilder/blob/f77300bf7d7d5707b08eaf8a434d647d1ba81b5d/generators/lxd-agent.go#L18-L55
  preStartScript = ''
    PREFIX="/run/lxd_agent"

    mount_virtiofs() {
        mount -t virtiofs config "$PREFIX/.mnt" >/dev/null 2>&1
    }

    mount_9p() {
        modprobe 9pnet_virtio >/dev/null 2>&1 || true
        mount -t 9p config "$PREFIX/.mnt" -o access=0,trans=virtio,size=1048576 >/dev/null 2>&1
    }

    fail() {
        umount -l "$PREFIX" >/dev/null 2>&1 || true
        rmdir "$PREFIX" >/dev/null 2>&1 || true
        echo "$1"
        exit 1
    }

    # Setup the mount target.
    umount -l "$PREFIX" >/dev/null 2>&1 || true
    mkdir -p "$PREFIX"
    mount -t tmpfs tmpfs "$PREFIX" -o mode=0700,size=50M
    mkdir -p "$PREFIX/.mnt"

    # Try virtiofs first.
    mount_virtiofs || mount_9p || fail "Couldn't mount virtiofs or 9p, failing."

    # Copy the data.
    cp -Ra "$PREFIX/.mnt/"* "$PREFIX"

    # Unmount the temporary mount.
    umount "$PREFIX/.mnt"
    rmdir "$PREFIX/.mnt"

    # Fix up permissions.
    chown -R root:root "$PREFIX"
  '';
in {
  options = {
    virtualisation.lxd.agent.enable = lib.mkEnableOption "LXD agent";
  };

  config = lib.mkIf cfg.enable {
    # https://github.com/lxc/distrobuilder/blob/f77300bf7d7d5707b08eaf8a434d647d1ba81b5d/generators/lxd-agent.go#L108-L125
    systemd.services.lxd-agent = {
      enable = true;
      wantedBy = [ "multi-user.target" ];
      before = [ "shutdown.target" ] ++ lib.optionals config.services.cloud-init.enable [
        "cloud-init.target" "cloud-init.service" "cloud-init-local.service"
      ];
      conflicts = [ "shutdown.target" ];
      path = [
        pkgs.kmod
        pkgs.util-linux

        # allow `incus exec` to find system binaries
        "/run/current-system/sw"
      ];

      preStart = preStartScript;

      # avoid killing nixos-rebuild switch when executed through lxc exec
      restartIfChanged = false;
      stopIfChanged = false;

      unitConfig = {
        Description = "LXD - agent";
        Documentation = "https://documentation.ubuntu.com/lxd/en/latest";
        ConditionPathExists = "/dev/virtio-ports/org.linuxcontainers.lxd";
        DefaultDependencies = "no";
        StartLimitInterval = "60";
        StartLimitBurst = "10";
      };

      serviceConfig = {
        Type = "notify";
        WorkingDirectory = "-/run/lxd_agent";
        ExecStart = "/run/lxd_agent/lxd-agent";
        Restart = "on-failure";
        RestartSec = "5s";
      };
    };

    systemd.paths.lxd-agent = {
      enable = true;
      wantedBy = [ "multi-user.target" ];
      pathConfig.PathExists = "/dev/virtio-ports/org.linuxcontainers.lxd";
    };
  };
}
