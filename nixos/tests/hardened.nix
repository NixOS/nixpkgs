import ./make-test.nix ({ pkgs, latestKernel ? false, ... } : {
  name = "hardened";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ joachifm ];
  };

  machine =
    { lib, pkgs, config, ... }:
    with lib;
    { users.users.alice = { isNormalUser = true; extraGroups = [ "proc" ]; };
      users.users.sybil = { isNormalUser = true; group = "wheel"; };
      imports = [ ../modules/profiles/hardened.nix ];
      boot.kernelPackages =
        lib.mkIf latestKernel pkgs.linuxPackages_latest_hardened;
      environment.memoryAllocator.provider = "graphene-hardened";
      nix.useSandbox = false;
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
      boot.extraModulePackages =
        optional (versionOlder config.boot.kernelPackages.kernel.version "5.6")
          config.boot.kernelPackages.wireguard;
      boot.kernelModules = [ "wireguard" ];
    };

  testScript =
    let
      hardened-malloc-tests = pkgs.stdenv.mkDerivation {
        name = "hardened-malloc-tests-${pkgs.graphene-hardened-malloc.version}";
        src = pkgs.graphene-hardened-malloc.src;
        buildPhase = ''
          cd test/simple-memory-corruption
          make -j4
        '';

        installPhase = ''
          find . -type f -executable -exec install -Dt $out/bin '{}' +
        '';
      };
    in
    ''
      $machine->waitForUnit("multi-user.target");

      subtest "apparmor-loaded", sub {
          $machine->succeed("systemctl status apparmor.service");
      };

      # AppArmor securityfs
      subtest "apparmor-securityfs", sub {
          $machine->succeed("mountpoint -q /sys/kernel/security");
          $machine->succeed("cat /sys/kernel/security/apparmor/profiles");
      };

      # Test loading out-of-tree modules
      subtest "extra-module-packages", sub {
          $machine->succeed("grep -Fq wireguard /proc/modules");
      };

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
          $machine->succeed("unshare --user true");
          $machine->fail("su -l alice -c 'unshare --user true'");
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

      # Test Nix dæmon usage
      subtest "nix-daemon", sub {
        $machine->fail("su -l nobody -s /bin/sh -c 'nix ping-store'");
        $machine->succeed("su -l alice -c 'nix ping-store'") =~ "OK";
      };

      # Test kernel image protection
      subtest "kernelimage", sub {
        $machine->fail("systemctl hibernate");
        $machine->fail("systemctl kexec");
      };

      # Test hardened memory allocator
      sub runMallocTestProg {
          my ($progName, $errorText) = @_;
          my $text = "fatal allocator error: " . $errorText;
          $machine->fail("${hardened-malloc-tests}/bin/" . $progName) =~ $text;
      };

      subtest "hardenedmalloc", sub {
        runMallocTestProg("double_free_large", "invalid free");
        runMallocTestProg("unaligned_free_small", "invalid unaligned free");
        runMallocTestProg("write_after_free_small", "detected write after free");
      };
    '';
})
