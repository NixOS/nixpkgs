import ./make-test.nix {
  name = "fsck";

  machine = { lib, ... }: {
    virtualisation.emptyDiskImages = [ 1 ];

    fileSystems = lib.mkVMOverride {
      "/mnt" = {
        device = "/dev/vdb";
        fsType = "ext4";
        autoFormat = true;
      };
    };
  };

  testScript = ''
    $machine->waitForUnit('default.target');

    subtest "root fs is fsckd", sub {
      $machine->succeed('journalctl -b | grep "fsck.ext4.*/dev/vda"');
    };

    subtest "mnt fs is fsckd", sub {
      $machine->succeed('journalctl -b | grep "fsck.*/dev/vdb.*clean"');
      $machine->succeed('grep "Requires=systemd-fsck@dev-vdb.service" /run/systemd/generator/mnt.mount');
      $machine->succeed('grep "After=systemd-fsck@dev-vdb.service" /run/systemd/generator/mnt.mount');
    };
  '';
}
