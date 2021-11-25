import ./make-test-python.nix ({ lib, ... }: {
  name = "without-nix";
  meta = with lib.maintainers; {
    maintainers = [ ericson2314 ];
  };

  nixpkgs.overlays = [
    (self: super: {
      nix = throw "don't want to use this";
    })
  ];

  nodes.machine = { ... }: {
    nix.enable = false;
  };

  testScript = ''
    start_all()

    machine.succeed("which which")
    machine.fail("which nix")
  '';
})
