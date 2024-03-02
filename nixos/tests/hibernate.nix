# Test whether hibernation from partition works.

{ system ? builtins.currentSystem
, config ? {}
, pkgs ? import ../.. { inherit system config; }
, systemdStage1 ? false
}:

with import ../lib/testing-python.nix { inherit system pkgs; };

makeTest {
  name = "hibernate";

  nodes = {
    machine = { config, lib, pkgs, ... }: {
      imports = [
        ./common/auto-format-root-device.nix
      ];

      systemd.services.backdoor.conflicts = [ "sleep.target" ];
      powerManagement.resumeCommands = "systemctl --no-block restart backdoor.service";

      virtualisation.emptyDiskImages = [ (2 * config.virtualisation.memorySize) ];
      virtualisation.useNixStoreImage = true;

      swapDevices = lib.mkOverride 0 [ { device = "/dev/vdc"; options = [ "x-systemd.makefs" ]; } ];
      boot.resumeDevice = "/dev/vdc";
      boot.initrd.systemd.enable = systemdStage1;
    };
  };

  testScript = ''
    # Drop in file that checks if we un-hibernated properly (and not booted fresh)
    machine.wait_for_unit("default.target")
    machine.succeed(
        "mkdir /run/test",
        "mount -t ramfs -o size=1m ramfs /run/test",
        "echo not persisted to disk > /run/test/suspended",
    )

    # Hibernate machine
    machine.execute("systemctl hibernate >&2 &", check_return=False)
    machine.wait_for_shutdown()

    # Restore machine from hibernation, validate our ramfs file is there.
    machine.start()
    machine.succeed("grep 'not persisted to disk' /run/test/suspended")

    # Ensure we don't restore from hibernation when booting again
    machine.crash()
    machine.wait_for_unit("default.target")
    machine.fail("grep 'not persisted to disk' /run/test/suspended")
  '';

}
