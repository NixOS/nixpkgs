import ./make-test.nix ({ pkgs, ...} : {
  name = "novacomd";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ dtzWill ];
  };

  machine = { ... }: {
    services.novacomd.enable = true;
  };

  testScript = ''
    startAll;

    $machine->waitForUnit("novacomd.service");

    # Check status and try connecting with novacom
    $machine->succeed("systemctl status novacomd.service >&2");
    $machine->succeed("novacom -l");

    # Stop the daemon, double-check novacom fails if daemon isn't working
    $machine->stopJob("novacomd");
    $machine->fail("novacom -l");

    # And back again for good measure
    $machine->startJob("novacomd");
    $machine->succeed("novacom -l");
  '';
})
