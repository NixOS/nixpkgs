{ pkgs, ... }:

let
  # Test-only keys: secret key 1 for the relay, 2 for a member, 3 for the
  # owner.
  memberPubkey = "c6047f9441ed7d6d3045406e95c07cd85c778e4b8cef3ca7abac09b95c709ee5";
  ownerPubkey = "f9308a019258c31049344f85f89d5229b531c845836f99b08601f113bce036f9";
in
{
  name = "buzz-relay";
  meta.maintainers = with pkgs.lib.maintainers; [ kleinbem ];

  nodes.machine = {
    # Secrets live outside the Nix store.
    environment.etc."buzz-relay.env".text = ''
      BUZZ_RELAY_PRIVATE_KEY=0000000000000000000000000000000000000000000000000000000000000001
    '';

    services.buzz-relay = {
      enable = true;
      relayUrl = "ws://127.0.0.1:3000";
      environmentFile = "/etc/buzz-relay.env";
      pairRelay.enable = true;
      members.${memberPubkey} = "member";
      settings = {
        RELAY_OWNER_PUBKEY = ownerPubkey;
        # Serves the admin dashboard to requests for this host.
        BUZZ_ADMIN_HOST = "admin.test";
        BUZZ_PAIRING_RELAY_URL = "ws://127.0.0.1:3001";
      };
    };
    environment.systemPackages = [
      pkgs.buzz-relay
      pkgs.curl
      pkgs.jq
      pkgs.redis
    ];
  };

  testScript = ''
    import json

    machine.wait_for_unit("postgresql.service")
    machine.wait_for_unit("redis-buzz-relay.service")
    machine.wait_for_unit("buzz-relay.service")
    machine.wait_for_open_port(3000)

    # 1. Verify NIP-11 information document
    res = machine.succeed("curl -fsS -H 'Accept: application/nostr+json' http://127.0.0.1:3000/")
    data = json.loads(res)
    assert "supported_nips" in data, "NIP-11 document must contain supported_nips"

    # 2. Verify the relay is connected to the local Redis over its Unix socket
    machine.wait_until_succeeds(
      "redis-cli -s /run/redis-buzz-relay/redis.sock CLIENT LIST | grep -v 'cmd=client|list' | grep -q 'addr=/run/redis-buzz-relay/redis.sock'"
    )

    # 3. Verify the bundled web UI: the invite landing page, and the admin
    #    dashboard on the admin host only
    page = machine.succeed("curl -fsS http://127.0.0.1:3000/invite/test")
    assert "<title>Buzz</title>" in page, "the invite page must come from the web bundle"
    # `/` answers browsers (Accept: text/html) with the dashboard.
    page = machine.succeed("curl -fsS -H 'Host: admin.test' -H 'Accept: text/html' http://127.0.0.1:3000/")
    assert "<title>Buzz admin</title>" in page, "the admin host must serve the admin dashboard"
    machine.fail("curl -fsS http://127.0.0.1:3000/reports")

    # 4. Verify admin key generation CLI
    out = machine.succeed("buzz-admin generate-key")
    assert "Public key:" in out and "Secret key:" in out, "buzz-admin generate-key must output a keypair"

    # 5. Verify the pairing relay runs and the relay advertises it
    machine.wait_for_unit("buzz-pair-relay.service")
    machine.wait_for_open_port(3001)
    assert data["pairing_relay_url"] == "ws://127.0.0.1:3001", "NIP-11 must advertise the pairing relay"

    # 6. Verify the closed-relay settings and the media URL derived from relayUrl
    env = machine.succeed("systemctl show buzz-relay -p Environment")
    for expected in [
      "BUZZ_REQUIRE_RELAY_MEMBERSHIP=true",
      "RELAY_OWNER_PUBKEY=${ownerPubkey}",
      "BUZZ_MEDIA_BASE_URL=http://127.0.0.1:3000/media",
    ]:
      assert expected in env, f"{expected} missing from the relay's environment"

    # 7. Verify the configured member was added
    machine.wait_for_unit("buzz-relay-members.service")
    machine.succeed("journalctl -u buzz-relay-members | grep -E '(added|already a member:) ${memberPubkey}'")
    # buzz-relay-admin runs buzz-admin with the relay's user and environment.
    machine.succeed("buzz-relay-admin list-members | grep ${memberPubkey}")
  '';
}
