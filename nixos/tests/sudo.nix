import ./make-test.nix {
  name = "sudo";
  nodes = {
  machine = { pkgs, config, ... }:
    {
      security.sudo.enable = true;
    };
  };
  testScript = ''
    startAll;
    $machine->waitForUnit("multi-user.target");
    $machine->succeed("sudo echo foobar");
    '';
  }

