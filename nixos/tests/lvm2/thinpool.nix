{ kernelPackages ? null }:
import ../make-test-python.nix ({ pkgs, ... }: {
  name = "lvm2-thinpool";
  meta.maintainers = with pkgs.lib.maintainers; [ ajs124 ];

  nodes.machine = { pkgs, lib, ... }: {
    virtualisation.emptyDiskImages = [ 4096 ];
    services.lvm = {
      boot.thin.enable = true;
      dmeventd.enable = true;
    };
    environment.systemPackages = with pkgs; [ xfsprogs ];
    environment.etc."lvm/lvm.conf".text = ''
      activation/thin_pool_autoextend_percent = 10
      activation/thin_pool_autoextend_threshold = 80
    '';
    boot = lib.mkIf (kernelPackages != null) { inherit kernelPackages; };
  };

  testScript = ''
    machine.succeed("vgcreate test_vg /dev/vdb")
    machine.succeed("lvcreate -L 512M -T test_vg/test_thin_pool")
    machine.succeed("lvcreate -n test_lv -V 16G --thinpool test_thin_pool test_vg")
    machine.succeed("mkfs.xfs /dev/test_vg/test_lv")
    machine.succeed("mkdir /mnt; mount /dev/test_vg/test_lv /mnt")
    assert "/dev/mapper/test_vg-test_lv" == machine.succeed("findmnt -no SOURCE /mnt").strip()
    machine.succeed("dd if=/dev/zero of=/mnt/empty.file bs=1M count=1024")
    machine.succeed("journalctl -u dm-event.service | grep \"successfully resized\"")
    machine.succeed("umount /mnt")
    machine.succeed("vgchange -a n")
  '';
})
