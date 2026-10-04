{ pkgs, ... }:

let
  testSecrets = pkgs.writeText "buzz.env" ''
    BUZZ_RELAY_PRIVATE_KEY=0000000000000000000000000000000000000000000000000000000000000001
  '';
in
{
  name = "buzz-relay";
  meta.maintainers = with pkgs.lib.maintainers; [ kleinbem ];

  nodes.machine = {
    services.buzz-relay = {
      enable = true;
      relayUrl = "ws://127.0.0.1:3000";
      environmentFile = testSecrets;
    };
    environment.systemPackages = [
      pkgs.buzz-relay
      pkgs.curl
      pkgs.jq
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

    # 2. Verify admin key generation CLI
    out = machine.succeed("buzz-admin generate-key")
    assert "Public key:" in out and "Secret key:" in out, "buzz-admin generate-key must output a keypair"
  '';
}
