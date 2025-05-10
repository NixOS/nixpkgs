import ../make-test-python.nix (
  { pkgs, ... }:
  let
    certs = import ../common/acme/server/snakeoil-certs.nix;
    inherit (certs) ca;

    mailerDomain = certs.domain;

    aliceName = "alice";
    alicePassword = "alicealice";
    aliceEmail = "alice@example.com";

    bobName = "bob";
    bobPassword = "hunter2";

    registrationSharedSecret = "alarm23";

    mkKresdConfig = nodes: {
      services.kresd = {
        enable = true;
        extraConfig = ''
          policy.add(policy.suffix(policy.PASS, policy.todnames({
            'test',
          })))

          modules = {
            'hints < iterate'
          }

          hints['hs1.test'] = '${nodes.synapse-with-workers.networking.primaryIPAddress}'
          hints['hs2.test'] = '${nodes.synapse-minimal.networking.primaryIPAddress}'
          hints['${mailerDomain}'] = '${nodes.mailserver.networking.primaryIPAddress}'
        '';
      };
    };

    mkBundle =
      domain:
      pkgs.runCommand "bundle-${domain}"
        {
          nativeBuildInputs = [ pkgs.minica ];
        }
        ''
          minica -ca-cert ${ca.cert} -ca-key ${ca.key} \
            -domains ${domain}
          install -Dm444 -t $out ${domain}/{key,cert}.pem
        '';

    mkHomeserverBase =
      domain: nodes:
      let
        bundle = mkBundle domain;
      in
      {
        security.pki.certificateFiles = [ ca.cert ];

        networking = {
          firewall.allowedTCPPorts = [
            80
            443
            8448
          ];
        };

        services.nginx = {
          enable = true;
          virtualHosts."hs1.test" = {
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
            (mkKresdConfig nodes)
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
                  set -o errexit
                  set -o pipefail
                  set -o nounset
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

      mailserver = {
        security.pki.certificateFiles = [
          ca.cert
        ];

        networking.firewall.enable = false;

        services.postfix = {
          enable = true;
          hostname = "${mailerDomain}";
          # open relay for subnet
          networksStyle = "subnet";
          enableSubmission = true;
          tlsTrustedAuthorities = "${ca.cert}";
          sslCert = "${certs.${mailerDomain}.cert}";
          sslKey = "${certs.${mailerDomain}.key}";

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
            (mkKresdConfig nodes)
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
        { pkgs, nodes, ... }:
        {
          imports = [
            (mkKresdConfig nodes)
          ];

          environment.systemPackages = [
            pkgs.matrix-commander
            pkgs.matrix-federation-tester
            pkgs.jq
          ];

          security.pki.certificateFiles = [ ca.cert ];

          users.users = {
            alice.isNormalUser = true;
            bob.isNormalUser = true;
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
          synapse_with_workers.succeed("REQUESTS_CA_BUNDLE=${ca.cert} register_new_matrix_user -u ${aliceName} -p ${alicePassword} -a -k ${registrationSharedSecret} https://hs1.test:8448/")
          synapse_with_workers.succeed("obtain-token-and-register-email")

      with subtest("matrix-synapse-register_new_matrix_user"):
          synapse_minimal.succeed("matrix-synapse-register_new_matrix_user -u ${bobName} -p ${bobPassword} --no-admin")
          synapse_minimal.succeed("[ -e /var/lib/matrix-synapse/homeserver.db ]")

      with subtest("Federation tester"):
          for domain in ["hs1.test", "hs2.test"]:
              result = json.loads(client.succeed(f"matrix-federation-tester -lookup {domain}"))
              pprint(result)
              assert result["FederationOK"]

      def run_as_alice(cmd):
          return client.succeed(f"sudo -u alice matrix-commander -c /home/alice/credentials.json -s /home/alice/matrix {cmd}")

      def run_as_bob(cmd):
          return client.succeed(f"sudo -u bob matrix-commander -c /home/bob/credentials.json -s /home/bob/matrix {cmd}")

      with subtest("Send/receive messages"):
          run_as_alice("--login password --homeserver https://hs1.test:8448 --user-login @${aliceName}:hs1.test --password ${alicePassword} --device commander --room-default '#welcome:hs1.test'")
          run_as_bob("--login password --homeserver https://hs2.test:8448 --user-login @${bobName}:hs2.test --password ${bobPassword} --device commander --room-default '#welcome:hs1.test'")

          run_as_alice("--room-create '#welcome:hs1.test'")

          run_as_alice("--room-invite '#welcome:hs1.test' -u @${bobName}:hs2.test")
          run_as_bob("--listen once --room-invites 'list+join'")

          run_as_alice("-m hello")
          for run in [run_as_alice, run_as_bob]:
              msg_data = json.loads(run("--listen once --listen-self --output json"))
              pprint(msg_data)
              assert msg_data["source"]["content"]["body"] == "hello"
              assert msg_data["source"]["sender"] == "@alice:hs1.test"
    '';
  }
)
