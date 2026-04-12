{ lib, ... }:
let
  domain = "docs.local";
  oidcAddr = "127.0.0.1:8080";
  s3Addr = "127.0.0.1:9000";

  garageAccessKey = "GKaaaaaaaaaaaaaaaaaaaaaaaa";
  garageSecretKey = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
in

{
  name = "lasuite-docs";
  meta.maintainers = with lib.maintainers; [
    soyouzpanda
  ];

  nodes.machine =
    { pkgs, ... }:
    {
      virtualisation.diskSize = 4 * 1024;
      virtualisation.memorySize = 4 * 1024;

      networking.hosts."127.0.0.1" = [ domain ];

      environment.systemPackages = with pkgs; [
        jq
      ];

      services.lasuite-docs = {
        enable = true;
        enableNginx = true;
        redis.createLocally = true;
        postgresql.createLocally = true;

        inherit domain;
        s3Url = "http://${s3Addr}/lasuite-docs";

        settings = {
          DJANGO_SECRET_KEY_FILE = pkgs.writeText "django-secret-file" ''
            8540db59c03943d48c3ed1a0f96ce3b560e0f45274f120f7ee4dace3cc366a6b
          '';

          OIDC_OP_JWKS_ENDPOINT = "http://${oidcAddr}/dex/keys";
          OIDC_OP_AUTHORIZATION_ENDPOINT = "http://${oidcAddr}/dex/auth/mock";
          OIDC_OP_TOKEN_ENDPOINT = "http://${oidcAddr}/dex/token";
          OIDC_OP_USER_ENDPOINT = "http://${oidcAddr}/dex/userinfo";
          OIDC_RP_CLIENT_ID = "lasuite-docs";
          OIDC_RP_SIGN_ALGO = "RS256";
          OIDC_RP_SCOPES = "openid email";
          OIDC_RP_CLIENT_SECRET = "lasuitedocsclientsecret";

          LOGIN_REDIRECT_URL = "http://${domain}";
          LOGIN_REDIRECT_URL_FAILURE = "http://${domain}";
          LOGOUT_REDIRECT_URL = "http://${domain}";

          AWS_S3_ENDPOINT_URL = "http://${s3Addr}";
          AWS_S3_ACCESS_KEY_ID = garageAccessKey;
          AWS_S3_SECRET_ACCESS_KEY = garageSecretKey;
          AWS_STORAGE_BUCKET_NAME = "lasuite-docs";
          MEDIA_BASE_URL = "http://${domain}";

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
          issuer = "http://${oidcAddr}/dex";
          storage = {
            type = "postgres";
            config.host = "/var/run/postgresql";
          };
          web.http = "127.0.0.1:8080";
          oauth2.skipApprovalScreen = true;
          staticClients = [
            {
              id = "lasuite-docs";
              name = "Docs";
              redirectURIs = [ "http://${domain}/api/v1.0/callback/" ];
              secretFile = "/etc/dex/lasuite-docs";
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

      services.garage = {
        enable = true;
        package = pkgs.garage_2;
        settings = {
          rpc_bind_addr = "127.0.0.1:3901";
          rpc_public_addr = "127.0.0.1:3901";
          rpc_secret = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
          replication_factor = 1;

          s3_api = {
            s3_region = "garage";
            api_bind_addr = s3Addr;
          };
        };
      };
      environment.etc."dex/lasuite-docs" = {
        mode = "0400";
        user = "dex";
        text = "lasuitedocsclientsecret";
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
      machine.wait_for_unit("garage.service")
      machine.wait_for_unit("lasuite-docs.service")
      machine.wait_for_unit("lasuite-docs-celery.service")
      machine.wait_for_unit("lasuite-docs-collaboration-server.service")

    with subtest("Create S3 bucket"):
      machine.wait_for_open_port(3901)
      garage_node_id = machine.succeed("garage status | tail -n1 | awk '{ print $1 }'")
      machine.succeed(f"garage layout assign -c 100MB -z garage {garage_node_id}")
      machine.succeed("garage layout apply --version 1")
      machine.succeed("garage key import ${garageAccessKey} ${garageSecretKey} --yes")
      machine.succeed("garage bucket create lasuite-docs")
      machine.succeed("garage bucket allow --read --write --owner lasuite-docs --key ${garageAccessKey}")

    with subtest("Wait for web servers to start"):
      machine.wait_until_succeeds("curl -fs 'http://${domain}/api/v1.0/authenticate/'", timeout=120)
      machine.wait_until_succeeds("curl -fs '${oidcAddr}/dex/auth/mock?client_id=lasuite-docs&response_type=code&redirect_uri=http://${domain}/api/v1.0/callback/&scope=openid'", timeout=120)

    with subtest("Login"):
      state, nonce = machine.succeed("curl -fs -c cjar 'http://${domain}/api/v1.0/authenticate/' -w '%{redirect_url}' | sed -n 's/.*state=\\(.*\\)&nonce=\\(.*\\)/\\1 \\2/p'").strip().split(' ')

      oidc_state = machine.succeed(f"curl -fs '${oidcAddr}/dex/auth/mock?client_id=lasuite-docs&response_type=code&redirect_uri=http://${domain}/api/v1.0/callback/&scope=openid+email&state={state}&nonce={nonce}' | sed -n 's/.*state=\\(.*\\)\">.*/\\1/p'").strip()

      code = machine.succeed(f"curl -fs '${oidcAddr}/dex/auth/mock/login?back=&state={oidc_state}' -d 'login=admin&password=password' -w '%{{redirect_url}}' | sed -n 's/.*code=\\(.*\\)&.*/\\1/p'").strip()
      print(f"Got approval code {code}")

      machine.succeed(f"curl -fs -c cjar -b cjar 'http://${domain}/api/v1.0/callback/?code={code}&state={state}'")

    with subtest("Create a document"):
      csrf_token = machine.succeed("grep csrftoken cjar | cut -f 7 | tr -d '\n'")

      document_id = machine.succeed(f"curl -fs -c cjar -b cjar 'http://${domain}/api/v1.0/documents/' -X POST -H 'X-CSRFToken: {csrf_token}' -H 'Referer: http://${domain}' | jq .id -r").strip()

      print(f"Created document with id {document_id}")
  '';
}
