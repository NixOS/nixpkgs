import ./make-test-python.nix (
  { pkgs, ... }:
  {
    name = "bitcoind";
    meta = with pkgs.lib; {
      maintainers = with maintainers; [ _1000101 ];
    };

    nodes.machine =
      { ... }:
      {
        services.bitcoind."mainnet" = {
          enable = true;
          rpc = {
            port = 8332;
            users.rpc.passwordHMAC = "acc2374e5f9ba9e62a5204d3686616cf$53abdba5e67a9005be6a27ca03a93ce09e58854bc2b871523a0d239a72968033";
            users.rpc2.passwordHMAC = "1495e4a3ad108187576c68f7f9b5ddc5$accce0881c74aa01bb8960ff3bdbd39f607fd33178147679e055a4ac35f53225";
          };
        };

        environment.etc."test.blank".text = "";
        services.bitcoind."testnet" = {
          enable = true;
          configFile = "/etc/test.blank";
          testnet = true;
          rpc = {
            port = 18332;
          };
          extraCmdlineOptions = [
            "-rpcuser=rpc"
            "-rpcpassword=rpc"
            "-rpcauth=rpc2:1495e4a3ad108187576c68f7f9b5ddc5$accce0881c74aa01bb8960ff3bdbd39f607fd33178147679e055a4ac35f53225"
          ];
        };
      };

    testScript = ''
      start_all()

      machine.wait_for_unit("bitcoind-mainnet.service")
      machine.wait_for_unit("bitcoind-testnet.service")

      machine.wait_until_succeeds(
          'curl --fail --user rpc:rpc --data-binary \'{"jsonrpc": "1.0", "id":"curltest", "method": "getblockchaininfo", "params": [] }\' -H \'content-type: text/plain;\' localhost:8332 |  grep \'"chain":"main"\' '
      )
      machine.wait_until_succeeds(
          'curl --fail --user rpc2:rpc2 --data-binary \'{"jsonrpc": "1.0", "id":"curltest", "method": "getblockchaininfo", "params": [] }\' -H \'content-type: text/plain;\' localhost:8332 |  grep \'"chain":"main"\' '
      )
      machine.wait_until_succeeds(
          'curl --fail --user rpc:rpc --data-binary \'{"jsonrpc": "1.0", "id":"curltest", "method": "getblockchaininfo", "params": [] }\' -H \'content-type: text/plain;\' localhost:18332 |  grep \'"chain":"test"\' '
      )
      machine.wait_until_succeeds(
          'curl --fail --user rpc2:rpc2 --data-binary \'{"jsonrpc": "1.0", "id":"curltest", "method": "getblockchaininfo", "params": [] }\' -H \'content-type: text/plain;\' localhost:18332 |  grep \'"chain":"test"\' '
      )
    '';
  }
)
