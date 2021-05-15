import ./make-test-python.nix ({ lib, ... }: {
  name = "btpd";

  meta.maintainers = with lib.maintainers; [ tadeokondrak ];

  machine = { ... }: {
    services.btpd.enable = true;
  };

  testScript = ''
    machine.start()
    machine.wait_for_unit("btpd.service")
    machine.wait_for_open_port("6681")
    machine.succeed("btcli -d /var/lib/btpd stat")
  '';
})
