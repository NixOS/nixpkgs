import ./make-test-python.nix {
  name = "fsck";

  nodes.machine = { lib, ... }: {
    virtualisation.emptyDiskImages = [ 1 ];

    virtualisation.fileSystems = {
      "/mnt" = {
        device = "/dev/vdb";
        fsType = "ext4";
        autoFormat = true;
      };
    };
  };

  testScript = ''
    machine.wait_for_unit("default.target")

    with subtest("root fs is fsckd"):
        machine.succeed("journalctl -b | grep 'fsck.ext4.*/dev/vda'")

    with subtest("mnt fs is fsckd"):
        machine.succeed("journalctl -b | grep 'fsck.*/dev/vdb.*clean'")
        machine.succeed(
            "grep 'Requires=systemd-fsck@dev-vdb.service' /run/systemd/generator/mnt.mount"
        )
        machine.succeed(
            "grep 'After=systemd-fsck@dev-vdb.service' /run/systemd/generator/mnt.mount"
        )
  '';
}
