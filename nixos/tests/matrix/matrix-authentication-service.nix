{ pkgs, lib, ... }:
let
  mailerCerts = import ../common/acme/server/snakeoil-certs.nix;
  ca_key = mailerCerts.ca.key;
  ca_pem = mailerCerts.ca.cert;

  mkBundle =
    domain:
    pkgs.runCommand "bundle-${domain}"
      {
        nativeBuildInputs = [ pkgs.minica ];
      }
      ''
        minica -ca-cert ${ca_pem} -ca-key ${ca_key} \
          -domains ${domain}
        install -Dm444 -t $out ${domain}/{key,cert}.pem
      '';

  mkDexConfig =
    domain: primaryIP:
    let
      bundle = mkBundle domain;
    in
    {
      enable = true;
      settings = {
        issuer = "https://${dexDomain}:5556";
        storage.type = "sqlite3";
        web = {
          https = "${primaryIP}:5556";
          tlsCert = "${bundle}/cert.pem";
          tlsKey = "${bundle}/key.pem";
        };
        oauth2.skipApprovalScreen = true;
        connectors = [
          {
            type = "mockPassword";
            id = "mock";
            name = "Example";
            config = {
              username = "${testUser}";
              password = "${testPassword}";
            };
          }
        ];
      };
    };

  testUser = "alice";
  testPassword = "AliceSuperSecretPassword123!";

  matrixSecret = "test_matrix_shared_secret_0123456789abcdef";

  synapseDomain = "hs1.test";

  masDomain = "mas1.test";
  masULID = "01KVT6DSNT2MWD7WYMT2FY4SH5";

  dexDomain = "dex1.test";
  oidcClientID = "matrix-authentication-service";
  oidcClientSecret = "lalalalalala";

  loginCodeVerifier = "5kaYTTNVVehUrtJ8xi72ogdfwX8vxHMb3jEUBjyWcXQ";
  loginCodeChallenge = "FbNLCROaJHe4LJQ7FEm7XjqDoWazb3emTE89x6Nx0Ng";
in
{

  name = "matrix-authentication-service-upstream";
  meta = {
    maintainers = pkgs.matrix-authentication-service.meta.maintainers ++ lib.teams.matrix.members;
  };

  nodes = {
    hs1 =
      {
        lib,
        config,
        pkgs,
        nodes,
        ...
      }:
      let
        bundle = mkBundle synapseDomain;
      in
      {
        networking = {
          hostName = lib.head (lib.strings.splitString "." synapseDomain);
          domain = lib.last (lib.strings.splitString "." synapseDomain);
          firewall.allowedTCPPorts = [
            80
            443
            8448
          ];
        };

        services.matrix-synapse = {
          enable = true;
          extras = [ "oidc" ];
          settings = {
            listeners = [
              {
                port = 8448;
                bind_addresses = [
                  config.networking.primaryIPAddress
                ];
                type = "http";
                tls = true;
                x_forwarded = false;
                resources = [
                  {
                    names = [
                      "client"
                    ];
                    compress = true;
                  }
                  {
                    names = [
                      "federation"
                    ];
                    compress = false;
                  }
                ];
              }
            ];

            database = {
              name = "psycopg2";
              args.password = "synapse";
            };
            redis = {
              enabled = true;
              host = "localhost";
              port = config.services.redis.servers.matrix-synapse.port;
            };
            tls_certificate_path = "${bundle}/cert.pem";
            tls_private_key_path = "${bundle}/key.pem";
            public_baseurl = "https://${synapseDomain}:8448";

            # Delegate authentication to MAS
            matrix_authentication_service = {
              enabled = true;
              endpoint = "https://${masDomain}:8080";
              force_http2 = true;
              secret = matrixSecret;
            };
          };
        };
        services.postgresql = {
          enable = true;
          authentication = pkgs.lib.mkOverride 10 ''
            local all all trust
            host all all 127.0.0.1/32 trust
            host all all ::1/128 trust
          '';

          # The database name and user are configured by the following options:
          #   - services.matrix-synapse.database_name
          #   - services.matrix-synapse.database_user
          #
          # The values used here represent the default values of the module.
          initialScript = pkgs.writeText "synapse-init.sql" ''
            CREATE ROLE "matrix-synapse" WITH LOGIN PASSWORD 'synapse';
            CREATE DATABASE "matrix-synapse" WITH OWNER "matrix-synapse"
              TEMPLATE template0
              LC_COLLATE = "C"
              LC_CTYPE = "C";
          '';
        };
        services.redis.servers.matrix-synapse = {
          enable = true;
          port = 6379;
        };
        security.pki.certificateFiles = [
          ca_pem
        ];
        networking.extraHosts = ''
          ${nodes.mas1.networking.primaryIPAddress} ${masDomain}
          ${nodes.dex1.networking.primaryIPAddress} ${dexDomain}
          ${nodes.hs1.networking.primaryIPAddress} ${synapseDomain}
        '';

        environment.systemPackages = [
          pkgs.matrix-synapse
          pkgs.matrix-authentication-service
        ];
      };

    mas1 =
      { nodes, ... }:
      let
        bundle = mkBundle masDomain;
      in
      {
        services.matrix-authentication-service = {
          enable = true;
          createDatabase = true;
          settings = {
            http = {
              public_base = "https://${masDomain}:8080/";
              tls = {
                certificate_file = "${bundle}/cert.pem";
                key_file = "${bundle}/key.pem";
              };
              listeners = [
                {
                  name = "web";
                  binds = [ { address = "0.0.0.0:8080"; } ];
                  resources = [
                    { name = "discovery"; }
                    { name = "human"; }
                    { name = "oauth"; }
                  ];
                  tls = {
                    certificate_file = "${bundle}/cert.pem";
                    key_file = "${bundle}/key.pem";
                  };
                }
              ];
            };
            matrix = {
              homeserver = "hs1";
              endpoint = "https://${synapseDomain}:8448/";
              secret_file = "/var/lib/matrix-authentication-service/matrix_secret";
            };
            database.uri = "postgresql:///matrix-authentication-service?host=/run/postgresql&user=matrix-authentication-service";
            secrets = {
              encryption_file = "/var/lib/matrix-authentication-service/encryption";
              keys = [
                {
                  kid = "rsa-4096";
                  key_file = "/var/lib/matrix-authentication-service/key_rsa_4096";
                }
              ];
            };
            policy.data.client_registration.allow_insecure_uris = true;
            upstream_oauth2.providers = [
              {
                id = masULID;
                client_id = oidcClientID;
                client_secret = oidcClientSecret;
                issuer = "https://${dexDomain}:5556";
                scope = "openid email profile";
                token_endpoint_auth_method = "client_secret_post";
              }
            ];
          };
        };
        services.postgresql.authentication = pkgs.lib.mkOverride 10 ''
          local all all trust
          host  all all 127.0.0.1/32 trust
          host  all all ::1/128 trust
        '';
        systemd.services.matrix-authentication-service.preStart = ''
          echo -n '${matrixSecret}' > /var/lib/matrix-authentication-service/matrix_secret
          echo -n '0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef' > /var/lib/matrix-authentication-service/encryption
          ${pkgs.openssl}/bin/openssl genrsa -out /var/lib/matrix-authentication-service/key_rsa_4096 4096
        '';
        security.pki.certificateFiles = [ ca_pem ];
        networking.extraHosts = ''
          ${nodes.hs1.networking.primaryIPAddress} ${synapseDomain}
          ${nodes.dex1.networking.primaryIPAddress} ${dexDomain}
        '';
        networking.firewall.allowedTCPPorts = [
          8080
          8081
        ];
      };

    dex1 =
      {
        lib,
        config,
        nodes,
        ...
      }:
      {
        services.dex = lib.mkMerge [
          (mkDexConfig dexDomain config.networking.primaryIPAddress)
          {
            settings.staticClients = [
              {
                id = oidcClientID;
                name = "Matrix";
                redirectURIs = [ "https://${masDomain}:8080/upstream/callback/${masULID}" ];
                secret = oidcClientSecret;
              }
            ];
          }
        ];
        security.pki.certificateFiles = [ ca_pem ];
        networking.extraHosts = ''
          ${nodes.hs1.networking.primaryIPAddress} ${synapseDomain}
          ${nodes.mas1.networking.primaryIPAddress} ${masDomain}
          ${nodes.dex1.networking.primaryIPAddress} ${dexDomain}
        '';
        networking.firewall.allowedTCPPorts = [ 5556 ];
      };
  };

  testScript = ''
    import json
    import re


    COOKIES = "-c /tmp/cookies.txt -b /tmp/cookies.txt"


    def visit(url, *opts):
        """Follow the whole redirect chain from `url`; return `effective_url` and response body."""
        out = dex1.succeed(
            f"curl -sL {COOKIES} {' '.join(opts)} -w '\\n%{{url_effective}}' '{url.strip()}'"
        )
        body, _, effective = out.rpartition("\n")
        return effective.strip(), body


    def location(url, *opts):
        """Request `url` and return where it redirects, but don't follow it.

        Used for the OAuth callback, which points at http://localhost:1234 where
        nothing is listening, so `curl --location` would ultimately fail.
        """
        return dex1.succeed(
            f"curl -s {COOKIES} -w '%{{redirect_url}}' -o /dev/null "
            f"{' '.join(opts)} '{url.strip()}'"
        ).strip()


    def extract_csrf(html):
        match = re.search(r'name="csrf" value="([^"]+)"', html)
        assert match is not None, f"unable to find csrf token in {html}"
        return match.group(1)


    def authorize():
        """Start the OIDC flow and return the first redirect URL."""
        return dex1.succeed(
            "scope='openid urn:matrix:org.matrix.msc2967.client:api:*'; "
            "curl -fs -G -w '%{redirect_url}' -o /dev/null https://${masDomain}:8080/authorize "
            f"-d response_type=code -d client_id={client_id} "
            "-d redirect_uri=http://localhost:1234/callback "
            '--data-urlencode "scope=$scope" '
            "-d state=somestate -d code_challenge=${loginCodeChallenge} "
            "-d code_challenge_method=S256"
        )


    start_all()

    # wait locally until units are ready
    dex1.wait_for_unit("dex.service")
    hs1.wait_for_unit("matrix-synapse.service")
    mas1.wait_for_unit("matrix-authentication-service.service")
    hs1.wait_until_succeeds("curl --fail -s --cacert ${ca_pem} https://${synapseDomain}:8448/")
    hs1.wait_until_succeeds("journalctl -u matrix-synapse.service | grep -q 'Connected to redis'")
    hs1.require_unit_state("postgresql.target")
    mas1.wait_for_open_port(8080)

    # cross-node reachability
    mas1.wait_until_succeeds("curl --fail --silent --show-error --cacert ${ca_pem} https://${dexDomain}:5556/.well-known/openid-configuration")
    mas1.wait_until_succeeds("curl --fail --silent --show-error --cacert ${ca_pem} https://${synapseDomain}:8448/")
    hs1.wait_until_succeeds("curl --fail --silent --show-error https://${masDomain}:8080/.well-known/openid-configuration")

    # Register a fresh OAuth client and grab its client_id
    client_id_resp = json.loads(dex1.succeed(
        "curl -s -X POST https://${masDomain}:8080/oauth2/registration "
        "-H 'Content-Type: application/json' "
        "-d '{ \"client_name\": \"test_client\", \"client_uri\": \"http://localhost:1234/\", \"redirect_uris\": [\"http://localhost:1234/callback\"], \"response_types\": [\"code\"], \"grant_types\": [ \"authorization_code\" ], \"token_endpoint_auth_method\": \"none\" }'"
    ))
    t.assertIn("client_id", client_id_resp)
    client_id = client_id_resp["client_id"]

    with subtest("Register"):
        location(authorize())  # follow /authorize to put the session cookie in the jar.

        # To login with Upstream (Dex) the page returns a clickable link; we hardcode
        # it here since we already know its shape.
        upstream_url = f"https://${masDomain}:8080/upstream/authorize/${masULID}?id={client_id}&kind=continue_authorization_grant"
        _, mock_body = visit(upstream_url)
        _match = re.search(r'state=([^"&]+)', mock_body)
        assert _match is not None, f"unable to find state in {mock_body}"
        oidc_state = _match.group(1)

        next_url, body = visit(
            f"https://${dexDomain}:5556/auth/mock/login?back=&state={oidc_state}",
            "-d 'login=${testUser}'",
            "-d 'password=${testPassword}'",
        )
        next_url, body = visit(next_url, f"-d 'csrf={extract_csrf(body)}&action=register&username=${testUser}'")
        visit(next_url, f"-d 'csrf={extract_csrf(body)}&action=set&display_name=Alice'")

    with subtest("Login"):
        consent_url, body = visit(authorize())

        # Alice already has a session cookie, so /consent redirects straight to the callback.
        callback_url = location(consent_url, f"-d 'csrf={extract_csrf(body)}&action=consent'")
        _match = re.search(r'code=([^&]+)', callback_url)
        assert _match is not None, f"unable to find code in {callback_url}"
        code = _match.group(1)

        access_token_resp = json.loads(dex1.succeed(
            "curl -s -X POST https://${masDomain}:8080/oauth2/token "
            "-d 'grant_type=authorization_code' "
            f"-d 'client_id={client_id}' -d 'code={code}' "
            "-d 'redirect_uri=http://localhost:1234/callback' "
            "-d 'code_verifier=${loginCodeVerifier}'"
        ))
        t.assertIn("access_token", access_token_resp)
        access_token = access_token_resp["access_token"]

    with subtest("Create Room"):
        room_id_resp = json.loads(dex1.succeed(
            "curl --fail -s -X POST https://${synapseDomain}:8448/_matrix/client/v3/createRoom "
            "-H 'Content-Type: application/json' "
            f"-H 'Authorization: Bearer {access_token}' "
            "-d '{}'"
        ))
        t.assertIn("room_id", room_id_resp)
        room_id = room_id_resp["room_id"]

    with subtest("Send Message"):
        dex1.succeed(
            "curl -fs -X POST "
            f"https://${synapseDomain}:8448/_matrix/client/v3/rooms/{room_id}/send/m.room.message "
            f"-H 'Authorization: Bearer {access_token}' "
            "-H 'Content-Type: application/json' "
            "-d '{\"msgtype\":\"m.text\",\"body\":\"hello from alice\"}' | grep event_id"
        )
  '';
}
