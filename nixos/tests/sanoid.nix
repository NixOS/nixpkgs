{ pkgs, ... }:
let
  inherit (import ./ssh-keys.nix pkgs)
    snakeOilPrivateKey
    snakeOilPublicKey
    ;

  commonConfig =
    { pkgs, ... }:
    {
      virtualisation.emptyDiskImages = [ 2048 ];
      boot.supportedFilesystems = [ "zfs" ];
      environment.systemPackages = [ pkgs.parted ];
    };
in
{
  name = "sanoid";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ lopsided98 ];
  };

  nodes = {
    source =
      { ... }:
      {
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
          datasets."pool/compat".useTemplate = [ "test" ];
          extraArgs = [ "--verbose" ];
        };

        services.syncoid = {
          enable = true;
          sshKey = "/var/lib/syncoid/id_ecdsa";
          commands = {
            # Sync snapshot taken by sanoid
            "pool/sanoid" = {
              target = "root@target:pool/sanoid";
              extraArgs = [
                "--no-sync-snap"
                "--create-bookmark"
              ];
            };
            # Take snapshot and sync
            "pool/syncoid".target = "root@target:pool/syncoid";
            # Test to make sure two commands can use the same dataset
            "pool/syncoid2" = {
              source = "pool/syncoid";
              target = "root@target:pool/syncoid2";
              extraArgs = [
                "--identifier"
                "syncoid2"
              ];
            };
            # Test to make sure two commands can use the same dataset with different permissions
            "pool/syncoid3" = {
              source = "pool/syncoid";
              target = "root@target:pool/syncoid3";
              extraArgs = [
                "--identifier"
                "syncoid3"
              ];
              localSourceAllow = [
                "bookmark"
                "hold"
                "send"
                "snapshot"
                "destroy"
                "mount"
                "rollback"
              ];
            };

            # Test pool without parent (regression test for https://github.com/NixOS/nixpkgs/pull/180111)
            "pool".target = "root@target:pool/full-pool";

            # Test backward compatible options (regression test for https://github.com/NixOS/nixpkgs/issues/181561)
            "pool/compat" = {
              target = "root@target:pool/compat";
              extraArgs = [ "--no-sync-snap" ];
            };
          };
        };
      };
    target =
      { ... }:
      {
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
        "zfs create pool/compat",
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
    source.succeed("touch /mnt/pool/compat/test.txt")
    source.systemctl("start --wait sanoid.service")

    assert len(source.succeed("zfs allow pool")) == 0, "Pool shouldn't have delegated permissions set after snapshotting"
    assert len(source.succeed("zfs allow pool/sanoid")) == 0, "Sanoid dataset shouldn't have delegated permissions set after snapshotting"
    assert len(source.succeed("zfs allow pool/syncoid")) == 0, "Syncoid dataset shouldn't have delegated permissions set after snapshotting"

    # Sync snapshots
    target.wait_for_open_port(22)
    source.succeed("touch /mnt/pool/syncoid/test.txt")
    source.systemctl("start --wait syncoid-pool-sanoid.service")
    target.succeed("cat /mnt/pool/sanoid/test.txt")
    source.systemctl("start --wait syncoid-pool-syncoid.service syncoid-pool-syncoid2.service syncoid-pool-syncoid3.service")
    source.systemctl("start --wait syncoid-pool-syncoid.service syncoid-pool-syncoid2.service syncoid-pool-syncoid3.service")
    target.succeed("cat /mnt/pool/syncoid/test.txt")
    target.succeed("cat /mnt/pool/syncoid2/test.txt")
    target.succeed("cat /mnt/pool/syncoid3/test.txt")

    assert(len(source.succeed("zfs list -H -t snapshot pool/syncoid").splitlines()) == 3), "Syncoid should only retain one sync snapshot for each command"

    source.systemctl("start --wait syncoid-pool.service")
    target.succeed("[[ -d /mnt/pool/full-pool/syncoid ]]")

    source.systemctl("start --wait syncoid-pool-compat.service")
    target.succeed("cat /mnt/pool/compat/test.txt")

    assert len(source.succeed("zfs allow pool")) == 0, "Pool shouldn't have delegated permissions set after syncing snapshots"
    assert len(source.succeed("zfs allow pool/sanoid")) == 0, "Sanoid dataset shouldn't have delegated permissions set after syncing snapshots"
    assert len(source.succeed("zfs allow pool/syncoid")) == 0, "Syncoid dataset shouldn't have delegated permissions set after syncing snapshots"
  '';
}
