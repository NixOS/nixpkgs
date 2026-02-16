# Test for virtualisation.bootDiskAdditionalSpace option
#
# This test validates that the bootDiskAdditionalSpace option correctly provides
# additional usable disk space for bootloader-enabled VMs.
#
# == Background ==
#
# When virtualisation.useBootLoader = true, the qemu-vm module creates a full
# disk image via make-disk-image.nix rather than using 9p-shared store mounts.
# Previously, this disk was sized exactly to fit the NixOS closure with no
# additional space (additionalSpace = "0M"), causing disk exhaustion for
# workloads that write significant runtime data (containers, databases, etc.).
#
# The bootDiskAdditionalSpace option (default: "512M") allows configuring
# additional space beyond the closure size.
#
# == Test Coverage ==
#
# Pre-existing tests that use useBootLoader = true:
#   - nixos/tests/systemd-boot.nix (15+ subtests for bootloader functionality)
#   - nixos/tests/qemu-vm-store.nix (fullDisk node tests store mounting)
#   - nixos/tests/qemu-vm-external-disk-image.nix (external disk image booting)
#   - nixos/tests/grow-partition.nix (partition auto-expansion)
#   - nixos/tests/installer.nix (full installation process)
#   - Various bootloader tests: grub.nix, limine/*.nix, refind.nix
#   - Encrypted disk tests: luks.nix, lvm2/*.nix, systemd-initrd-*.nix
#
# Gap addressed by this test:
#   None of the above tests validate that additional disk space is actually
#   usable for writing data. They only verify boot functionality.
#
# This test specifically validates:
#   1. Bootloader VMs can write data up to the configured additional space
#   2. The default "512M" provides meaningful headroom
#   3. Custom values (e.g., "1G") work correctly
#
# == Related ==
#
# - Option definition: nixos/modules/virtualisation/qemu-vm.nix
# - Disk image creation: nixos/lib/make-disk-image.nix
# - Similar tests: qemu-vm-store.nix (store modes), grow-partition.nix (expansion)

{ lib, ... }:

let
  common = {
    virtualisation.useBootLoader = true;
    virtualisation.useEFIBoot = true;
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
  };
in
{
  name = "qemu-vm-bootdisk-space";

  meta = {
    maintainers = [ ]; # Add maintainer when upstreaming
  };

  nodes = {
    # Test with default additional space (512M)
    defaultSpace = {
      imports = [ common ];
      # Uses default bootDiskAdditionalSpace = "512M"
    };

    # Test with custom larger additional space
    customSpace = {
      imports = [ common ];
      virtualisation.bootDiskAdditionalSpace = "1G";
    };

    # Test with minimal additional space (regression baseline)
    minimalSpace = {
      imports = [ common ];
      virtualisation.bootDiskAdditionalSpace = "64M";
    };
  };

  testScript = ''
    start_all()

    with subtest("Default 512M additional space is usable"):
        defaultSpace.wait_for_unit("multi-user.target")

        # Verify we can write a substantial amount of data
        # 256MB should succeed with 512M additional space
        defaultSpace.succeed("dd if=/dev/zero of=/var/tmp/testfile bs=1M count=256 conv=fsync")
        defaultSpace.succeed("sync")

        # Verify the file exists and has correct size
        defaultSpace.succeed("test $(stat -c%s /var/tmp/testfile) -eq $((256 * 1024 * 1024))")

        # Clean up
        defaultSpace.succeed("rm /var/tmp/testfile")

    with subtest("Custom 1G additional space allows larger writes"):
        customSpace.wait_for_unit("multi-user.target")

        # 768MB should succeed with 1G additional space
        customSpace.succeed("dd if=/dev/zero of=/var/tmp/testfile bs=1M count=768 conv=fsync")
        customSpace.succeed("sync")

        # Verify the file exists
        customSpace.succeed("test $(stat -c%s /var/tmp/testfile) -eq $((768 * 1024 * 1024))")

        # Clean up
        customSpace.succeed("rm /var/tmp/testfile")

    with subtest("Minimal 64M additional space still boots and allows small writes"):
        minimalSpace.wait_for_unit("multi-user.target")

        # Small write should succeed even with minimal space
        minimalSpace.succeed("dd if=/dev/zero of=/var/tmp/testfile bs=1M count=32 conv=fsync")
        minimalSpace.succeed("sync")

        # Verify the file exists
        minimalSpace.succeed("test $(stat -c%s /var/tmp/testfile) -eq $((32 * 1024 * 1024))")

        # Clean up
        minimalSpace.succeed("rm /var/tmp/testfile")

    with subtest("Disk space reporting reflects configuration"):
        # Get available space on each node (after boot, before writes)
        # This is informational - actual values depend on closure size

        default_avail = defaultSpace.succeed("df -BM --output=avail / | tail -1 | tr -d ' M'")
        custom_avail = customSpace.succeed("df -BM --output=avail / | tail -1 | tr -d ' M'")
        minimal_avail = minimalSpace.succeed("df -BM --output=avail / | tail -1 | tr -d ' M'")

        print(f"Available space - default: {default_avail}MB, custom: {custom_avail}MB, minimal: {minimal_avail}MB")

        # Custom (1G) should have more space than default (512M)
        assert int(custom_avail) > int(default_avail), \
            f"Custom space ({custom_avail}MB) should exceed default ({default_avail}MB)"

        # Default (512M) should have more space than minimal (64M)
        assert int(default_avail) > int(minimal_avail), \
            f"Default space ({default_avail}MB) should exceed minimal ({minimal_avail}MB)"
  '';
}
