import ./make-test-python.nix ({ pkgs, ... }: let
  inherit (import ./ssh-keys.nix pkgs)
    snakeOilPrivateKey snakeOilPublicKey;

  commonConfig = { pkgs, ... }: {
    virtualisation.emptyDiskImages = [ 2048 ];
    boot.supportedFilesystems = [ "zfs" ];
    environment.systemPackages = [ pkgs.parted ];
  };
in {
  name = "sanoid";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ lopsided98 ];
  };

  nodes = {
    source = { ... }: {
      imports = [ commonConfig ];
      networking.hostId = "daa82e91";

      programs.ssh.extraConfig = ''
        UserKnownHostsFile=/dev/null
        StrictHostKeyChecking=no
      '';

      services.sanoid = {
        enable = true;
        templates.test = {
          hourly = 12;
          daily = 1;
          monthly = 1;
          yearly = 1;

          autosnap = true;
        };
        datasets."pool/sanoid".use_template = [ "test" ];
        extraArgs = [ "--verbose" ];
      };

      services.syncoid = {
        enable = true;
        sshKey = "/var/lib/syncoid/id_ecdsa";
        commands = {
          # Sync snapshot taken by sanoid
          "pool/sanoid" = {
            target = "root@target:pool/sanoid";
            extraArgs = [ "--no-sync-snap" "--create-bookmark" ];
          };
          # Take snapshot and sync
          "pool/syncoid".target = "root@target:pool/syncoid";
        };
      };
    };
    target = { ... }: {
      imports = [ commonConfig ];
      networking.hostId = "dcf39d36";

      services.openssh.enable = true;
      users.users.root.openssh.authorizedKeys.keys = [ snakeOilPublicKey ];
    };
  };

  testScript = ''
    source.succeed(
        "mkdir /mnt",
        "parted --script /dev/vdb -- mklabel msdos mkpart primary 1024M -1s",
        "udevadm settle",
        "zpool create pool -R /mnt /dev/vdb1",
        "zfs create pool/sanoid",
        "zfs create pool/syncoid",
        "udevadm settle",
    )
    target.succeed(
        "mkdir /mnt",
        "parted --script /dev/vdb -- mklabel msdos mkpart primary 1024M -1s",
        "udevadm settle",
        "zpool create pool -R /mnt /dev/vdb1",
        "udevadm settle",
    )

    source.succeed(
        "mkdir -m 700 -p /var/lib/syncoid",
        "cat '${snakeOilPrivateKey}' > /var/lib/syncoid/id_ecdsa",
        "chmod 600 /var/lib/syncoid/id_ecdsa",
        "chown -R syncoid:syncoid /var/lib/syncoid/",
    )

    assert len(source.succeed("zfs allow pool")) == 0, "Pool shouldn't have delegated permissions set before snapshotting"
    assert len(source.succeed("zfs allow pool/sanoid")) == 0, "Sanoid dataset shouldn't have delegated permissions set before snapshotting"
    assert len(source.succeed("zfs allow pool/syncoid")) == 0, "Syncoid dataset shouldn't have delegated permissions set before snapshotting"

    # Take snapshot with sanoid
    source.succeed("touch /mnt/pool/sanoid/test.txt")
    source.systemctl("start --wait sanoid.service")

    assert len(source.succeed("zfs allow pool")) == 0, "Pool shouldn't have delegated permissions set after snapshotting"
    assert len(source.succeed("zfs allow pool/sanoid")) == 0, "Sanoid dataset shouldn't have delegated permissions set after snapshotting"
    assert len(source.succeed("zfs allow pool/syncoid")) == 0, "Syncoid dataset shouldn't have delegated permissions set after snapshotting"

    # Sync snapshots
    target.wait_for_open_port(22)
    source.succeed("touch /mnt/pool/syncoid/test.txt")
    source.systemctl("start --wait syncoid-pool-sanoid.service")
    target.succeed("cat /mnt/pool/sanoid/test.txt")
    source.systemctl("start --wait syncoid-pool-syncoid.service")
    target.succeed("cat /mnt/pool/syncoid/test.txt")

    assert len(source.succeed("zfs allow pool")) == 0, "Pool shouldn't have delegated permissions set after syncing snapshots"
    assert len(source.succeed("zfs allow pool/sanoid")) == 0, "Sanoid dataset shouldn't have delegated permissions set after syncing snapshots"
    assert len(source.succeed("zfs allow pool/syncoid")) == 0, "Syncoid dataset shouldn't have delegated permissions set after syncing snapshots"
  '';
})
