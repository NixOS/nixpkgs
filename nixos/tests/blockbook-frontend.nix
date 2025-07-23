{ pkgs, ... }:
{
  name = "blockbook-frontend";
  meta = with pkgs.lib; {
    maintainers = with maintainers; [ _1000101 ];
  };

  nodes.machine =
    { ... }:
    {
      services.blockbook-frontend."test" = {
        enable = true;
      };
      services.bitcoind.mainnet = {
        enable = true;
        rpc = {
          port = 8030;
          users.rpc.passwordHMAC = "acc2374e5f9ba9e62a5204d3686616cf$53abdba5e67a9005be6a27ca03a93ce09e58854bc2b871523a0d239a72968033";
        };
      };
    };

  testScript = ''
    start_all()
    machine.wait_for_unit("blockbook-frontend-test.service")

    machine.wait_for_open_port(9030)

    machine.succeed("curl -sSfL http://localhost:9030 | grep 'Blockbook'")
  '';
}
