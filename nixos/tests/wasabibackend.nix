import ./make-test-python.nix (
  { pkgs, ... }:
  {
    name = "wasabibackend";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ mmahut ];
    };

    nodes = {
      machine =
        { ... }:
        {
          services.wasabibackend = {
            enable = true;
            network = "testnet";
            rpc = {
              user = "alice";
              port = 18332;
            };
          };
          services.bitcoind."testnet" = {
            enable = true;
            testnet = true;
            rpc.users = {
              alice.passwordHMAC = "e7096bc21da60b29ecdbfcdb2c3acc62$f948e61cb587c399358ed99c6ed245a41460b4bf75125d8330c9f6fcc13d7ae7";
            };
          };
        };
    };

    testScript = ''
      start_all()
      machine.wait_for_unit("wasabibackend.service")
      machine.wait_until_succeeds(
          "grep 'Wasabi Backend started' /var/lib/wasabibackend/.walletwasabi/backend/Logs.txt"
      )
      machine.sleep(5)
      machine.succeed(
          "grep 'Config is successfully initialized' /var/lib/wasabibackend/.walletwasabi/backend/Logs.txt"
      )
    '';
  }
)
