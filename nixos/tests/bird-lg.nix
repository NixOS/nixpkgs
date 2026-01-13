{ pkgs, ... }:

let
  format = pkgs.formats.json { };
  apiCalls = {
    serverList = format.generate "serverList.json" {
      servers = [ ];
      type = "server_list";
      args = "";
    };
    listProtocols = format.generate "listProtocols.json" {
      servers = [ "localhost" ];
      type = "summary";
      args = "";
    };
    tracerouteLocalhost = format.generate "tracerouteLocalhost.json" {
      servers = [ "localhost" ];
      type = "traceroute";
      args = "127.0.0.1";
    };
  };
in
{
  name = "bird-lg";
  meta = {
    maintainers = [
      pkgs.lib.maintainers.e1mo
    ];
  };

  nodes.machine = {
    environment.systemPackages = with pkgs; [ jq ];
    services.bird-lg = {
      proxy = {
        enable = true;
        birdSocket = "/var/run/bird/bird.ctl";
        listenAddresses = [
          "127.0.0.1:8000"
          "127.0.0.1:8001"
        ];
      };
      frontend = {
        enable = true;
        servers = [
          "localhost"
          "does-not-exist"
        ];
        domain = "localhost";
        listenAddresses = [
          "127.0.0.1:5000"
          "127.0.0.1:5001"
        ];
      };
    };
    services.bird = {
      enable = true;
      config = ''
        router id 10.0.0.1;

        protocol ospf v3 ospf4 {
          area 0 {};
        }
        protocol ospf v3 ospf6 {
          area 0 {};
        }
      '';
    };
  };

  testScript = ''
    start_all()

    machine.wait_for_unit("bird-lg-frontend.service")
    machine.wait_for_unit("bird-lg-proxy.service")

    machine.succeed("curl -f http://localhost:8000/bird?q=show+status")
    machine.succeed("curl -f http://localhost:8001/bird?q=show+status")
    machine.succeed("curl -f --json @${apiCalls.tracerouteLocalhost} http://localhost:5000/api/ | jq -e '.result[0].data' | grep 'traceroute to'")
    machine.succeed("curl -f --json @${apiCalls.tracerouteLocalhost} http://localhost:5001/api/ | jq -e '.result[0].data' | grep 'traceroute to'")
    machine.succeed("curl -f --json @${apiCalls.serverList} http://localhost:5000/api/ | grep localhost | grep 'does-not-exist' ")
    machine.succeed("curl -f --json @${apiCalls.listProtocols} http://localhost:5000/api/ | grep 'ospf4' | grep 'ospf6'")
  '';
}
