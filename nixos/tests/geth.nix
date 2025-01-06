import ./make-test-python.nix (
  { pkgs, lib, ... }:
  {
    name = "geth";
    meta = {
      maintainers = with lib.maintainers; [ bachp ];
    };

    nodes.machine =
      { ... }:
      {
        services.geth."mainnet" = {
          enable = true;
          http = {
            enable = true;
          };
        };
        services.geth."testnet" = {
          enable = true;
          port = 30304;
          network = "holesky";
          http = {
            enable = true;
            port = 18545;
          };
          authrpc = {
            enable = true;
            port = 18551;
          };
        };
      };

    testScript = ''
      start_all()

      machine.wait_for_unit("geth-mainnet.service")
      machine.wait_for_unit("geth-testnet.service")
      machine.wait_for_open_port(8545)
      machine.wait_for_open_port(18545)

      machine.succeed(
          'geth attach --exec "eth.blockNumber" http://localhost:8545 | grep \'^0$\' '
      )

      machine.succeed(
          'geth attach --exec "eth.blockNumber" http://localhost:18545 | grep \'^0$\' '
      )
    '';
  }
)
