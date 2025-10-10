{ pkgs, ... }:
{
  name = "hardened";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ joachifm ];
  };

  nodes.machine =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    {
      users.users.alice = {
        isNormalUser = true;
        extraGroups = [ "proc" ];
      };
      users.users.sybil = {
        isNormalUser = true;
        group = "wheel";
      };
      imports = [ ../modules/profiles/hardened.nix ];
      environment.memoryAllocator.provider = "graphene-hardened";
      nix.settings.sandbox = false;
      virtualisation.emptyDiskImages = [
        {
          size = 4096;
          driveConfig.deviceExtraOpts.serial = "deferred";
        }
      ];
      virtualisation.fileSystems = {
        "/deferred" = {
          device = "/dev/disk/by-id/virtio-deferred";
          fsType = "vfat";
          autoFormat = true;
          options = [ "noauto" ];
        };
      };
      boot.extraModulePackages = pkgs.lib.optional (pkgs.lib.versionOlder config.boot.kernelPackages.kernel.version "5.6") config.boot.kernelPackages.wireguard;
      boot.kernelModules = [ "wireguard" ];
    };

  testScript =
    let
      hardened-malloc-tests = pkgs.graphene-hardened-malloc.ld-preload-tests;
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


      # Test kernel module hardening
      with subtest("No more kernel modules can be loaded"):
          # note: this better a be module we normally wouldn't load ...
          machine.wait_for_unit("disable-kernel-module-loading.service")
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
          machine.fail("mountpoint -q /deferred")  # was deferred
          machine.systemctl("start deferred.mount")
          machine.succeed("mountpoint -q /deferred")  # now mounted


      # Test Nix dæmon usage
      with subtest("nix-daemon cannot be used by all users"):
          machine.fail("su -l nobody -s /bin/sh -c 'nix --extra-experimental-features nix-command ping-store'")
          machine.succeed("su -l alice -c 'nix --extra-experimental-features nix-command ping-store'")


      # Test kernel image protection
      with subtest("The kernel image is protected"):
          machine.fail("systemctl hibernate")
          machine.fail("systemctl kexec")


      with subtest("The hardened memory allocator works"):
          machine.succeed("${hardened-malloc-tests}/bin/run-tests")
    '';
}
