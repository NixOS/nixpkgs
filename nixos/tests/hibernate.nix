# Test whether hibernation from partition works.

import ./make-test.nix (pkgs: {
  name = "hibernate";

  machine = { config, lib, pkgs, ... }: with lib; {
    virtualisation = {
      emptyDiskImages = [ config.virtualisation.memorySize ];
      vlans = [ ];
    };
    swapDevices = mkOverride 0 [ { device = "/dev/vdb"; } ];
    boot.tmpOnTmpfs = true;
  };

  testScript =
    ''
      $machine->waitForUnit("multi-user.target");
      $machine->succeed("mkswap /dev/vdb");
      $machine->succeed("swapon -a");
      $machine->succeed("touch /tmp/test");
      $machine->execute("systemctl hibernate &");
      $machine->waitForShutdown;
      $machine->start;
      $machine->succeed("test -f /tmp/test");
    '';

})
