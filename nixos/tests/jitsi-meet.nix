import ./make-test-python.nix ({ pkgs, ... }: {
  name = "jitsi-meet";
  meta = with pkgs.lib; {
    maintainers = teams.jitsi.members;
  };

  nodes = {
    client = { config, pkgs, ... }: {
      environment.systemPackages = [ pkgs.curl pkgs.websocat ];
    };
    server = { config, pkgs, ... }: {
      services.jitsi-meet = {
        enable = true;
        hostName = "server";
      };
      services.jitsi-videobridge.openFirewall = true;

      networking.firewall.allowedTCPPorts = [ 80 443 ];

      services.nginx.virtualHosts."server" = {
        enableACME = true;
        forceSSL = true;
      };

      security.acme.acceptTerms = true;
      security.acme.defaults.email = "me@example.org";
      security.acme.defaults.server = "https://example.com"; # self-signed only
    };
    jwtserver = { config, pkgs, ... }: {
      services.jitsi-meet = {
        enable = true;
        hostName = "jwtserver";
        jwt = {
          enable = true;
          appId = "jwtserver";
          issuer = "nixos";
          audience = "nixos";
          secretFile = pkgs.writeText "jitsi-test-jwt" "b+bXFmEL3eIax/vjaHvcoDgQPcat8iF59QU6yq4Sb2niTXGg";
        };
      };

      networking.firewall.allowedTCPPorts = [ 80 443 ];

      services.nginx.virtualHosts."jwtserver" = {
        enableACME = true;
        forceSSL = true;
      };

      security.acme.acceptTerms = true;
      security.acme.defaults.email = "me@example.org";
      security.acme.defaults.server = "https://example.com"; # self-signed only
    };
  };

  testScript = ''
    for host in (server, jwtserver):
        host.wait_for_unit("jitsi-videobridge2.service")
        host.wait_for_unit("jicofo.service")
        host.wait_for_unit("nginx.service")
        host.wait_for_unit("prosody.service")

        host.wait_until_succeeds(
            "journalctl -b -u prosody -o cat | grep -q 'Authenticated as focus@auth.'"
        )
        host.wait_until_succeeds(
            "journalctl -b -u prosody -o cat | grep -q 'Authenticated as jvb@auth.'"
        )

    # Ensure that nginx is up.
    client.wait_for_unit("network.target")
    assert "<title>Jitsi Meet</title>" in client.succeed("curl -sSfkL http://server/")
    assert "<title>Jitsi Meet</title>" in client.succeed("curl -sSfkL http://jwtserver/")

    # Ensure that anonymous auth works.
    succeeded_auth = client.wait_until_succeeds(
        """
            (
                echo '<open to="server" version="1.0" xmlns="urn:ietf:params:xml:ns:xmpp-framing"/>'
                sleep 1
                echo '<auth mechanism="ANONYMOUS" xmlns="urn:ietf:params:xml:ns:xmpp-sasl"/>'
                sleep 1
            ) | websocat --insecure --text -H='Sec-Websocket-Protocol: xmpp' 'wss://server/xmpp-websocket?room=NixOSRules'
        """
    )
    assert '<failure' not in succeeded_auth
    assert '<success' in succeeded_auth

    # Ensure that token auth is required on the JWT server.
    failed_auth = client.wait_until_succeeds(
        """
            (
                echo '<open to="jwtserver" version="1.0" xmlns="urn:ietf:params:xml:ns:xmpp-framing"/>'
                sleep 1
                echo '<auth mechanism="ANONYMOUS" xmlns="urn:ietf:params:xml:ns:xmpp-sasl"/>'
                sleep 1
            ) | websocat --insecure --text -H='Sec-Websocket-Protocol: xmpp' 'wss://jwtserver/xmpp-websocket?room=NixOSRules'
        """
    )
    assert '<success' not in failed_auth
    assert '<failure' in failed_auth
    assert 'token required' in failed_auth

    # This JWT was generated using the server secret and has an expiration of 2100-01-01.
    # Make sure it authenticates on the JWT server.
    succeeded_auth = client.wait_until_succeeds(
        """
            (
                echo '<open to="jwtserver" version="1.0" xmlns="urn:ietf:params:xml:ns:xmpp-framing"/>'
                sleep 1
                echo '<auth mechanism="ANONYMOUS" xmlns="urn:ietf:params:xml:ns:xmpp-sasl"/>'
                sleep 1
            ) | websocat --insecure --text -H='Sec-Websocket-Protocol: xmpp' 'wss://jwtserver/xmpp-websocket?room=NixOSRules&token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJuaXhvcyIsImlhdCI6MTY3MjEyMjI2MCwiZXhwIjo0MTAyNDQ0ODAwLCJhdWQiOiJuaXhvcyIsInN1YiI6Imp3dHNlcnZlciIsInJvb20iOiJOaXhPU1J1bGVzIn0.Jtyu7iaDMlzRtkqLOz8qnXnF9Gj_Kbvr8RHmh5iviFc'
        """
    )
    assert '<failure' not in succeeded_auth
    assert '<success' in succeeded_auth

    # This JWT was generated using the incorrect server secret but is otherwise valid. Make sure it's rejected.
    failed_auth = client.wait_until_succeeds(
        """
            (
                echo '<open to="jwtserver" version="1.0" xmlns="urn:ietf:params:xml:ns:xmpp-framing"/>'
                sleep 1
                echo '<auth mechanism="ANONYMOUS" xmlns="urn:ietf:params:xml:ns:xmpp-sasl"/>'
                sleep 1
            ) | websocat --insecure --text -H='Sec-Websocket-Protocol: xmpp' 'wss://jwtserver/xmpp-websocket?room=NixOSRules&token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJuaXhvcyIsImlhdCI6MTY3MjEyMjI2MCwiZXhwIjo0MTAyNDQ0ODAwLCJhdWQiOiJuaXhvcyIsInN1YiI6Imp3dHNlcnZlciIsInJvb20iOiJOaXhPU1J1bGVzIn0.Vd1WKCytwa2fmqY0iDMv_vTaZaY1rzm_C8HJKWLUvgw'
        """
    )
    assert '<success' not in failed_auth
    assert '<failure' in failed_auth
    assert 'Invalid signature' in failed_auth

    # This JWT was generated using the correct server secret but the wrong issuer (badissuer instead of nixos). Make sure it's rejected.
    failed_auth = client.wait_until_succeeds(
        """
            (
                echo '<open to="jwtserver" version="1.0" xmlns="urn:ietf:params:xml:ns:xmpp-framing"/>'
                sleep 1
                echo '<auth mechanism="ANONYMOUS" xmlns="urn:ietf:params:xml:ns:xmpp-sasl"/>'
                sleep 1
            ) | websocat --insecure --text -H='Sec-Websocket-Protocol: xmpp' 'wss://jwtserver/xmpp-websocket?room=NixOSRules&token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJiYWRpc3N1ZXIiLCJpYXQiOjE2NzIxMjIyNjAsImV4cCI6NDEwMjQ0NDgwMCwiYXVkIjoibml4b3MiLCJzdWIiOiJqd3RzZXJ2ZXIiLCJyb29tIjoiTml4T1NSdWxlcyJ9.yCQ77krJB15WIkFWe5p-opvMAez6G-dQ9hs6R9xzCt0'
        """
    )
    assert '<success' not in failed_auth
    assert '<failure' in failed_auth

    # This JWT was generated using the correct server secret but the wrong subject and audience (badsubject/badaudience). Make sure it's rejected.
    failed_auth = client.wait_until_succeeds(
        """
            (
                echo '<open to="jwtserver" version="1.0" xmlns="urn:ietf:params:xml:ns:xmpp-framing"/>'
                sleep 1
                echo '<auth mechanism="ANONYMOUS" xmlns="urn:ietf:params:xml:ns:xmpp-sasl"/>'
                sleep 1
            ) | websocat --insecure --text -H='Sec-Websocket-Protocol: xmpp' 'wss://jwtserver/xmpp-websocket?room=NixOSRules&token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJuaXhvcyIsImlhdCI6MTY3MjEyMjI2MCwiZXhwIjo0MTAyNDQ0ODAwLCJhdWQiOiJiYWRhdWRpZW5jZSIsInN1YiI6ImJhZHN1YmplY3QiLCJyb29tIjoiTml4T1NSdWxlcyJ9.hyiz6iQasQFmqnMbCuvqFiaVl6YARtxseX1-RoiyqQo'
        """
    )
    assert '<success' not in failed_auth
    assert '<failure' in failed_auth
  '';
})
