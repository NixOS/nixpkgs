import ./make-test-python.nix (
  { lib, pkgs, ... }:
  {
    name = "bees";

    nodes.machine =
      { config, pkgs, ... }:
      {
        boot.initrd.postDeviceCommands = ''
          ${pkgs.btrfs-progs}/bin/mkfs.btrfs -f -L aux1 /dev/vdb
          ${pkgs.btrfs-progs}/bin/mkfs.btrfs -f -L aux2 /dev/vdc
        '';
        virtualisation.emptyDiskImages = [
          4096
          4096
        ];
        virtualisation.fileSystems = {
          "/aux1" = {
            # filesystem configured to be deduplicated
            device = "/dev/disk/by-label/aux1";
            fsType = "btrfs";
          };
          "/aux2" = {
            # filesystem not configured to be deduplicated
            device = "/dev/disk/by-label/aux2";
            fsType = "btrfs";
          };
        };
        services.beesd.filesystems = {
          aux1 = {
            spec = "LABEL=aux1";
            hashTableSizeMB = 16;
            verbosity = "debug";
          };
        };
      };

    testScript =
      let
        someContentIsShared =
          loc:
          pkgs.writeShellScript "some-content-is-shared" ''
            [[ $(btrfs fi du -s --raw ${lib.escapeShellArg loc}/dedup-me-{1,2} | awk 'BEGIN { count=0; } NR>1 && $3 == 0 { count++ } END { print count }') -eq 0 ]]
          '';
      in
      ''
        # shut down the instance started by systemd at boot, so we can test our test procedure
        machine.succeed("systemctl stop beesd@aux1.service")

        machine.succeed(
            "dd if=/dev/urandom of=/aux1/dedup-me-1 bs=1M count=8",
            "cp --reflink=never /aux1/dedup-me-1 /aux1/dedup-me-2",
            "cp --reflink=never /aux1/* /aux2/",
            "sync",
        )
        machine.fail(
            "${someContentIsShared "/aux1"}",
            "${someContentIsShared "/aux2"}",
        )
        machine.succeed("systemctl start beesd@aux1.service")

        # assert that "Set Shared" column is nonzero
        machine.wait_until_succeeds(
            "${someContentIsShared "/aux1"}",
        )
        machine.fail("${someContentIsShared "/aux2"}")

        # assert that 16MB hash table size requested was honored
        machine.succeed(
            "[[ $(stat -c %s /aux1/.beeshome/beeshash.dat) = $(( 16 * 1024 * 1024)) ]]"
        )
      '';
  }
)
