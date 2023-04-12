import ./make-test-python.nix ({ pkgs, ... }: {
  name = "jitsi-meet";
  meta = with pkgs.lib; {
    maintainers = teams.jitsi.members;
  };

  nodes = {
    client = { nodes, pkgs, ... }: {
    };
    server = { config, pkgs, ... }: {
      services.jitsi-meet = {
        enable = true;
        hostName = "server";
      };
      services.jitsi-videobridge.openFirewall = true;

      networking.firewall.allowedTCPPorts = [ 80 443 ];

      services.nginx.virtualHosts.server = {
        enableACME = true;
        forceSSL = true;
      };

      security.acme.acceptTerms = true;
      security.acme.defaults.email = "me@example.org";
      security.acme.defaults.server = "https://example.com"; # self-signed only
    };
  };

  testScript = ''
    server.wait_for_unit("jitsi-videobridge2.service")
    server.wait_for_unit("jicofo.service")
    server.wait_for_unit("nginx.service")
    server.wait_for_unit("prosody.service")

    server.wait_until_succeeds(
        "journalctl -b -u prosody -o cat | grep -q 'Authenticated as focus@auth.server'"
    )
    server.wait_until_succeeds(
        "journalctl -b -u prosody -o cat | grep -q 'Authenticated as jvb@auth.server'"
    )

    client.wait_for_unit("network.target")
    assert "<title>Jitsi Meet</title>" in client.succeed("curl -sSfkL http://server/")
  '';
})
