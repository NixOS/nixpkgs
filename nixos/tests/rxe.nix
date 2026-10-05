{ ... }:

let
  node =
    { pkgs, ... }:
    {
      networking = {
        firewall = {
          allowedUDPPorts = [ 4791 ]; # open RoCE port
          allowedTCPPorts = [ 4800 ]; # port for test utils
        };
        rxe = {
          enable = true;
          interfaces = [ "eth1" ];
        };
      };

      environment.systemPackages = with pkgs; [
        rdma-core
        screen
      ];
    };

in
{
  name = "rxe";

  nodes = {
    server = node;
    client = node;
  };

  testScript = ''
    # Test if rxe interface comes up
    server.wait_for_unit("default.target")
    server.succeed("systemctl status rxe.service")
    server.succeed("ibv_devices | grep rxe_eth1")

    client.wait_for_unit("default.target")

    # ping pong tests
    for proto in "rc", "uc", "ud", "srq":
        server.succeed(
            "screen -dmS {0}_pingpong ibv_{0}_pingpong -p 4800 -s 1024 -g0".format(proto)
        )
        client.succeed("sleep 2; ibv_{}_pingpong -p 4800 -s 1024 -g0 server".format(proto))

    server.succeed("screen -dmS rping rping -s -a server -C 10")
    client.succeed("sleep 2; rping -c -a server -C 10")
  '';
}
