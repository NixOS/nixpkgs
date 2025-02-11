import ./make-test-python.nix (
  { pkgs, ... }:

  let
    port = 10004;
    tcpPort = 10005;
    httpPort = 10080;
    tcpStreamPort = 10006;
    bufferSize = 742;
  in
  {
    name = "snapcast";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ hexa ];
    };

    nodes = {
      server = {
        services.snapserver = {
          enable = true;
          port = port;
          tcp.port = tcpPort;
          http.port = httpPort;
          openFirewall = true;
          buffer = bufferSize;
          streams = {
            mpd = {
              type = "pipe";
              location = "/run/snapserver/mpd";
              query.mode = "create";
            };
            bluetooth = {
              type = "pipe";
              location = "/run/snapserver/bluetooth";
            };
            tcp = {
              type = "tcp";
              location = "127.0.0.1:${toString tcpStreamPort}";
            };
            meta = {
              type = "meta";
              location = "/mpd/bluetooth/tcp";
            };
          };
        };
        environment.systemPackages = [ pkgs.snapcast ];
      };
      client = {
        environment.systemPackages = [ pkgs.snapcast ];
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
      server.wait_until_succeeds("ss -ntl | grep -q ${toString tcpStreamPort}")

      with subtest("check that pipes are created"):
          server.succeed("test -p /run/snapserver/mpd")
          server.succeed("test -p /run/snapserver/bluetooth")

      with subtest("test tcp json-rpc"):
          server.succeed(f"echo '{json.dumps(get_rpc_version)}' | nc -w 1 localhost ${toString tcpPort}")

      with subtest("test http json-rpc"):
          server.succeed(
              "curl --fail http://localhost:${toString httpPort}/jsonrpc -d '{json.dumps(get_rpc_version)}'"
          )

      with subtest("test a ipv6 connection"):
          server.execute("systemd-run --unit=snapcast-local-client snapclient -h ::1 -p ${toString port}")
          server.wait_until_succeeds(
              "journalctl -o cat -u snapserver.service | grep -q 'Hello from'"
          )
          server.wait_until_succeeds("journalctl -o cat -u snapcast-local-client | grep -q 'buffer: ${toString bufferSize}'")

      with subtest("test a connection"):
          client.execute("systemd-run --unit=snapcast-client snapclient -h server -p ${toString port}")
          server.wait_until_succeeds(
              "journalctl -o cat -u snapserver.service | grep -q 'Hello from'"
          )
          client.wait_until_succeeds("journalctl -o cat -u snapcast-client | grep -q 'buffer: ${toString bufferSize}'")
    '';
  }
)
