import ./make-test.nix ({ pkgs, ...} : {
  name = "hardened";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ joachifm ];
  };

  machine =
    { lib, pkgs, ... }:
    with lib;
    { users.users.alice = { isNormalUser = true; extraGroups = [ "proc" ]; };
      users.users.sybil = { isNormalUser = true; group = "wheel"; };
      imports = [ ../modules/profiles/hardened.nix ];
      virtualisation.emptyDiskImages = [ 4096 ];
      boot.initrd.postDeviceCommands = ''
        ${pkgs.dosfstools}/bin/mkfs.vfat -n EFISYS /dev/vdb
      '';
      fileSystems = lib.mkVMOverride {
        "/efi" = {
          device = "/dev/disk/by-label/EFISYS";
          fsType = "vfat";
          options = [ "noauto" ];
        };
      };
    };

  testScript =
    ''
      $machine->waitForUnit("multi-user.target");

      # Test hidepid
      subtest "hidepid", sub {
          $machine->succeed("grep -Fq hidepid=2 /proc/mounts");
          # cannot use pgrep -u here, it segfaults when access to process info is denied
          $machine->succeed("[ `su - sybil -c 'ps --no-headers --user root | wc -l'` = 0 ]");
          $machine->succeed("[ `su - alice -c 'ps --no-headers --user root | wc -l'` != 0 ]");
      };

      # Test kernel module hardening
      subtest "lock-modules", sub {
          # note: this better a be module we normally wouldn't load ...
          $machine->fail("modprobe dccp");
      };

      # Test userns
      subtest "userns", sub {
          $machine->fail("unshare --user");
      };

      # Test dmesg restriction
      subtest "dmesg", sub {
          $machine->fail("su -l alice -c dmesg");
      };

      # Test access to kcore
      subtest "kcore", sub {
          $machine->fail("cat /proc/kcore");
      };

      # Test deferred mount
      subtest "mount", sub {
        $machine->fail("mountpoint -q /efi"); # was deferred
        $machine->execute("mkdir -p /efi");
        $machine->succeed("mount /dev/disk/by-label/EFISYS /efi");
        $machine->succeed("mountpoint -q /efi"); # now mounted
      };
    '';
})
