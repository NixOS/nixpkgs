import ./make-test.nix ({ ... } :

let
  node = { pkgs, ... } : {
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

    environment.systemPackages = with pkgs; [ rdma-core screen ];
  };

in {
  name = "rxe";

  nodes = {
    server = node;
    client = node;
  };

  testScript = ''
    # Test if rxe interface comes up
    $server->waitForUnit("default.target");
    $server->succeed("systemctl status rxe.service");
    $server->succeed("ibv_devices | grep rxe0");

    $client->waitForUnit("default.target");

    # ping pong test
    $server->succeed("screen -dmS rc_pingpong ibv_rc_pingpong -p 4800 -g0");
    $client->succeed("sleep 2; ibv_rc_pingpong -p 4800 -g0 server");

    $server->succeed("screen -dmS uc_pingpong ibv_uc_pingpong -p 4800 -g0");
    $client->succeed("sleep 2; ibv_uc_pingpong -p 4800 -g0 server");

    $server->succeed("screen -dmS ud_pingpong ibv_ud_pingpong -p 4800 -s 1024 -g0");
    $client->succeed("sleep 2; ibv_ud_pingpong -p 4800 -s 1024 -g0 server");

    $server->succeed("screen -dmS srq_pingpong ibv_srq_pingpong -p 4800 -g0");
    $client->succeed("sleep 2; ibv_srq_pingpong -p 4800 -g0 server");

    $server->succeed("screen -dmS rping rping -s -a server -C 10");
    $client->succeed("sleep 2; rping -c -a server -C 10");
  '';
})


