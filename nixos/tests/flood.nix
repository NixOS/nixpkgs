import ./make-test-python.nix ({ pkgs, lib, ... }:
let
  address = "127.0.0.127";
  port = 3030;
  url = "${address}:${toString port}";
in
{
  name = "flood";
  meta = with lib.maintainers; {
    maintainers = [ _3JlOy-PYCCKUi ];
  };

  nodes.machine = { pkgs, ... }: {
    services.flood = {
      enable = true;
      inherit address port;
      auth.rtorrent = {
        host = "127.0.0.1";
        port = 9999;
      };
    };
    environment.systemPackages = [ pkgs.jq ];
  };

  testScript = ''
    start_all()
    machine.wait_for_unit("flood.service")
    machine.wait_for_open_port(${toString port}, "${address}")

    machine.succeed("ss -tlpn 'src = ${address}' | grep LISTEN | grep node")

    machine.succeed("curl -sf '${url}' | grep Flood")

    # https://github.com/jesec/flood/blob/5a0d2bec844fe5f2163588b308158179d23b6d87/server/routes/api/auth.ts#L212
    machine.succeed("curl -sf -c /tmp/cookies 'http://${url}/api/auth/verify' | jq -e .username >&2")

    # https://github.com/jesec/flood/blob/5a0d2bec844fe5f2163588b308158179d23b6d87/server/routes/api/client.ts#L19
    status = machine.fail("curl -s --fail-with-body -b /tmp/cookies 'http://${url}/api/client/connection-test'")

    machine.succeed(f"echo '{status}' | jq .isConnected | grep -P '^false$'")

    machine.shutdown()
  '';
})
