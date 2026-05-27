{ lib, pkgs, ... }:
{
  name = "systemd-initrd-btrfs-raid";

  nodes.machine =
    { pkgs, ... }:
    {
      # Use systemd-boot
      virtualisation = {
        emptyDiskImages = [
          512
          512
        ];
        useBootLoader = true;
        # Booting off the BTRFS RAID requires an available init script from the Nix store
        mountHostNixStore = true;
        useEFIBoot = true;
      };
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      environment.systemPackages = with pkgs; [ btrfs-progs ];
      boot.initrd.systemd = {
        enable = true;
        emergencyAccess = true;
      };

      specialisation.boot-btrfs-raid.configuration = {
        fileSystems = lib.mkVMOverride {
          "/".fsType = lib.mkForce "btrfs";
        };
        virtualisation.rootDevice = "/dev/vdb";
      };
    };

  testScript = ''
    # Create RAID
    machine.succeed("mkfs.btrfs -d raid0 /dev/vdb /dev/vdc")
    machine.succeed("mkdir -p /mnt && mount /dev/vdb /mnt && echo hello > /mnt/test && umount /mnt")

    # Boot from the RAID
    machine.succeed("bootctl set-default nixos-generation-1-specialisation-boot-btrfs-raid.conf")
    machine.succeed("sync")
    machine.crash()
    machine.wait_for_unit("multi-user.target")

    # Ensure we have successfully booted from the RAID
    assert "(initrd)" in machine.succeed("systemd-analyze")  # booted with systemd in stage 1
    assert "/dev/vdb on / type btrfs" in machine.succeed("mount")
    assert "hello" in machine.succeed("cat /test")
    assert "Total devices 2" in machine.succeed("btrfs filesystem show")
  '';
}
