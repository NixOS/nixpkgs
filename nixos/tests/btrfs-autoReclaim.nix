{
  lib,
  ...
}:
{
  name = "btrfs-autoReclaim";

  meta.maintainers = with lib.maintainers; [ yajo ];

  nodes.machine =
    { config, ... }:
    {
      virtualisation.useDefaultFilesystems = false;

      virtualisation.rootDevice = "/dev/vda";
      virtualisation.emptyDiskImages = [
        256
        256
      ];

      boot.initrd.systemd.enable = true;

      virtualisation.fileSystems = {
        "/" = {
          device = config.virtualisation.rootDevice;
          fsType = "btrfs";
          autoFormat = true;
        };
        "/mnt/disk1" = {
          device = "/dev/vdb";
          fsType = "btrfs";
          autoFormat = true;
        };
        "/mnt/disk2" = {
          device = "/dev/vdc";
          fsType = "btrfs";
          autoFormat = true;
        };
      };

      services.btrfs.autoReclaim.enable = true;

      # dynamicReclaim = false switches to the fixed-threshold mode, whose
      # defaults (10/50) prove the conditional-default wiring. The switch must
      # also clear the dynamic flag before writing them: the kernel rejects
      # threshold writes while it is on. The specialisation is activated with
      # switch-to-configuration, exercising the live re-setup without a reboot.
      specialisation.static.configuration.services.btrfs.autoReclaim.dynamicReclaim = false;
    };

  testScript = ''
    # If tmpfiles ran before the filesystems were mounted, the glob rules
    # would have matched nothing and the assertions below would fail, so
    # this also covers the mount-vs-tmpfiles ordering.
    machine.wait_for_unit("local-fs.target")
    machine.wait_for_unit("systemd-tmpfiles-setup.service")

    def fsattr(name: str) -> list[str]:
        # One value per mounted btrfs filesystem, in sysfs directory order.
        return machine.succeed(f"for f in /sys/fs/btrfs/*/allocation/{name}; do cat $f; echo; done").split()

    with subtest("dynamic reclaim is the default on this kernel"):
        assert fsattr("data/dynamic_reclaim") == ["1"] * 3, fsattr("data/dynamic_reclaim")
        assert fsattr("metadata/dynamic_reclaim") == ["1"] * 3, fsattr("metadata/dynamic_reclaim")
        # bg_reclaim_threshold is not asserted here: with dynamic reclaim on,
        # the kernel reports the threshold it computes live from space pressure,
        # not a stored static value. If tmpfiles ran before any filesystem was
        # mounted, these flags would be 0 and the asserts above would fail.

    with subtest("switching to fixed thresholds clears the dynamic flag first"):
        machine.succeed("/run/booted-system/specialisation/static/bin/switch-to-configuration test >&2")
        assert fsattr("data/dynamic_reclaim") == ["0"] * 3, fsattr("data/dynamic_reclaim")
        assert fsattr("data/bg_reclaim_threshold") == ["10"] * 3, fsattr("data/bg_reclaim_threshold")
        assert fsattr("metadata/bg_reclaim_threshold") == ["50"] * 3, fsattr("metadata/bg_reclaim_threshold")

    with subtest("switching back to dynamic reclaim"):
        machine.succeed("/run/booted-system/bin/switch-to-configuration test >&2")
        assert fsattr("data/dynamic_reclaim") == ["1"] * 3, fsattr("data/dynamic_reclaim")
  '';
}
