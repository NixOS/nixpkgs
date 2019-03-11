import ./make-test.nix ({ lib, ... }:
{
  name = "bees";

  machine = { config, pkgs, ... }: {
    boot.initrd.postDeviceCommands = ''
      ${pkgs.btrfs-progs}/bin/mkfs.btrfs -f -L aux1 /dev/vdb
      ${pkgs.btrfs-progs}/bin/mkfs.btrfs -f -L aux2 /dev/vdc
    '';
    virtualisation.emptyDiskImages = [ 4096 4096 ];
    fileSystems = lib.mkVMOverride {
      "/aux1" = { # filesystem configured to be deduplicated
        device = "/dev/disk/by-label/aux1";
        fsType = "btrfs";
      };
      "/aux2" = { # filesystem not configured to be deduplicated
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
    withRetry = content: maxTests: sleepTime: ''
      max_tests=${lib.escapeShellArg maxTests}; sleep_time=${lib.escapeShellArg sleepTime}; for ((i=0; i<max_tests; i++)); do ${content} && exit 0; sleep "$sleep_time"; done; exit 1;
    '';
    someContentIsShared = loc: ''[[ $(btrfs fi du -s --raw ${lib.escapeShellArg loc}/dedup-me-{1,2} | awk 'BEGIN { count=0; } NR>1 && $3 == 0 { count++ } END { print count }') -eq 0 ]]'';
  in ''
    # shut down the instance started by systemd at boot, so we can test our test procedure
    $machine->succeed("systemctl stop beesd\@aux1.service");

    $machine->succeed("dd if=/dev/urandom of=/aux1/dedup-me-1 bs=1M count=8");
    $machine->succeed("cp --reflink=never /aux1/dedup-me-1 /aux1/dedup-me-2");
    $machine->succeed("cp --reflink=never /aux1/* /aux2/");
    $machine->succeed("sync");
    $machine->fail(q(${someContentIsShared "/aux1"}));
    $machine->fail(q(${someContentIsShared "/aux2"}));
    $machine->succeed("systemctl start beesd\@aux1.service");

    # assert that "Set Shared" column is nonzero
    $machine->succeed(q(${withRetry (someContentIsShared "/aux1") 20 2}));
    $machine->fail(q(${someContentIsShared "/aux2"}));

    # assert that 16MB hash table size requested was honored
    $machine->succeed(q([[ $(stat -c %s /aux1/.beeshome/beeshash.dat) = $(( 16 * 1024 * 1024)) ]]))
  '';
})
