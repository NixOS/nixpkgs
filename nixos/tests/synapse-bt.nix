import ./make-test-python.nix ({ lib, ... }: {
  name = "synapse-bt";

  meta.maintainers = with lib.maintainers; [ tadeokondrak ];

  machine = { ... }: {
    services.synapse-bt.enable = true;
  };

  testScript = ''
    machine.start()
    machine.wait_for_unit("synapse-bt.service")
    machine.wait_for_open_port("8412")
    machine.succeed("sycli list")
  '';
})
