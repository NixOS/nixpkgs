{ lib, ... }:
let
  port = 3000;
  host = "kanbn";
  domain = "kanban.localhost";
in
{
  name = "kanbn";
  meta.maintainers = with lib.maintainers; [ mkg20001 ];

  nodes.${host} =
    { pkgs, ... }:
    {
      networking.firewall.allowedTCPPorts = [
        80
        port
      ];
      # Make `kanban.localhost` resolve on the VM itself so curl can hit
      # nginx by name (matches what an end user does in a browser).
      networking.hosts."127.0.0.1" = [ domain ];

      services.kanbn = {
        enable = true;
        host = "127.0.0.1";
        inherit port;
        baseUrl = "http://${domain}";
        extraEnvironment = {
          # Required by better-auth; the test does not depend on the value.
          BETTER_AUTH_SECRET = "test-secret-test-secret-test-secret-32b";
          # Allow email/password sign-up so the test can create a user.
          NEXT_PUBLIC_ALLOW_CREDENTIALS = "true";
          NEXT_PUBLIC_DISABLE_EMAIL = "true";
          LOG_LEVEL = "info";
        };
      };

      services.nginx = {
        enable = true;
        recommendedProxySettings = true;
        virtualHosts.${domain} = {
          locations."/" = {
            proxyPass = "http://127.0.0.1:${toString port}";
            proxyWebsockets = true;
          };
        };
      };
    };

  testScript = ''
    import json

    ${host}.wait_for_unit("postgresql.target")
    ${host}.wait_for_unit("kanbn-migrate.service")
    ${host}.wait_for_unit("kanbn.service")
    ${host}.wait_for_unit("nginx.service")
    ${host}.wait_for_open_port(${toString port})
    ${host}.wait_for_open_port(80)

    # The landing page should render via nginx.
    ${host}.wait_until_succeeds(
        "curl -sSf -o /dev/null http://${domain}/",
        timeout=120,
    )

    # Regression: kanbn's middleware redirects "/" to "/login" for self-hosted
    # installs. The redirect must respect NEXT_PUBLIC_BASE_URL and NOT leak the
    # internal listen address (127.0.0.1:${toString port}) back to the client,
    # i.e. the Location header must be an absolute URL anchored at the public
    # base URL (http://${domain}/login), regardless of which Host header the
    # client used.
    def location_for(url):
        headers = ${host}.succeed(f"curl -sSI {url}")
        for line in headers.splitlines():
            if line.lower().startswith("location:"):
                return line.split(":", 1)[1].strip()
        raise AssertionError(f"no Location header for {url}: {headers}")

    for url in [
        "http://${domain}/",
        # Bypass nginx and hit the upstream directly via Host header to make
        # sure the redirect still points at the public origin even if the
        # client connected to the internal listener.
        "-H 'Host: ${domain}' http://127.0.0.1:${toString port}/",
        "http://127.0.0.1:${toString port}/",
    ]:
        loc = location_for(url)
        assert loc == "http://${domain}/login", (
            f"redirect for {url!r} does not honor NEXT_PUBLIC_BASE_URL: {loc}"
        )

    # Sign up a user via better-auth and confirm we get back a session.
    payload = json.dumps({
        "email": "test@example.com",
        "password": "hunter22hunter22",
        "name": "Test User",
    })
    resp = ${host}.succeed(
        "curl -sSf -X POST "
        "-H 'Content-Type: application/json' "
        f"-d {json.dumps(payload)} "
        "http://${domain}/api/auth/sign-up/email"
    )
    data = json.loads(resp)
    assert "user" in data, f"sign-up did not return a user: {data}"
    assert data["user"]["email"] == "test@example.com", data
  '';
}
