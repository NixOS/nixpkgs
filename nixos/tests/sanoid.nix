import ./make-test-python.nix (
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
              # Take snapshot and sync
              "pool/syncoid".target = "root@target:pool/syncoid";

              # Sync the same dataset to different targets
              "pool/sanoid1" = {
                source = "pool/sanoid";
                target = "root@target:pool/sanoid1";
                extraArgs = [
                  "--no-sync-snap"
                  "--create-bookmark"
                ];
              };
              "pool/sanoid2" = {
                source = "pool/sanoid";
                target = "root@target:pool/sanoid2";
                extraArgs = [
                  "--no-sync-snap"
                  "--create-bookmark"
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
      )

      with subtest("Take snapshots with sanoid"):
        source.succeed("touch /mnt/pool/sanoid/test.txt")
        source.succeed("touch /mnt/pool/compat/test.txt")
        source.systemctl("start --wait sanoid.service")

      # Add some unused dynamic users to the stateful allow list of ZFS datasets,
      # simulating a state where they remain after the system crashed,
      # to check they'll be correctly removed by the syncoid services.
      # Each syncoid service run from now may reuse at most one of them for itself.
      source.succeed(
          "zfs allow -u $(printf %s, {61184..61200})65519 dedup pool",
          "zfs allow -u $(printf %s, {61184..61200})65519 dedup pool/sanoid",
          "zfs allow -u $(printf %s, {61184..61200})65519 dedup pool/syncoid",
      )

      with subtest("sync snapshots"):
        target.wait_for_open_port(22)
        source.succeed("touch /mnt/pool/syncoid/test.txt")

        source.systemctl("start --wait syncoid-pool-syncoid.service")
        target.succeed("cat /mnt/pool/syncoid/test.txt")

        source.systemctl("start --wait syncoid-pool-sanoid{1,2}.service")
        target.succeed("cat /mnt/pool/sanoid1/test.txt")
        target.succeed("cat /mnt/pool/sanoid2/test.txt")

        source.systemctl("start --wait syncoid-pool.service")
        target.succeed("[[ -d /mnt/pool/full-pool/syncoid ]]")

        source.systemctl("start --wait syncoid-pool-compat.service")
        target.succeed("cat /mnt/pool/compat/test.txt")

      assert len(source.succeed("zfs allow pool")) == 0, "Pool shouldn't have delegated permissions set after snapshotting"
      assert len(source.succeed("zfs allow pool/sanoid")) == 0, "Sanoid dataset shouldn't have delegated permissions set after snapshotting"
      assert len(source.succeed("zfs allow pool/syncoid")) == 0, "Syncoid dataset shouldn't have delegated permissions set after snapshotting"
      assert(len(source.succeed("zfs list -H -t snapshot pool/syncoid").splitlines()) == 1), "Syncoid should only retain one sync snapshot"

    '';
  }
)
