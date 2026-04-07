{ lib, ... }:
let
  port = 3000;
  host = "kanbn";
in
{
  name = "kanbn";
  meta.maintainers = with lib.maintainers; [ mkg20001 ];

  nodes.${host} =
    { pkgs, ... }:
    {
      networking.firewall.allowedTCPPorts = [ port ];

      services.kanbn = {
        enable = true;
        host = "0.0.0.0";
        inherit port;
        baseUrl = "http://${host}:${toString port}";
        extraEnvironment = {
          # Required by better-auth; the test does not depend on the value.
          BETTER_AUTH_SECRET = "test-secret-test-secret-test-secret-32b";
          # Allow email/password sign-up so the test can create a user.
          NEXT_PUBLIC_ALLOW_CREDENTIALS = "true";
          NEXT_PUBLIC_DISABLE_EMAIL = "true";
          LOG_LEVEL = "info";
        };
      };
    };

  testScript = ''
    import json

    ${host}.wait_for_unit("postgresql.target")
    ${host}.wait_for_unit("kanbn-migrate.service")
    ${host}.wait_for_unit("kanbn.service")
    ${host}.wait_for_open_port(${toString port})

    # The landing page should render.
    ${host}.wait_until_succeeds(
        "curl -sSf -o /dev/null http://localhost:${toString port}/",
        timeout=120,
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
        "http://localhost:${toString port}/api/auth/sign-up/email"
    )
    data = json.loads(resp)
    assert "user" in data, f"sign-up did not return a user: {data}"
    assert data["user"]["email"] == "test@example.com", data
  '';
}
