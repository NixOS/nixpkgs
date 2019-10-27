# Test whether fast reboots via kexec work.

import ./make-test.nix ({ pkgs, ...} : {
  name = "kexec";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ eelco ];
  };

  machine = { ... }:
    { virtualisation.vlans = [ ]; };

  testScript =
    ''
      $machine->waitForUnit("multi-user.target");
      $machine->execute("systemctl kexec &");
      $machine->{connected} = 0;
      $machine->waitForUnit("multi-user.target");
    '';
})
