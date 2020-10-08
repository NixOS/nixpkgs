import ./make-test-python.nix ({ pkgs, ...} :

let
  port = 10004;
  tcpPort = 10005;
  httpPort = 10080;
in {
  name = "snapcast";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ hexa ];
  };

  nodes = {
    server = {
      services.snapserver = {
        enable = true;
        port = port;
        tcp.port = tcpPort;
        http.port = httpPort;
        streams = {
          mpd = {
            type = "pipe";
            location = "/run/snapserver/mpd";
          };
          bluetooth = {
            type = "pipe";
            location = "/run/snapserver/bluetooth";
          };
        };
      };
    };
  };

  testScript = ''
    import json

    get_rpc_version = {"id": "1", "jsonrpc": "2.0", "method": "Server.GetRPCVersion"}

    start_all()

    server.wait_for_unit("snapserver.service")
    server.wait_until_succeeds("ss -ntl | grep -q ${toString port}")
    server.wait_until_succeeds("ss -ntl | grep -q ${toString tcpPort}")
    server.wait_until_succeeds("ss -ntl | grep -q ${toString httpPort}")

    with subtest("check that pipes are created"):
        server.succeed("test -p /run/snapserver/mpd")
        server.succeed("test -p /run/snapserver/bluetooth")

    with subtest("test tcp json-rpc"):
        server.succeed(f"echo '{json.dumps(get_rpc_version)}' | nc -w 1 localhost ${toString tcpPort}")

    with subtest("test http json-rpc"):
        server.succeed(
            "curl --fail http://localhost:${toString httpPort}/jsonrpc -d '{json.dumps(get_rpc_version)}'"
        )
  '';
})
