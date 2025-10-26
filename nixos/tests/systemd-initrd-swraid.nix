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
      boot.swraid = {
        enable = true;
        mdadmConf = ''
          ARRAY /dev/md0 devices=/dev/vdb,/dev/vdc
        '';
      };
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

    expected_config = """MAILADDR test@example.com

    ARRAY /dev/md0 devices=/dev/vdb,/dev/vdc
    """
    got_config = machine.execute("cat /etc/mdadm.conf")[1]
    assert expected_config == got_config, repr((expected_config, got_config))
    machine.wait_for_unit("mdmonitor.service")
  '';
}
