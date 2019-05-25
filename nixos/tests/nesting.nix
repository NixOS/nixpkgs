import ./make-test.nix {
  name = "nesting";
  machine = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.cowsay ];
    nesting.clone = [
      ({ pkgs, ... }: {
        environment.systemPackages = [ pkgs.hello ];
      })
    ];
  };
  testScript = ''
    $machine->waitForUnit("default.target");
    $machine->succeed("cowsay hey");
    $machine->fail("hello");

    # Nested clones do inherit from parent
    $machine->succeed("/run/current-system/fine-tune/child-1/bin/switch-to-configuration test");
    $machine->succeed("cowsay hey");
    $machine->succeed("hello");

  '';
}
