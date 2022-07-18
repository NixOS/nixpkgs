import ./make-test-python.nix ({ lib, pkgs, ... }: {
  name = "systemd-initrd-swraid";

  nodes.machine = { pkgs, ... }: {
    # Use systemd-boot
    virtualisation = {
      emptyDiskImages = [ 512 512 ];
      useBootLoader = true;
      useEFIBoot = true;
    };
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    environment.systemPackages = with pkgs; [ mdadm e2fsprogs ]; # for mdadm and mkfs.ext4
    boot.initrd = {
      systemd = {
        enable = true;
        emergencyAccess = true;
      };
      services.swraid = {
        enable = true;
        mdadmConf = ''
          ARRAY /dev/md0 devices=/dev/vdc,/dev/vdd
        '';
      };
      kernelModules = [ "raid0" ];
    };

    specialisation.boot-swraid.configuration.virtualisation.bootDevice = "/dev/disk/by-label/testraid";
  };

  testScript = ''
    # Create RAID
    machine.succeed("mdadm --create --force /dev/md0 -n 2 --level=raid0 /dev/vdc /dev/vdd")
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
  '';
})
