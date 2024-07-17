import ./make-test-python.nix (
  { pkgs, ... }:
  {
    name = "libvirtd";
    meta.maintainers = with pkgs.lib.maintainers; [ fpletz ];

    nodes = {
      virthost =
        { pkgs, ... }:
        {
          virtualisation = {
            cores = 2;
            memorySize = 2048;

            libvirtd.enable = true;
            libvirtd.hooks.qemu.is_working = "${pkgs.writeShellScript "testHook.sh" ''
              touch /tmp/qemu_hook_is_working
            ''}";
            libvirtd.nss.enable = true;
          };
          boot.supportedFilesystems = [ "zfs" ];
          networking.hostId = "deadbeef"; # needed for zfs
          security.polkit.enable = true;
          environment.systemPackages = with pkgs; [ virt-manager ];

          # This adds `resolve` to the `hosts` line of /etc/nsswitch.conf; NSS modules placed after it
          # will not be consulted. Therefore this tests that the libvirtd NSS modules will be
          # be placed early enough for name resolution to work.
          services.resolved.enable = true;
        };
    };

    testScript =
      let
        nixosInstallISO = (import ../release.nix { }).iso_minimal.${pkgs.stdenv.hostPlatform.system};
        virshShutdownCmd = if pkgs.stdenv.isx86_64 then "shutdown" else "destroy";
      in
      ''
        start_all()

        virthost.wait_for_unit("multi-user.target")

        with subtest("enable default network"):
          virthost.succeed("virsh net-start default")
          virthost.succeed("virsh net-autostart default")
          virthost.succeed("virsh net-info default")

        with subtest("check if partition disk pools works with parted"):
          virthost.succeed("fallocate -l100m /tmp/foo; losetup /dev/loop0 /tmp/foo; echo 'label: dos' | sfdisk /dev/loop0")
          virthost.succeed("virsh pool-create-as foo disk --source-dev /dev/loop0 --target /dev")
          virthost.succeed("virsh vol-create-as foo loop0p1 25MB")
          virthost.succeed("virsh vol-create-as foo loop0p2 50MB")

        with subtest("check if virsh zfs pools work"):
          virthost.succeed("fallocate -l100m /tmp/zfs; losetup /dev/loop1 /tmp/zfs;")
          virthost.succeed("zpool create zfs_loop /dev/loop1")
          virthost.succeed("virsh pool-define-as --name zfs_storagepool --source-name zfs_loop --type zfs")
          virthost.succeed("virsh pool-start zfs_storagepool")
          virthost.succeed("virsh vol-create-as zfs_storagepool disk1 25MB")

        with subtest("check if nixos install iso boots, network and autostart works"):
          virthost.succeed(
            "virt-install -n nixos --osinfo nixos-unstable --memory 1024 --graphics none --disk `find ${nixosInstallISO}/iso -type f | head -n1`,readonly=on --import --noautoconsole --autostart"
          )
          virthost.succeed("virsh domstate nixos | grep running")
          virthost.wait_until_succeeds("ping -c 1 nixos")
          virthost.succeed("virsh ${virshShutdownCmd} nixos")
          virthost.wait_until_succeeds("virsh domstate nixos | grep 'shut off'")
          virthost.shutdown()
          virthost.wait_for_unit("multi-user.target")
          virthost.wait_until_succeeds("ping -c 1 nixos")

        with subtest("test if hooks are linked and run"):
          virthost.succeed("ls /var/lib/libvirt/hooks/qemu.d/is_working")
          virthost.succeed("ls /tmp/qemu_hook_is_working")
      '';
  }
)
