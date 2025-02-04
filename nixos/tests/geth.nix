import ./make-test-python.nix (
  { pkgs, ... }:
  {
    name = "geth";
    meta = with pkgs.lib; {
      maintainers = with maintainers; [ bachp ];
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
            jwtsecret = "/etc/geth/jwt";
          };
        };
        environment.etc."geth/jwt" = {
          # Make this unreadable by the service's dynamic user, to ensure it's loaded via LoadCredential.
          mode = "0400";
          user = "root";
          # openssl rand -hex 32 | tr -d "\n"
          text = "39327aa201f12b31c9f955328025a69abfa6e8ab6e74b13d95dae6a98f963332";
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
