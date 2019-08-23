import ./make-test.nix ({ pkgs, ...} : {
  name = "novacomd";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ dtzWill ];
  };

  machine = { ... }: {
    services.novacomd.enable = true;
  };

  testScript = ''
    $machine->waitForUnit("multi-user.target");

    # multi-user.target wants novacomd.service, but let's make sure
    $machine->waitForUnit("novacomd.service");

    # Check status and try connecting with novacom
    $machine->succeed("systemctl status novacomd.service >&2");
    # to prevent non-deterministic failure,
    # make sure the daemon is really listening
    $machine->waitForOpenPort(6968);
    $machine->succeed("novacom -l");

    # Stop the daemon, double-check novacom fails if daemon isn't working
    $machine->stopJob("novacomd");
    $machine->fail("novacom -l");

    # And back again for good measure
    $machine->startJob("novacomd");
    # make sure the daemon is really listening
    $machine->waitForOpenPort(6968);
    $machine->succeed("novacom -l");
  '';
})
