import ./make-test.nix ({ lib, ... }: {
  name = "btpd";

  meta.maintainers = with lib.maintainers; [ tadeokondrak ];

  machine = { ... }: {
    services.btpd.enable = true;
  };

  testScript = ''
    $machine->start;
    $machine->waitForUnit("btpd.service");
    $machine->waitForOpenPort("6681");
    $machine->succeed("btcli -d /var/lib/btpd stat");
  '';
})
