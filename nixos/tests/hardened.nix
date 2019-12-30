import ./make-test-python.nix ({ pkgs, latestKernel ? false, ...} : {
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
      import re

      machine.wait_for_unit("multi-user.target")

      with subtest("apparmor.service is loaded"):
          machine.succeed("systemctl status apparmor.service")

      with subtest("AppArmor securityfs is mounted"):
          machine.succeed("mountpoint -q /sys/kernel/security")
          machine.succeed("cat /sys/kernel/security/apparmor/profiles")

      with subtest("out-of-tree modules can be loaded"):
          machine.succeed("grep -Fq wireguard /proc/modules")

      with subtest("hidepid=2 option"):
          machine.succeed("grep -Fq hidepid=2 /proc/mounts")
          # cannot use pgrep -u here, it segfaults when access to process info is denied
          machine.succeed("[ `su - sybil -c 'ps --no-headers --user root | wc -l'` = 0 ]")
          machine.succeed("[ `su - alice -c 'ps --no-headers --user root | wc -l'` != 0 ]")

      with subtest("kernel module hardening"):
          # note: this better a be module we normally wouldn't load ...
          machine.fail("modprobe dccp")

      with subtest("userns"):
          machine.succeed("unshare --user true")
          machine.fail("su -l alice -c 'unshare --user true'")

      with subtest("dmesg restriction"):
          machine.fail("su -l alice -c dmesg")

      with subtest("access to kcore"):
          machine.fail("cat /proc/kcore")

      with subtest("deferred mount"):
          machine.fail("mountpoint -q /efi")
          # was deferred
          machine.execute("mkdir -p /efi")
          machine.succeed("mount /dev/disk/by-label/EFISYS /efi")
          machine.succeed("mountpoint -q /efi")
          # now mounted

      with subtest("nix daemon usage"):
          machine.fail("su -l nobody -s /bin/sh -c 'nix ping-store'")
          assert re.search("OK", machine.succeed("su -l alice -c 'nix ping-store'"))

      with subtest("kernel image protection"):
          machine.fail("systemctl hibernate")
          machine.fail("systemctl kexec")


      def run_malloc_test_prog(prog_name, error_text):
          text = f"fatal allocator error: {error_text}"
          assert re.search(
              text,
              machine.fail(
                  f"${hardened-malloc-tests}/bin/{prog_name}"
              ),
          )


      with subtest("Hardened memory allocator"):
          run_malloc_test_prog("double_free_large", "invalid free")
          run_malloc_test_prog("unaligned_free_small", "invalid unaligned free")
          run_malloc_test_prog("write_after_free_small", "detected write after free")
    '';
})
