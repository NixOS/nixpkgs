{ system ? builtins.currentSystem
, config ? {}
, pkgs ? import ../.. { inherit system config; }
, systemdStage1 ? false
}:

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

    boot.initrd.systemd.enable = systemdStage1;
  };

<<<<<<< HEAD
  testScript =  { nodes, ...}:
  let
    rootDevice = nodes.machine.virtualisation.rootDevice;
  in
  ''
=======
  testScript = ''
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    machine.wait_for_unit("default.target")

    with subtest("root fs is fsckd"):
        machine.succeed("journalctl -b | grep '${if systemdStage1
<<<<<<< HEAD
          then "fsck.*${builtins.baseNameOf rootDevice}.*clean"
          else "fsck.ext4.*${rootDevice}"}'")

    with subtest("mnt fs is fsckd"):
        machine.succeed("journalctl -b | grep 'fsck.*vdb.*clean'")
=======
          then "fsck.*vda.*clean"
          else "fsck.ext4.*/dev/vda"}'")

    with subtest("mnt fs is fsckd"):
        machine.succeed("journalctl -b | grep 'fsck.*/dev/vdb.*clean'")
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        machine.succeed(
            "grep 'Requires=systemd-fsck@dev-vdb.service' /run/systemd/generator/mnt.mount"
        )
        machine.succeed(
            "grep 'After=systemd-fsck@dev-vdb.service' /run/systemd/generator/mnt.mount"
        )
  '';
}
