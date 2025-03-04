import ./make-test-python.nix (
  { pkgs, lib, ... }:
  # kanidm only works over tls so we use these self signed certificates
  # generate using `openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 -nodes -keyout selfcert.key -out selfcert.crt -subj "/CN=example.com" -addext "subjectAltName=DNS:localhost,IP:127.0.0.1"`
  let
    tls_chain = "${./common/acme/server}/ca.cert.pem";
    tls_key = "${./common/acme/server}/ca.key.pem";
  in
  {
    name = "netbird";

    meta.maintainers = with pkgs.lib.maintainers; [
      patrickdag
      nazarewk
    ];

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

    # TODO: confirm the whole solution is working end-to-end when netbird server is implemented
    testScript = ''
        start_all()
        def did_start(node, name):
          node.wait_for_unit(f"{name}.service")
          node.wait_for_file(f"/var/run/{name}/sock")
          output = node.succeed(f"{name} status")

          # not sure why, but it can print either of:
          #  - Daemon status: NeedsLogin
          #  - Management: Disconnected
          expected = [
            "Disconnected",
            "NeedsLogin",
          ]
          assert any(msg in output for msg in expected)

        did_start(clients, "netbird")
        did_start(clients, "netbird-custom")

      /*
        `netbird status` used to print `Daemon status: NeedsLogin`
            https://github.com/netbirdio/netbird/blob/23a14737974e3849fa86408d136cc46db8a885d0/client/cmd/status.go#L154-L164
        as the first line, but now it is just:

            Daemon version: 0.26.3
            CLI version: 0.26.3
            Management: Disconnected
            Signal: Disconnected
            Relays: 0/0 Available
            Nameservers: 0/0 Available
            FQDN:
            NetBird IP: N/A
            Interface type: N/A
            Quantum resistance: false
            Routes: -
            Peers count: 0/0 Connected
      */
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
