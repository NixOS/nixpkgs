{ pkgs, ... }:
let

  ca_key = mailerCerts.ca.key;
  ca_pem = mailerCerts.ca.cert;

  bundle =
    pkgs.runCommand "bundle"
      {
        nativeBuildInputs = [ pkgs.minica ];
      }
      ''
        minica -ca-cert ${ca_pem} -ca-key ${ca_key} \
          -domains localhost
        install -Dm444 -t $out localhost/{key,cert}.pem
      '';

  mailerCerts = import ../common/acme/server/snakeoil-certs.nix;
  mailerDomain = mailerCerts.domain;
  registrationSharedSecret = "unsecure123";
  authenticationServiceClientSecret = "unsecure123";
  authenticationServiceAdminApiSecret = "unsecure123";
  testUser = "alice";
  testPassword = "alicealice";
  testEmail = "alice@example.com";

  listeners = [
    {
      port = 8448;
      bind_addresses = [
        "127.0.0.1"
        "::1"
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

in
{

  name = "matrix-synapse-authentication-service";
  meta = with pkgs.lib; {
    maintainers = teams.matrix.members;
  };

  nodes = {
    # Since 0.33.0, matrix-synapse doesn't allow underscores in server names
    serverpostgres =
      {
        pkgs,
        nodes,
        config,
        ...
      }:
      let
        mailserverIP = nodes.mailserver.networking.primaryIPAddress;
      in
      {
        services.matrix-synapse = {
          enable = true;
          plugins = [
            pkgs.python3Packages.authlib
          ];
          settings = {
            inherit listeners;
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
            registration_shared_secret = registrationSharedSecret;
            public_baseurl = "https://example.com";
            email = {
              smtp_host = mailerDomain;
              smtp_port = 25;
              require_transport_security = true;
              notif_from = "matrix <matrix@${mailerDomain}>";
              app_name = "Matrix";
            };
            experimental_features = {
              msc3861 = {
                enabled = true;
                issuer = "http://localhost:8080/";
                client_id = "0000000000000000000SYNAPSE";
                client_auth_method = "client_secret_basic";
                client_secret = authenticationServiceClientSecret;
                admin_token = authenticationServiceAdminApiSecret;
                account_management_url = "http://localhost:8080/account";
              };
            };
          };
        };

        services.matrix-authentication-service = {
          enable = true;
          createDatabase = true;
          extraConfigFiles = [
            (pkgs.writeText "mas-extra-config.yml" ''
              secrets:
                encryption: 85c39ce195bd01d17b583687edf20ae09eede66f4ce043f15afc2afa719249c9
                keys:
                - kid: LYeYXYzVil
                  key: |
                    -----BEGIN RSA PRIVATE KEY-----
                    MIIEpAIBAAKCAQEA1l1iXIE9yFksgKmJ58hk9oj7UQ4iX5HX9Ll/EUDCRu+fuPuB
                    kYnski19RNoVIWQt3f8HYTeQLF1vhvj9AKFw+F0jklkC8/YrHzNPiB7LS08X4+K8
                    1DW+YI7EY0u0iB+uaChHvK8zYrk+qRmH0OGR7LdXRNqM75xMglkcnMagFbc/3ipO
                    47SgHFaUGkM62epeQPIsJq6BicxCyH/LhoccUtnj5+EOAF+eo8QPRj+ISfDdCebS
                    L7iYnpECFggVlexgbVRfeFtxDfHu5hpxjKwbTKYjDLMrZwlI0js4ZN9qchREAJ21
                    km4Xq4bqP+Pf0QiaEjeoqF/ZMmCFYY2gT3DSUQIDAQABAoIBAHLwd4EqOzplthr2
                    zN7e8GPQZxC7B2s/BBBQNfXGR2VJrta85GhpD9QBWB3G4XWaBY325LoX1NI090vj
                    zaS865oANsaNu6ub3ttH4+kUueSTcDfcp2sRthaH9n1XZmFmu1lV38EoH+FbemGp
                    Ms2pZVkLpVth5BfGMq/hoBnf1o5NTACSHd2InQnUQAbY16NvYZiY37hI3LllyIPI
                    z7hBvFcRf2JD3Bn7nmV+lTBOtcYA5f6ZrO0V2Ah75AGb6QAUSWgV9edqXkp6OmAV
                    jcVqfVsPwoPRpaarQ4M1lcvhYgwBKuUXFtcNPqqNk9ldYuYy/UW4E+psRrXkwvs2
                    50TB78ECgYEA3nx7XBZhYrvUEqLUYeIRhnRGoY0/snyjAMibl6NoJZLpyrk+b70x
                    Dh1k6LY9RwLfxRHDqnnHy9YY5Iu9QBTBYud8dD0JNOUUC8QWYV1G7AYLS9oe8kM5
                    z4aWhgNR3a9DidPQtv2SyK+1ZmGhB80T7nDlsK17fjjTUnj7lMhgnbUCgYEA9qe4
                    zzHfCZsDwoPPuMuAkZIjRxnwReY9fyAGGMdW4VrOgrOyVj4dDF0/R8p3LlS+TiUw
                    6bVlWqbP+H3Zkx9VaH7EUmiTFulshi/MxSBizdj4SHDhYHK+4H5PkeDusMTGAvOk
                    QaXB8ZbulHT3mdUc8lHucRHw2TIs8O8zaFBMo60CgYEAyCsxBYnxNlaNF/M9p48w
                    e0qT3XdqjphKQ0M5kXVoFx4Vj9mYTgnmX6+cgS6s9P2l+/TemLsWQdMu9DixHT1P
                    PD/OnfnoFZngrjFOfWzhiSpq8WSeIRLQqWCKfqnv9sZfulpC1tBPRpWnXCSML6uX
                    uhgC3zFGASr5HaNRneul2V0CgYBbkYSQlwkgPcY1jk2tYw9F+6TRHpYOvR0TdsYM
                    qOReISINb7zDO6f5ER0O/+Ei+B72T+RKvybzcn4+2CnP7o/8jSNBHMWOefXqExDI
                    Fe/YT7ZM3mstLSwjl4DevUyfn02LhvvxyyGnGMtVnd7V40Ity7DjlS9+0pvQjlzd
                    WwI4uQKBgQDQA3JSEl95T2nYmmlvX8a5rSNSSK/d6GRDvaNFAk659Jf3X2aYpHFM
                    TRO5t2EDIrBCpgBG2Tj9yOnm9Zht/T+783ziQ/6p2q1QX7Lfr6MiwnND4Cw0ZvYL
                    9xDiujZMtAEaEiz0a6pfHn/EfTA6Qvw/KYFmtXFGa+KuOwX4KgFlwQ==
                    -----END RSA PRIVATE KEY-----
                - kid: cdMTgbM9rx
                  key: |
                    -----BEGIN EC PRIVATE KEY-----
                    MHcCAQEEIOlSK0D4WKNjPrfxojWNJSoFzYJ7TUNC4qVv0C3b+LSioAoGCCqGSM49
                    AwEHoUQDQgAE0lqYrp1gpDmCZASZ1L7Y5r0Kk9kbv6Qjn8FXzP4ujnFN8tFkHsun
                    MqmeW3j5Qmtw24gcEU1IPW6QwMz/ozosWQ==
                    -----END EC PRIVATE KEY-----
                - kid: Hb1P9OK0rc
                  key: |
                    -----BEGIN EC PRIVATE KEY-----
                    MIGkAgEBBDAuDEN6zp1bBf2R3bBEKn8yGKlkV8jfNe1lZ1yvfsVWBPbVBoxJcEWG
                    krR1vBYdtjSgBwYFK4EEACKhZANiAAThozHhNOUZcybKe7W9K5zVZIXgmM3Fze/e
                    s6bHLpwPR1EEYNARPW7aLPPjf4d+iPXW5y6J0KCKvaXWvFAM9eL6a8X/W93VZmgO
                    8A9QN/PWOUz2ZOsp1xLWvgmZl4zHYNw=
                    -----END EC PRIVATE KEY-----
                - kid: NpIOF10t5M
                  key: |
                    -----BEGIN EC PRIVATE KEY-----
                    MHQCAQEEIP3Vit8kpPw+JxnPLviS7+bM1EAJquG+0HFN6MT4Q1eDoAcGBSuBBAAK
                    oUQDQgAE2rnrYryxmN3RAgwh9JqrS7/cft592o9dG6C7sUloIpYcZVmZsVGpOUzB
                    UMyVVDVWwkAdxfASbDGu4yiSwy9uEw==
                    -----END EC PRIVATE KEY-----

            '')
          ];
          settings = {
            clients = [
              {
                client_id = "0000000000000000000SYNAPSE";
                client_auth_method = "client_secret_basic";
                client_secret = authenticationServiceClientSecret;
              }
            ];
            matrix = {
              homeserver = config.services.matrix-synapse.settings.server_name;
              secret = authenticationServiceAdminApiSecret;
              endpoint = "https://localhost:8448";
            };
            upstream_oauth2 = {
              providers = [
                {
                  id = "01H8PKNWKKRPCBW4YGH1RWV279";
                  issuer = "https://<keycloak>/realms/<realm>";
                  token_endpoint_auth_method = "client_secret_basic";
                  client_id = "matrix-authentication-service";
                  client_secret = "<client-secret>";
                  scope = "openid profile email";
                  claims_imports = {
                    localpart = {
                      action = "require";
                      template = "{{ user.preferred_username }}";
                    };
                    displayname = {
                      action = "suggest";
                      template = "{{ user.name }}";
                    };
                    email = {
                      action = "suggest";
                      template = "{{ user.email }}";
                      set_email_verification = "always";
                    };
                  };
                }
              ];
            };
          };
        };

        services.postgresql = {
          enable = true;

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
          port = 6380;
        };

        networking.extraHosts = ''
          ${mailserverIP} ${mailerDomain}
        '';

        security.pki.certificateFiles = [
          mailerCerts.ca.cert
          ca_pem
        ];

        environment.systemPackages =
          let
            sendTestMailStarttls = pkgs.writeScriptBin "send-testmail-starttls" ''
              #!${pkgs.python3.interpreter}
              import smtplib
              import ssl

              ctx = ssl.create_default_context()

              with smtplib.SMTP('${mailerDomain}') as smtp:
                smtp.ehlo()
                smtp.starttls(context=ctx)
                smtp.ehlo()
                smtp.sendmail('matrix@${mailerDomain}', '${testEmail}', 'Subject: Test STARTTLS\n\nTest data.')
                smtp.quit()
            '';

            obtainTokenAndRegisterEmail =
              let
                # adding the email through the API is quite complicated as it involves more than one step and some
                # client-side calculation
                insertEmailForAlice = pkgs.writeText "alice-email.sql" ''
                  INSERT INTO user_threepids (user_id, medium, address, validated_at, added_at) VALUES ('${testUser}@serverpostgres', 'email', '${testEmail}', '1629149927271', '1629149927270');
                '';
              in
              pkgs.writeScriptBin "obtain-token-and-register-email" ''
                #!${pkgs.runtimeShell}
                set -o errexit
                set -o pipefail
                set -o nounset
                su postgres -c "psql -d matrix-synapse -f ${insertEmailForAlice}"
                curl --fail -XPOST 'https://localhost:8448/_matrix/client/r0/account/password/email/requestToken' -d '{"email":"${testEmail}","client_secret":"foobar","send_attempt":1}' -v
              '';
          in
          [
            sendTestMailStarttls
            pkgs.matrix-synapse
            obtainTokenAndRegisterEmail
          ];
      };

    # test mail delivery
    mailserver =
      args:
      let
      in
      {
        security.pki.certificateFiles = [
          mailerCerts.ca.cert
        ];

        networking.firewall.enable = false;

        services.postfix = {
          enable = true;
          hostname = "${mailerDomain}";
          # open relay for subnet
          networksStyle = "subnet";
          enableSubmission = true;
          tlsTrustedAuthorities = "${mailerCerts.ca.cert}";
          sslCert = "${mailerCerts.${mailerDomain}.cert}";
          sslKey = "${mailerCerts.${mailerDomain}.key}";

          # blackhole transport
          transport = "example.com discard:silently";

          config = {
            debug_peer_level = "10";
            smtpd_relay_restrictions = [
              "permit_mynetworks"
              "reject_unauth_destination"
            ];

            # disable obsolete protocols, something old versions of twisted are still using
            smtpd_tls_protocols = "TLSv1.3, TLSv1.2, !TLSv1.1, !TLSv1, !SSLv2, !SSLv3";
            smtp_tls_protocols = "TLSv1.3, TLSv1.2, !TLSv1.1, !TLSv1, !SSLv2, !SSLv3";
            smtpd_tls_mandatory_protocols = "TLSv1.3, TLSv1.2, !TLSv1.1, !TLSv1, !SSLv2, !SSLv3";
            smtp_tls_mandatory_protocols = "TLSv1.3, TLSv1.2, !TLSv1.1, !TLSv1, !SSLv2, !SSLv3";
          };
        };
      };
  };

  testScript = ''
    start_all()
    mailserver.wait_for_unit("postfix.service")
    serverpostgres.succeed("send-testmail-starttls")
    serverpostgres.wait_for_unit("matrix-synapse.service")
    serverpostgres.wait_until_succeeds(
        "curl --fail -L --cacert ${ca_pem} https://localhost:8448/"
    )
    serverpostgres.wait_until_succeeds(
        "journalctl -u matrix-synapse.service | grep -q 'Connected to redis'"
    )
    serverpostgres.require_unit_state("postgresql.service")
    serverpostgres.wait_for_unit("matrix-authentication-service.service")
    serverpostgres.wait_until_succeeds(
        "curl --fail -L http://localhost:8080/"
    )
  '';

}
