import ./make-test-python.nix (
  { pkgs, ... }:
  # kanidm only works over tls so we use these self signed certificates
  # generate using `openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 -nodes -keyout selfcert.key -out selfcert.crt -subj "/CN=example.com" -addext "subjectAltName=DNS:localhost,IP:127.0.0.1"`
  let
    tls_chain = "${./common/acme/server}/ca.cert.pem";
    tls_key = "${./common/acme/server}/ca.key.pem";
  in
  {
    name = "netbird";

    meta.maintainers = with pkgs.lib.maintainers; [ patrickdag ];

    nodes = {
      client =
        { ... }:
        {
          services.netbird.enable = true;
        };
      kanidm = {
        services.kanidm = {
          enableServer = true;
          serverSettings = {
            inherit tls_key tls_chain;
            domain = "localhost";
            origin = "https://localhost";
          };
        };
      };
      server =
        { ... }:
        {
          # netbirds needs an openid identity provider
          services.netbird.server = {
            enable = true;
            coturn = {
              enable = true;
              password = "lel";
            };
            domain = "nixos-test.internal";
            dashboard.settings.AUTH_AUTHORITY = "https://kanidm/oauth2/openid/netbird";
            management.oidcConfigEndpoint = "https://kanidm:8443/oauth2/openid/netbird/.well-known/openid-configuration";
            relay.authSecretFile = (pkgs.writeText "wuppiduppi" "huppiduppi");
          };
        };
    };

    testScript = ''
      client.start()
      with subtest("client starting"):
        client.wait_for_unit("netbird-wt0.service")
        client.wait_for_file("/var/run/netbird/sock")
        client.succeed("netbird status | grep -q 'Daemon status: NeedsLogin'")

      kanidm.start()
      kanidm.wait_for_unit("kanidm.service")

      server.start()
      with subtest("server starting"):
        server.wait_for_unit("netbird-management.service")
        server.wait_for_unit("netbird-signal.service")
        server.wait_for_unit("netbird-relay.service")
    '';
  }
)
