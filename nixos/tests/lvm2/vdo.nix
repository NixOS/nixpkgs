{ kernelPackages ? null }:
import ../make-test-python.nix ({ pkgs, lib, ... }: {
  name = "lvm2-vdo";
  meta.maintainers = lib.teams.helsinki-systems.members;

  nodes.machine = { pkgs, lib, ... }: {
    # Minimum required size for VDO volume: 5063921664 bytes
    virtualisation.emptyDiskImages = [ 8192 ];
    services.lvm = {
      boot.vdo.enable = true;
      dmeventd.enable = true;
    };
    environment.systemPackages = with pkgs; [ xfsprogs ];
    boot = lib.mkIf (kernelPackages != null) { inherit kernelPackages; };
  };

  testScript = ''
    machine.succeed("vgcreate test_vg /dev/vdb")
    machine.succeed("lvcreate --type vdo -n vdo_lv -L 6G -V 12G test_vg/vdo_pool_lv")
    machine.succeed("mkfs.xfs -K /dev/test_vg/vdo_lv")
    machine.succeed("mkdir /mnt; mount /dev/test_vg/vdo_lv /mnt")
    assert "/dev/mapper/test_vg-vdo_lv" == machine.succeed("findmnt -no SOURCE /mnt").strip()
    machine.succeed("umount /mnt")
    machine.succeed("vdostats")
    machine.succeed("vgchange -a n")
  '';
})
