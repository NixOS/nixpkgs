{ pkgs, ... }:
{
  name = "geth";
  meta = {
    maintainers = with pkgs.lib.maintainers; [ bachp ];
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

      services.geth."hoodi" = {
        enable = true;
        port = 30304;
        network = "hoodi";
        http = {
          enable = true;
          port = 18545;
        };
        authrpc = {
          enable = true;
          port = 18551;
        };
      };

      services.geth."sepolia" = {
        enable = true;
        port = 30305;
        network = "sepolia";
        http = {
          enable = true;
          port = 28545;
        };
        authrpc = {
          enable = true;
          port = 28551;
        };
      };
    };

  testScript = ''
    start_all()

    machine.wait_for_unit("geth-mainnet.service")
    machine.wait_for_unit("geth-hoodi.service")
    machine.wait_for_unit("geth-sepolia.service")
    machine.wait_for_open_port(8545)
    machine.wait_for_open_port(18545)
    machine.wait_for_open_port(28545)

    machine.succeed(
        'geth attach --exec "eth.blockNumber" http://localhost:8545 | grep \'^0$\' '
    )

    machine.succeed(
        'geth attach --exec "eth.blockNumber" http://localhost:18545 | grep \'^0$\' '
    )

    machine.succeed(
        'geth attach --exec "eth.blockNumber" http://localhost:28545 | grep \'^0$\' '
    )
  '';
}
