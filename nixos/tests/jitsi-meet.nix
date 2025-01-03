import ./make-test-python.nix (
  { pkgs, ... }:
  {
    name = "jitsi-meet";
    meta = with pkgs.lib; {
      maintainers = teams.jitsi.members;
    };

    nodes = {
      client =
        { nodes, pkgs, ... }:
        {
        };
      server =
        { config, pkgs, ... }:
        {
          services.jitsi-meet = {
            enable = true;
            hostName = "server";
          };
          services.jitsi-videobridge.openFirewall = true;

          networking.firewall.allowedTCPPorts = [
            80
            443
          ];

          services.nginx.virtualHosts.server = {
            enableACME = true;
            forceSSL = true;
          };

          security.acme.acceptTerms = true;
          security.acme.defaults.email = "me@example.org";
          security.acme.defaults.server = "https://example.com"; # self-signed only

          specialisation.caddy = {
            inheritParentConfig = true;
            configuration = {
              services.jitsi-meet = {
                caddy.enable = true;
                nginx.enable = false;
              };
              services.caddy.virtualHosts.${config.services.jitsi-meet.hostName}.extraConfig = ''
                tls internal
              '';
            };
          };
        };
    };

    testScript =
      { nodes, ... }:
      ''
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

        def client_curl():
            assert "<title>Jitsi Meet</title>" in client.succeed("curl -sSfkL http://server/")

        client_curl()

        with subtest("Testing backup service"):
            server.succeed("${nodes.server.system.build.toplevel}/specialisation/caddy/bin/switch-to-configuration test")
            server.wait_for_unit("caddy.service")
            client_curl()
      '';
  }
)
