import ../make-test-python.nix (
  {
    pkgs,
    lib,
    incus ? pkgs.incus-lts,
    ...
  }:

  {
    name = "incus-storage";

    meta = {
      maintainers = lib.teams.lxc.members;
    };

    nodes.machine =
      { lib, ... }:
      {
        boot.supportedFilesystems = [ "zfs" ];
        boot.zfs.forceImportRoot = false;
        environment.systemPackages = [ pkgs.parted ];
        networking.hostId = "01234567";
        networking.nftables.enable = true;

        virtualisation = {
          emptyDiskImages = [ 2048 ];
          incus = {
            enable = true;
            package = incus;
          };
        };
      };

    testScript = ''
      machine.wait_for_unit("incus.service")

      with subtest("Verify zfs pool created and usable"):
        machine.succeed(
            "zpool status",
            "parted --script /dev/vdb mklabel gpt",
            "zpool create zfs_pool /dev/vdb",
        )

        machine.succeed("incus storage create zfs_pool zfs source=zfs_pool/incus")
        machine.succeed("zfs list zfs_pool/incus")
        machine.succeed("incus storage volume create zfs_pool test_fs --type filesystem")
        machine.succeed("incus storage volume create zfs_pool test_vol --type block")
        machine.succeed("incus storage show zfs_pool")
        machine.succeed("incus storage volume list zfs_pool")
        machine.succeed("incus storage volume show zfs_pool test_fs")
        machine.succeed("incus storage volume show zfs_pool test_vol")
    '';
  }
)
