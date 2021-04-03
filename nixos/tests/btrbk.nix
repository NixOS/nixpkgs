import ./make-test-python.nix ({ pkgs, ... }:

let
  btrfsRoot = "/run/important_files";
  testData = "testdata";
in
  {
   machine =
    { config, pkgs, ... }:
    {

      environment.systemPackages = with pkgs; [ btrfs-progs ];
      services.btrbk = {
        enable = true;
          volumes."${btrfsRoot}" = {
            subvolumes = { "data" = {
                  snapshotDir = "snapshots";
                  snapshotName = "all_my_data";
                };
              };
            targets = { "${btrfsRoot}/backup" = {}; };
            extraOptions = ''
              # test_line 1
              # test_line 2
            '';
          };
      };
    };

    testScript =
      ''
        # eliminate time as an unwanted side effect
        machine.succeed("timedatectl set-time '00:00:00'")

        # create the btrfs pool
        machine.succeed("dd if=/dev/zero of=/data_fs bs=120M count=1")
        machine.succeed("mkfs.btrfs /data_fs")
        machine.succeed("mkdir -p ${btrfsRoot}")
        machine.succeed("mount /data_fs ${btrfsRoot}")
        machine.succeed("btrfs subvolume create ${btrfsRoot}/snapshots")
        machine.succeed("btrfs subvolume create ${btrfsRoot}/data")
        machine.succeed("btrfs subvolume create ${btrfsRoot}/backup")

        # print the config file
        machine.succeed("cat /etc/btrbk/btrbk.conf 1>&2")

        # run the backup
        machine.succeed("echo ${testData} > ${btrfsRoot}/data/testfile")
        machine.succeed("btrbk --Version")
        machine.succeed("btrbk run 1>&2")

        backup = "${btrfsRoot}/backup/*/testfile"
        data = "${btrfsRoot}/data/testfile"
        machine.succeed("diff " + backup + " " + data)
      '';
  })
