import ./make-test-python.nix ({ pkgs, lib, ... }:
let
  uiPort = 1234;
  backendPort = 5678;
  lemmyNodeName = "server";
in
{
  name = "lemmy";
  meta = with lib.maintainers; { maintainers = [ mightyiam ]; };

  nodes = {
    client = { };

    "${lemmyNodeName}" = {
      services.lemmy = {
        enable = true;
        ui.port = uiPort;
        database.createLocally = true;
        settings = {
          hostname = "http://${lemmyNodeName}";
          port = backendPort;
          # Without setup, the /feeds/* and /nodeinfo/* API endpoints won't return 200
          setup = {
            admin_username = "mightyiam";
            admin_password = "ThisIsWhatIUseEverywhereTryIt";
            site_name = "Lemmy FTW";
            admin_email = "mightyiam@example.com";
          };
          # https://github.com/LemmyNet/lemmy/blob/50efb1d519c63a7007a07f11cc8a11487703c70d/crates/utils/src/settings/mod.rs#L52
          database.uri = "postgres:///lemmy?host=/run/postgresql&user=lemmy";
        };
        caddy.enable = true;
      };

      networking.firewall.allowedTCPPorts = [ 80 ];

      # pict-rs seems to need more than 1025114112 bytes
      virtualisation.memorySize = 2000;
    };
  };

  testScript = ''
    server = ${lemmyNodeName}

    with subtest("the backend starts and responds"):
        server.wait_for_unit("lemmy.service")
        server.wait_for_open_port(${toString backendPort})
        server.succeed("curl --fail localhost:${toString backendPort}/api/v3/site")

    with subtest("the UI starts and responds"):
        server.wait_for_unit("lemmy-ui.service")
        server.wait_for_open_port(${toString uiPort})
        server.succeed("curl --fail localhost:${toString uiPort}")

    with subtest("Lemmy-UI responds through the caddy reverse proxy"):
        server.wait_for_unit("network-online.target")
        server.wait_for_unit("caddy.service")
        server.wait_for_open_port(80)
        body = server.execute("curl --fail --location ${lemmyNodeName}")[1]
        assert "Lemmy" in body, f"String Lemmy not found in response for ${lemmyNodeName}: \n{body}"

    with subtest("the server is exposed externally"):
        client.wait_for_unit("network-online.target")
        client.succeed("curl -v --fail ${lemmyNodeName}")

    with subtest("caddy correctly routes backend requests"):
        # Make sure we are not hitting frontend
        server.execute("systemctl stop lemmy-ui.service")

        def assert_http_code(url, expected_http_code, extra_curl_args=""):
            _, http_code = server.execute(f'curl --silent -o /dev/null {extra_curl_args} --fail --write-out "%{{http_code}}" {url}')
            assert http_code == str(expected_http_code), f"expected http code {expected_http_code}, got {http_code}"

        # Caddy responds with HTTP code 502 if it cannot handle the requested path
        assert_http_code("${lemmyNodeName}/obviously-wrong-path/", 502)

        assert_http_code("${lemmyNodeName}/static/js/client.js", 200)
        assert_http_code("${lemmyNodeName}/api/v3/site", 200)

        # A 404 confirms that the request goes to the backend
        # No path can return 200 until after we upload an image to pict-rs
        assert_http_code("${lemmyNodeName}/pictrs/", 404)

        assert_http_code("${lemmyNodeName}/feeds/all.xml", 200)
        assert_http_code("${lemmyNodeName}/nodeinfo/2.0.json", 200)

        assert_http_code("${lemmyNodeName}/some-other-made-up-path/", 404, "-X POST")
        assert_http_code("${lemmyNodeName}/some-other-path", 404, "-H 'Accept: application/activity+json'")
        assert_http_code("${lemmyNodeName}/some-other-path", 404, "-H 'Accept: application/ld+json; profile=\"https://www.w3.org/ns/activitystreams\"'")
  '';
})
