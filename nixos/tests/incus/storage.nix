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

    nodes.machine = {
      boot.supportedFilesystems = [ "zfs" ];
      boot.zfs.forceImportRoot = false;

      environment.systemPackages = [ pkgs.parted ];

      networking.hostId = "01234567";
      networking.nftables.enable = true;

      services.lvm = {
        boot.thin.enable = true;
        dmeventd.enable = true;
      };

      virtualisation = {
        emptyDiskImages = [
          2048
          2048
        ];
        incus = {
          enable = true;
          package = incus;
        };
      };
    };

    testScript = # python
      ''
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

            machine.succeed("incus create zfs1 --empty --storage zfs_pool")
            machine.succeed("incus list zfs1")

        with subtest("Verify lvm pool created and usable"):
            machine.succeed("incus storage create lvm_pool lvm source=/dev/vdc lvm.vg_name=incus_pool")
            machine.succeed("vgs incus_pool")

            machine.succeed("incus storage volume create lvm_pool test_fs --type filesystem")
            machine.succeed("incus storage volume create lvm_pool test_vol --type block")

            machine.succeed("incus storage show lvm_pool")

            machine.succeed("incus storage volume list lvm_pool")
            machine.succeed("incus storage volume show lvm_pool test_fs")
            machine.succeed("incus storage volume show lvm_pool test_vol")

            machine.succeed("incus create lvm1 --empty --storage zfs_pool")
            machine.succeed("incus list lvm1")
      '';
  }
)
