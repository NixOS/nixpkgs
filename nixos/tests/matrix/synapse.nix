{ pkgs, ... }:
let
  ca_key = mailerCerts.ca.key;
  ca_pem = mailerCerts.ca.cert;

  aliceName = "alice";
  alicePassword = "alicealice";
  aliceEmail = "alice@example.com";

  bobName = "bob";
  bobPassword = "hunter2";

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

  mailerCerts = import ../common/acme/server/snakeoil-certs.nix;
  mailerDomain = mailerCerts.domain;
  registrationSharedSecret = "unsecure123";

  anonHash = "hunter2hunter2hunter2";
  anonHashF = pkgs.writeText "hash" anonHash;

  mkHomeserverBase =
    domain: nodes:
    let
      bundle = mkBundle domain;
    in
    { lib, ... }:
    {
      security.pki.certificateFiles = [
        mailerCerts.ca.cert
      ];

      networking = {
        hostName = lib.head (lib.strings.splitString "." domain);
        domain = lib.last (lib.strings.splitString "." domain);
        firewall.allowedTCPPorts = [
          80
          443
          8448
        ];
      };

      services.nginx = {
        enable = true;
        virtualHosts."${domain}" = {
          sslCertificate = "${bundle}/cert.pem";
          sslCertificateKey = "${bundle}/key.pem";
          addSSL = true;
          locations."/.well-known/matrix/server".extraConfig = ''
            default_type application/json;
            return 200 '${
              builtins.toJSON {
                "m.server" = "${domain}:8448";
              }
            }';
          '';
        };
      };
    };

  mkSynapseConfig =
    domain: primaryIP:
    let
      bundle = mkBundle domain;
    in
    {
      enable = true;
      settings = {
        # We're in a test environment with local machines, so
        # we actually _want_ to use RFC1918 addresses.
        ip_range_blacklist = [ ];

        trusted_key_servers = [
          { server_name = "hs1.test"; }
          { server_name = "hs2.test"; }
        ];

        registration_shared_secret = registrationSharedSecret;
        public_baseurl = "https://${domain}";
        tls_certificate_path = "${bundle}/cert.pem";
        tls_private_key_path = "${bundle}/key.pem";
        listeners = [
          # Using a local listener, otherwise matrix-synapse-register_new_matrix_user will
          # fail because it'll try to connect to the first bind address, but via TLS resulting
          # in a signature verification failure.
          {
            port = 8008;
            type = "http";
            tls = false;
            resources = [
              {
                names = [ "client" ];
                compress = true;
              }
            ];
            bind_addresses = [ "::1" ];
          }
          {
            port = 8448;
            bind_addresses = [
              primaryIP
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
      };
    };
in
{
  name = "matrix-synapse";
  meta = {
    inherit (pkgs.matrix-synapse.meta) maintainers;
  };

  nodes = {
    synapse-with-workers =
      {
        lib,
        config,
        pkgs,
        nodes,
        ...
      }:
      {
        imports = [
          (mkHomeserverBase "hs1.test" nodes)
        ];

        services.matrix-synapse = lib.mkMerge [
          (mkSynapseConfig "hs1.test" config.networking.primaryIPAddress)
          {
            settings = {
              server_name = "hs1.test";
              email = {
                smtp_host = mailerDomain;
                smtp_port = 25;
                require_transport_security = true;
                notif_from = "matrix <matrix@${mailerDomain}>";
                app_name = "Matrix";
              };
              listeners = [
                {
                  path = "/run/matrix-synapse/main_replication.sock";
                  type = "http";
                  resources = [
                    {
                      names = [ "replication" ];
                      compress = false;
                    }
                  ];
                }
              ];
              database = {
                name = "psycopg2";
                args.password = "synapse";
              };
              federation_sender_instances = [ "federation_sender" ];
            };
            configureRedisLocally = true;
            workers = {
              "federation_sender" = { };
            };
          }
        ];

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
                smtp.sendmail('matrix@${mailerDomain}', '${aliceEmail}', 'Subject: Test STARTTLS\n\nTest data.')
                smtp.quit()
            '';

            obtainTokenAndRegisterEmail =
              let
                # adding the email through the API is quite complicated as it involves more than one step and some
                # client-side calculation
                insertEmailForAlice = pkgs.writeText "alice-email.sql" ''
                  INSERT INTO user_threepids (user_id, medium, address, validated_at, added_at) VALUES ('${aliceName}@serverpostgres', 'email', '${aliceEmail}', '1629149927271', '1629149927270');
                '';
              in
              pkgs.writeScriptBin "obtain-token-and-register-email" ''
                #!${pkgs.runtimeShell}
                set -euxo pipefail
                su postgres -c "psql -d matrix-synapse -f ${insertEmailForAlice}"
                curl --fail -XPOST 'https://hs1.test:8448/_matrix/client/r0/account/password/email/requestToken' -d '{"email":"${aliceEmail}","client_secret":"foobar","send_attempt":1}' -v
              '';
          in
          [
            sendTestMailStarttls
            pkgs.matrix-synapse
            obtainTokenAndRegisterEmail
          ];
      };

    mailserver =
      { lib, ... }:
      {
        security.pki.certificateFiles = [
          mailerCerts.ca.cert
        ];

        networking = {
          hostName = lib.head (lib.strings.splitString "." mailerDomain);
          domain = lib.last (lib.strings.splitString "." mailerDomain);
          firewall.enable = false;
        };

        services.postfix = {
          enable = true;
          enableSubmission = true;

          # blackhole transport
          transport = "example.com discard:silently";

          settings.main = {
            myhostname = "${mailerDomain}";
            # open relay for subnet
            mynetworks_style = "subnet";
            debug_peer_level = "10";
            smtpd_relay_restrictions = [
              "permit_mynetworks"
              "reject_unauth_destination"
            ];

            # disable obsolete protocols, something old versions of twisted are still using
            smtpd_tls_protocols = "TLSv1.3, TLSv1.2, !TLSv1.1, !TLSv1, !SSLv2, !SSLv3";
            smtpd_tls_mandatory_protocols = "TLSv1.3, TLSv1.2, !TLSv1.1, !TLSv1, !SSLv2, !SSLv3";
            smtpd_tls_chain_files = [
              "${mailerCerts.${mailerDomain}.key}"
              "${mailerCerts.${mailerDomain}.cert}"
            ];
          };
        };
      };

    synapse-minimal =
      {
        nodes,
        config,
        lib,
        ...
      }:
      {
        imports = [
          (mkHomeserverBase "hs2.test" nodes)
        ];

        services.matrix-synapse = lib.mkMerge [
          (mkSynapseConfig "hs2.test" config.networking.primaryIPAddress)
          {
            settings = {
              database.name = "sqlite3";
              server_name = "hs2.test";
            };
          }
        ];
      };

    client =
      { pkgs, ... }:
      {
        environment.systemPackages = [
          # `pkgs.olm` is cached on c.n.o, even if this test isn't built due
          # to it being allow-listed in `pkgs/top-level/release.nix`.
          (import pkgs.path {
            config = pkgs.config // {
              permittedInsecurePackages = [ "olm-3.2.16" ];
            };
          }).matrix-commander
          pkgs.jq
        ];

        security.pki.certificateFiles = [ mailerCerts.ca.cert ];

        users.users = {
          alice.isNormalUser = true;
          bob.isNormalUser = true;
        };

        networking.useNetworkd = true;
        services.rust-federation-tester = {
          enable = true;
          settings = {
            listen_addr = "unix:/run/rust-federation-tester/rust-federation-tester.sock";
            frontend_url = "http://localhost:8080";
            database_url = "sqlite:///var/lib/rust-federation-tester/db?mode=rwc";
            magic_token_secret = "foobarfoobarfoobarfoobarfoobarfoobarfoobarfoobarfoobarfoobar";
            statistics = {
              enabled = true;
              prometheus_enabled = true;
              anonymization_salt._secret = "${anonHashF}";
              raw_retention_days = 30;
            };
          };
        };
      };
  };

  testScript = ''
    import json
    from pprint import pprint

    start_all()

    synapse_with_workers.wait_for_unit("multi-user.target")
    synapse_minimal.wait_for_unit("multi-user.target")
    mailserver.wait_for_unit("multi-user.target")

    synapse_with_workers.wait_until_succeeds(
        "journalctl -u matrix-synapse.service | grep -q 'Connected to redis'"
    )
    synapse_with_workers.wait_for_unit("matrix-synapse-worker-federation_sender.service");

    with subtest("register user with email confirmation"):
        synapse_with_workers.succeed("send-testmail-starttls")
        synapse_with_workers.succeed("REQUESTS_CA_BUNDLE=${mailerCerts.ca.cert} register_new_matrix_user -u ${aliceName} -p ${alicePassword} -a -k ${registrationSharedSecret} https://hs1.test:8448/")
        synapse_with_workers.succeed("obtain-token-and-register-email")

    with subtest("matrix-synapse-register_new_matrix_user"):
        synapse_minimal.succeed("matrix-synapse-register_new_matrix_user -u ${bobName} -p ${bobPassword} --no-admin")
        synapse_minimal.succeed("[ -e /var/lib/matrix-synapse/homeserver.db ]")

    with subtest("Federation tester"):
        expected_anonymization_hashes = {
            "hs1.test": "0558582846d6e2d90612900d449871dfcbf9878ba78de4a8469d8aba2d9c037b",
            "hs2.test": "d3d88c2033c03b74ec1e086e15c0251514de060de5e51cb381e896f892a5b0cd",
        }

        for n, domain in enumerate(["hs2.test", "hs1.test"], start=3):
            result = json.loads(
                client.succeed(
                    f"curl --fail --unix-socket /run/rust-federation-tester/rust-federation-tester.sock 'http://localhost:8080/api/federation/report?server_name={domain}&stats_opt_in=true'"
                )
            )
            pprint(result)
            t.assertTrue(result["FederationOK"])
            t.assertTrue(result["ConnectionReports"][f"192.168.1.{n}:8448"]["Checks"]["AllChecksOK"])
            t.assertEqual(f"{domain}:8448", result["WellKnownResult"][f"192.168.1.{n}:443"]["m.server"])

            # /metrics are cached for up to 30 seconds
            client.sleep(30)
            metrics = client.succeed("curl --unix-socket /run/rust-federation-tester/rust-federation-tester.sock http://localhost:8080/metrics --fail")
            t.assertRegex(
                metrics,
                f'federation_request_total\\{{server=\\"{expected_anonymization_hashes[domain]}\\",result=\\"success\\",[^}}]+\\}} 1'
            )

    def run_as_alice(cmd):
        return client.succeed(f"sudo -u alice matrix-commander -c /home/alice/credentials.json -s /home/alice/matrix {cmd}")

    def run_as_bob(cmd):
        return client.succeed(f"sudo -u bob matrix-commander -c /home/bob/credentials.json -s /home/bob/matrix {cmd}")

    with subtest("Login"):
        run_as_alice("--login password --homeserver https://hs1.test:8448 --user-login @${aliceName}:hs1.test --password ${alicePassword} --device commander --room-default '#welcome:hs1.test'")
        run_as_bob("--login password --homeserver https://hs2.test:8448 --user-login @${bobName}:hs2.test --password ${bobPassword} --device commander --room-default '#welcome:hs1.test'")

    with subtest("Create/Invite/Join"):
        run_as_alice("--room-create '#welcome:hs1.test'")

        run_as_alice("--room-invite '#welcome:hs1.test' -u @${bobName}:hs2.test")
        run_as_bob("--listen once --room-invites 'list+join'")

    with subtest("Send/receive messages"):
        senders = {
            "alice": ("hs1", run_as_alice),
            "bob": ("hs2", run_as_bob),
        }

        for name, (hs, fn) in senders.items():
            fn(f"-m 'hello, I am {name}'")
            for _, run in senders.values():
                msg_data = json.loads(run("--listen once --listen-self --output json"))
                pprint(msg_data)
                t.assertEqual(msg_data["source"]["content"]["body"], f"hello, I am {name}")
                t.assertEqual(msg_data["source"]["sender"], f"@{name}:{hs}.test")
  '';
}
