{ lib, ... }:
let
  domain = "meet.local";
  oidcDomain = "127.0.0.1:8080";
in

{
  name = "lasuite-meet";
  meta.maintainers = with lib.maintainers; [ soyouzpanda ];

  nodes.machine =
    { pkgs, ... }:
    {
      virtualisation.memorySize = 4 * 1024;

      networking.hosts."127.0.0.1" = [ domain ];

      environment.systemPackages = with pkgs; [ jq ];

      services.lasuite-meet = {
        enable = true;
        enableNginx = true;
        livekit = {
          enable = true;
          keyFile = pkgs.writeText "lasuite-meet-livekit-keys" ''
            lasuite-meet: ca50qKzxEXVIu61wHshAyJNzlWw8vlIwUuzxQbUK1rG
          '';
        };
        redis.createLocally = true;
        postgresql.createLocally = true;

        inherit domain;

        settings = {
          DJANGO_SECRET_KEY_FILE = pkgs.writeText "django-secret-file" ''
            8540db59c03943d48c3ed1a0f96ce3b560e0f45274f120f7ee4dace3cc366a6b
          '';

          OIDC_OP_JWKS_ENDPOINT = "http://${oidcDomain}/dex/keys";
          OIDC_OP_AUTHORIZATION_ENDPOINT = "http://${oidcDomain}/dex/auth/mock";
          OIDC_OP_TOKEN_ENDPOINT = "http://${oidcDomain}/dex/token";
          OIDC_OP_USER_ENDPOINT = "http://${oidcDomain}/dex/userinfo";
          OIDC_RP_CLIENT_ID = "lasuite-meet";
          OIDC_RP_SIGN_ALGO = "RS256";
          OIDC_RP_SCOPES = "openid email";
          OIDC_RP_CLIENT_SECRET = "lasuitemeetclientsecret";

          LOGIN_REDIRECT_URL = "http://${domain}";
          LOGIN_REDIRECT_URL_FAILURE = "http://${domain}";
          LOGOUT_REDIRECT_URL = "http://${domain}";

          LIVEKIT_API_KEY = "lasuite-meet";
          LIVEKIT_API_SECRET = "ca50qKzxEXVIu61wHshAyJNzlWw8vlIwUuzxQbUK1rG";

          # Disable HTTPS feature in tests because we're running on a HTTP connection
          DJANGO_SECURE_PROXY_SSL_HEADER = "";
          DJANGO_SECURE_SSL_REDIRECT = false;
          DJANGO_CSRF_COOKIE_SECURE = false;
          DJANGO_SESSION_COOKIE_SECURE = false;
          DJANGO_CSRF_TRUSTED_ORIGINS = "http://*";
        };
      };

      services.dex = {
        enable = true;
        settings = {
          issuer = "http://${oidcDomain}/dex";
          storage = {
            type = "postgres";
            config.host = "/var/run/postgresql";
          };
          web.http = "127.0.0.1:8080";
          oauth2.skipApprovalScreen = true;
          staticClients = [
            {
              id = "lasuite-meet";
              name = "Meet";
              redirectURIs = [ "http://${domain}/api/v1.0/callback/" ];
              secretFile = "/etc/dex/lasuite-meet";
            }
          ];
          connectors = [
            {
              type = "mockPassword";
              id = "mock";
              name = "Example";
              config = {
                username = "admin";
                password = "password";
              };
            }
          ];
        };
      };

      environment.etc."dex/lasuite-meet" = {
        mode = "0400";
        user = "dex";
        text = "lasuitemeetclientsecret";
      };

      services.postgresql = {
        enable = true;
        ensureDatabases = [ "dex" ];
        ensureUsers = [
          {
            name = "dex";
            ensureDBOwnership = true;
          }
        ];
      };
    };

  testScript = ''
    with subtest("Wait for units to start"):
      machine.wait_for_unit("dex.service")
      machine.wait_for_unit("lasuite-meet.service")
      machine.wait_for_unit("lasuite-meet-celery.service")

    with subtest("Wait for web servers to start"):
      machine.wait_until_succeeds("curl -fs 'http://${domain}/api/v1.0/authenticate/'", timeout=120)
      machine.wait_until_succeeds("curl -fs '${oidcDomain}/dex/auth/mock?client_id=lasuite-meet&response_type=code&redirect_uri=http://${domain}/api/v1.0/callback/&scope=openid'", timeout=120)

    with subtest("Login"):
      state, nonce = machine.succeed("curl -fs -c cjar 'http://${domain}/api/v1.0/authenticate/' -w '%{redirect_url}' | sed -n 's/.*state=\\(.*\\)&nonce=\\(.*\\)/\\1 \\2/p'").strip().split(' ')

      oidc_state = machine.succeed(f"curl -fs '${oidcDomain}/dex/auth/mock?client_id=lasuite-meet&response_type=code&redirect_uri=http://${domain}/api/v1.0/callback/&scope=openid+email&state={state}&nonce={nonce}' | sed -n 's/.*state=\\(.*\\)\">.*/\\1/p'").strip()

      code = machine.succeed(f"curl -fs '${oidcDomain}/dex/auth/mock/login?back=&state={oidc_state}' -d 'login=admin&password=password' -w '%{{redirect_url}}' | sed -n 's/.*code=\\(.*\\)&.*/\\1/p'").strip()
      print(f"Got approval code {code}")

      machine.succeed(f"curl -fs -c cjar -b cjar 'http://${domain}/api/v1.0/callback/?code={code}&state={state}'")

    with subtest("Create a room"):
      csrf_token = machine.succeed("grep csrftoken cjar | cut -f 7 | tr -d '\n'")

      room_id = machine.succeed(f"curl -fs -c cjar -b cjar 'http://${domain}/api/v1.0/rooms/' -X POST -H 'Content-Type: application/json' -H 'X-CSRFToken: {csrf_token}' -H 'Referer: http://${domain}' -d '{{\"name\": \"aaa-bbbb-ccc\"}}' | jq .id -r").strip()

      print(f"Created room with id {room_id}")
  '';
}
