{ kernelPackages ? null }:
import ../make-test-python.nix ({ pkgs, lib, ... }: {
  name = "lvm2-thinpool";
  meta.maintainers = lib.teams.helsinki-systems.members;

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

  testScript = let
    mkXfsFlags = lib.optionalString (lib.versionOlder kernelPackages.kernel.version "5.10") "-m bigtime=0 -m inobtcount=0";
  in ''
    machine.succeed("vgcreate test_vg /dev/vdb")
    machine.succeed("lvcreate -L 512M -T test_vg/test_thin_pool")
    machine.succeed("lvcreate -n test_lv -V 16G --thinpool test_thin_pool test_vg")
    machine.succeed("mkfs.xfs ${mkXfsFlags} /dev/test_vg/test_lv")
    machine.succeed("mkdir /mnt; mount /dev/test_vg/test_lv /mnt")
    assert "/dev/mapper/test_vg-test_lv" == machine.succeed("findmnt -no SOURCE /mnt").strip()
    machine.succeed("dd if=/dev/zero of=/mnt/empty.file bs=1M count=1024")
    machine.succeed("journalctl -u dm-event.service | grep \"successfully resized\"")
    machine.succeed("umount /mnt")
    machine.succeed("vgchange -a n")
  '';
})
