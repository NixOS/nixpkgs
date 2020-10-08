import ./make-test-python.nix ({ pkgs, latestKernel ? false, ... } : {
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
      machine.wait_for_unit("multi-user.target")


      with subtest("AppArmor profiles are loaded"):
          machine.succeed("systemctl status apparmor.service")


      # AppArmor securityfs
      with subtest("AppArmor securityfs is mounted"):
          machine.succeed("mountpoint -q /sys/kernel/security")
          machine.succeed("cat /sys/kernel/security/apparmor/profiles")


      # Test loading out-of-tree modules
      with subtest("Out-of-tree modules can be loaded"):
          machine.succeed("grep -Fq wireguard /proc/modules")


      # Test hidepid
      with subtest("hidepid=2 option is applied and works"):
          # Linux >= 5.8 shows "invisible"
          machine.succeed(
              "grep -Fq hidepid=2 /proc/mounts || grep -Fq hidepid=invisible /proc/mounts"
          )
          # cannot use pgrep -u here, it segfaults when access to process info is denied
          machine.succeed("[ `su - sybil -c 'ps --no-headers --user root | wc -l'` = 0 ]")
          machine.succeed("[ `su - alice -c 'ps --no-headers --user root | wc -l'` != 0 ]")


      # Test kernel module hardening
      with subtest("No more kernel modules can be loaded"):
          # note: this better a be module we normally wouldn't load ...
          machine.fail("modprobe dccp")


      # Test userns
      with subtest("User namespaces are restricted"):
          machine.succeed("unshare --user true")
          machine.fail("su -l alice -c 'unshare --user true'")


      # Test dmesg restriction
      with subtest("Regular users cannot access dmesg"):
          machine.fail("su -l alice -c dmesg")


      # Test access to kcore
      with subtest("Kcore is inaccessible as root"):
          machine.fail("cat /proc/kcore")


      # Test deferred mount
      with subtest("Deferred mounts work"):
          machine.fail("mountpoint -q /efi")  # was deferred
          machine.execute("mkdir -p /efi")
          machine.succeed("mount /dev/disk/by-label/EFISYS /efi")
          machine.succeed("mountpoint -q /efi")  # now mounted


      # Test Nix dæmon usage
      with subtest("nix-daemon cannot be used by all users"):
          machine.fail("su -l nobody -s /bin/sh -c 'nix ping-store'")
          machine.succeed("su -l alice -c 'nix ping-store'")


      # Test kernel image protection
      with subtest("The kernel image is protected"):
          machine.fail("systemctl hibernate")
          machine.fail("systemctl kexec")


      # Test hardened memory allocator
      def runMallocTestProg(prog_name, error_text):
          text = "fatal allocator error: " + error_text
          if not text in machine.fail(
              "${hardened-malloc-tests}/bin/"
              + prog_name
              + " 2>&1"
          ):
              raise Exception("Hardened malloc does not work for {}".format(error_text))


      with subtest("The hardened memory allocator works"):
          runMallocTestProg("double_free_large", "invalid free")
          runMallocTestProg("unaligned_free_small", "invalid unaligned free")
          runMallocTestProg("write_after_free_small", "detected write after free")
    '';
})
