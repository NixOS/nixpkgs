{ lib, pkgs, ... }:
{
  name = "systemd-initrd-swraid";

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
        # Booting off the RAID requires an available init script
        mountHostNixStore = true;
        useEFIBoot = true;
      };
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      environment.systemPackages = with pkgs; [
        mdadm
        e2fsprogs
      ]; # for mdadm and mkfs.ext4
      boot.swraid.enable = true;
      environment.etc."mdadm.conf".text = ''
        MAILADDR test@example.com
      '';
      boot.initrd = {
        systemd = {
          enable = true;
          emergencyAccess = true;
        };
        kernelModules = [ "raid0" ];
      };

      specialisation.boot-swraid.configuration.virtualisation.rootDevice = "/dev/disk/by-label/testraid";
      # This protects against a regression. We do not have to switch to it.
      # It's sufficient to trigger its evaluation.
      specialisation.build-old-initrd.configuration.boot.initrd.systemd.enable = lib.mkForce false;
    };

  testScript = ''
    # Create RAID
    machine.succeed("mdadm --create --force /dev/md0 -n 2 --level=raid1 /dev/vdb /dev/vdc --metadata=0.90 --bitmap=internal")
    machine.succeed("mkfs.ext4 -L testraid /dev/md0")
    machine.succeed("mkdir -p /mnt && mount /dev/md0 /mnt && echo hello > /mnt/test && umount /mnt")

    # Boot from the RAID
    machine.succeed("bootctl set-default nixos-generation-1-specialisation-boot-swraid.conf")
    machine.succeed("sync")
    machine.crash()
    machine.wait_for_unit("multi-user.target")

    # Ensure we have successfully booted from the RAID
    assert "(initrd)" in machine.succeed("systemd-analyze")  # booted with systemd in stage 1
    assert "/dev/md0 on / type ext4" in machine.succeed("mount")
    assert "hello" in machine.succeed("cat /test")
    assert "md0" in machine.succeed("cat /proc/mdstat")

    # Verify the RAID array was properly auto-detected and assembled
    detail = machine.succeed("mdadm --detail /dev/md0")
    assert "raid1" in detail, f"Expected raid1 in mdadm detail output: {detail}"
    assert "/dev/vdb" in detail, f"Expected /dev/vdb in array: {detail}"
    assert "/dev/vdc" in detail, f"Expected /dev/vdc in array: {detail}"

    machine.wait_for_unit("mdmonitor.service")
  '';
}
