{ lib, ... }:
let
  mkNode =
    localip:
    {
      pkgs,
      config,
      ...
    }:
    {
      virtualisation.vlans = [ 1 ];
      services.toxvpn = {
        enable = true;
        inherit localip;
      };
      networking.firewall.allowedUDPPorts = [ config.services.toxvpn.port ];
      networking.firewall.allowedTCPPorts = [ 8000 ];
      environment.systemPackages = [ pkgs.socat ];
    };
in
{
  name = "toxvpn";

  meta.maintainers = with lib.maintainers; [ h7x4 ];

  containers.alice = mkNode "10.0.0.1";
  containers.bob = mkNode "10.0.0.2";

  testScript =
    { containers, ... }:
    let
      aliceIp = containers.alice.services.toxvpn.localip;
      bobIp = containers.bob.services.toxvpn.localip;
    in
    ''
      import re

      start_all()
      alice.wait_for_unit("toxvpn.service")
      bob.wait_for_unit("toxvpn.service")

      with subtest("Whitelist each other"):
          alice_status = alice.succeed('socat TEXT:"status\\n" UNIX-CONNECT:/run/toxvpn/control')
          bob_status = bob.succeed('socat TEXT:"status\\n" UNIX-CONNECT:/run/toxvpn/control')

          alice_id_match = re.search(r"my id is ([0-9a-f]+)", alice_status)
          bob_id_match = re.search(r"my id is ([0-9a-f]+)", bob_status)
          assert alice_id_match
          assert bob_id_match

          alice.succeed(f'socat TEXT:"whitelist {bob_id_match.group(1)}\\n" UNIX-CONNECT:/run/toxvpn/control')
          bob.succeed(f'socat TEXT:"whitelist {alice_id_match.group(1)}\\n" UNIX-CONNECT:/run/toxvpn/control')

      with subtest("Connect to each other"):
          alice.wait_until_succeeds('socat TEXT:"list\\n" UNIX-CONNECT:/run/toxvpn/control | grep -q bob')
          bob.wait_until_succeeds('socat TEXT:"list\\n" UNIX-CONNECT:/run/toxvpn/control | grep -q alice')

          alice.succeed("ping -c 1 ${bobIp}")
          bob.succeed("ping -c 1 ${aliceIp}")

      with subtest("Send messages to each other"):
          alice.execute("(socat TCP-LISTEN:8000 OPEN:/tmp/received,creat &) >&2")
          bob.execute("(socat TCP-LISTEN:8000 OPEN:/tmp/received,creat &) >&2")

          bob.wait_until_succeeds('socat TEXT:"hi\\n" TCP:${aliceIp}:8000')
          alice.wait_until_succeeds("grep -q hi /tmp/received")
          alice.wait_until_succeeds('socat TEXT:"hi\\n" TCP:${bobIp}:8000')
          bob.wait_until_succeeds("grep -q hi /tmp/received")
    '';
}
