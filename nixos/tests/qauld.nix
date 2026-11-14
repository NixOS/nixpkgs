{ lib, ... }:

let
  peerPort = 9229;
  aliceIp = "192.168.1.1";
  bobIp = "192.168.1.2";
  aliceMultiaddr = "/ip4/${aliceIp}/udp/${toString peerPort}/quic-v1";

  common = {
    networking.useDHCP = false;

    services.qauld = {
      enable = true;
      openFirewall = true;
      port = peerPort;
    };
  };
in
{
  name = "qauld";
  meta = {
    maintainers = [ lib.maintainers.lucasew ];
    teams = [ lib.teams.ngi ];
  };

  nodes = {
    alice = {
      imports = [ common ];
      networking.interfaces.eth1.ipv4.addresses = [
        {
          address = aliceIp;
          prefixLength = 24;
        }
      ];
      services.qauld.name = "alice";
    };

    bob = {
      imports = [ common ];
      networking.interfaces.eth1.ipv4.addresses = [
        {
          address = bobIp;
          prefixLength = 24;
        }
      ];
      services.qauld.name = "bob";
    };
  };

  testScript = ''
    import json

    ctl = "qauld-ctl --dir /var/lib/qauld --timeout 20"

    def wait_daemon(m):
        m.wait_for_unit("qauld.service")
        m.wait_until_succeeds("test -S /var/lib/qauld/qauld.sock", timeout=60)
        m.wait_until_succeeds(
            "ss -ulnp | grep -q ':${toString peerPort}' || ss -tlnp | grep -q ':${toString peerPort}'",
            timeout=60,
        )
        m.wait_until_succeeds(f"{ctl} --json node info", timeout=60)

    def node_info(m):
        return json.loads(m.succeed(f"{ctl} --json node info"))

    # Avoid pipefail+SIGPIPE when grepping qauld-ctl JSON.
    def peer_shell_check(name, node_id):
        return (
            "tmp=$(mktemp); "
            f"{ctl} --json users list >$tmp 2>/dev/null; "
            f"{ctl} --json users online >>$tmp 2>/dev/null; "
            f"{ctl} --json router neighbours >>$tmp 2>/dev/null; "
            f"grep -Eiq '{name}|{node_id}' $tmp; r=$?; "
            "rm -f $tmp; exit $r"
        )

    start_all()

    wait_daemon(alice)
    wait_daemon(bob)

    alice_id = node_info(alice)["node_id"]
    bob_id = node_info(bob)["node_id"]
    assert alice_id and bob_id and alice_id != bob_id

    bob.succeed(
        f"{ctl} connections nodes add "
        "--address '${aliceMultiaddr}' "
        "--name alice-hub"
    )
    bob.succeed(f"{ctl} --json connections nodes list")

    bob.wait_until_succeeds(peer_shell_check("alice", alice_id), timeout=180)
    alice.wait_until_succeeds(peer_shell_check("bob", bob_id), timeout=180)

    alice.succeed(f"{ctl} feed send --message 'hello-from-alice'")
    bob.wait_until_succeeds(
        "tmp=$(mktemp); "
        f"{ctl} --json feed list >$tmp 2>/dev/null; "
        "grep -Fq 'hello-from-alice' $tmp; r=$?; rm -f $tmp; exit $r",
        timeout=120,
    )

    alice.succeed("systemctl restart qauld.service")
    wait_daemon(alice)
    assert node_info(alice)["node_id"] == alice_id
    alice.succeed("test -f /var/lib/qauld/config.yaml")

    bob.wait_until_succeeds(peer_shell_check("alice", alice_id), timeout=180)
  '';
}
