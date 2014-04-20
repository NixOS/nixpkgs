# Test whether fast reboots via kexec work.

import ./make-test.nix  {

  machine = { config, pkgs, ... }:
    { virtualisation.vlans = [ ]; };

  testScript =
    ''
      $machine->waitForUnit("multi-user.target");
      $machine->execute("systemctl kexec &");
      $machine->{connected} = 0;
      $machine->waitForUnit("multi-user.target");
    '';

}
