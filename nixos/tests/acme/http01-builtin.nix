{
  config,
  lib,
  pkgs,
  ...
}:
let
  domain = "example.test";
in
{
  name = "http01-builtin";
  meta = {
    maintainers = lib.teams.acme.members;
    # Hard timeout in seconds. Average run time is about 90 seconds.
    timeout = 300;
  };

  nodes = {
    # The fake ACME server which will respond to client requests
    acme =
      { nodes, ... }:
      {
        imports = [ ../common/acme/server ];
      };

    builtin =
      { nodes, config, ... }:
      {
        imports = [ ../common/acme/client ];
        networking.domain = domain;
        networking.firewall.allowedTCPPorts = [ 80 ];

        # OpenSSL will be used for more thorough certificate validation
        environment.systemPackages = [ pkgs.openssl ];

        security.acme.certs."${config.networking.fqdn}" = {
          listenHTTP = ":80";
        };

        systemd.targets."renew-triggered" = {
          wantedBy = [ "acme-order-renew-${config.networking.fqdn}.service" ];
          after = [ "acme-order-renew-${config.networking.fqdn}.service" ];
          unitConfig.RefuseManualStart = true;
        };

        specialisation = {
          renew.configuration = {
            # Pebble provides 5 year long certs,
            # needs to be higher than that to test renewal
            security.acme.certs."${config.networking.fqdn}".validMinDays = 9999;
          };

          accountchange.configuration = {
            security.acme.certs."${config.networking.fqdn}".email = "admin@example.test";
          };

          keytype.configuration = {
            security.acme.certs."${config.networking.fqdn}".keyType = "ec384";
          };

          # Perform http-01 test again, but using the pre-24.05 account hashing
          # (see https://github.com/NixOS/nixpkgs/pull/317257)
          # The hash is deterministic in this case - only based on keyType and email.
          # Note: This test is making the assumption that the acme module will create
          # the account directory regardless of internet connectivity or server reachability.
          legacy_account_hash.configuration = {
            security.acme.defaults.server = lib.mkForce null;
          };

          ocsp_stapling.configuration = {
            security.acme.certs."${config.networking.fqdn}".ocspMustStaple = true;
          };

          preservation.configuration = { };

          add_cert_and_domain.configuration = {
            security.acme.certs = {
              "${config.networking.fqdn}" = {
                extraDomainNames = [
                  "builtin-alt.${domain}"
                ];
              };
              # We can assume that if renewal succeeds then the account creation leader
              # logic is working, since only one service could bind to port 80 at the same time.
              "builtin-2.${domain}".listenHTTP = ":80";
            };
            # To make sure it's the account creation leader that is doing the work.
            security.acme.maxConcurrentRenewals = 10;
          };

          concurrency.configuration = {
            # As above, relying on port binding behaviour to assert that concurrency limit
            # prevents > 1 service running at a time.
            security.acme.maxConcurrentRenewals = 1;
            security.acme.certs = {
              "${config.networking.fqdn}" = {
                extraDomainNames = [
                  "builtin-alt.${domain}"
                ];
              };
              "builtin-2.${domain}" = {
                extraDomainNames = [ "builtin-2-alt.${domain}" ];
                listenHTTP = ":80";
              };
              "builtin-3.${domain}".listenHTTP = ":80";
            };
          };

          csr.configuration =
            let
              conf = pkgs.writeText "openssl.csr.conf" ''
                [req]
                default_bits = 2048
                prompt = no
                default_md = sha256
                req_extensions = req_ext
                distinguished_name = dn

                [ dn ]
                CN = ${config.networking.fqdn}

                [ req_ext ]
                subjectAltName = @alt_names

                [ alt_names ]
                DNS.1 = ${config.networking.fqdn}
              '';
              csrData =
                pkgs.runCommand "csr-and-key"
                  {
                    buildInputs = [ pkgs.openssl ];
                  }
                  ''
                    mkdir -p $out
                    openssl req -new -newkey rsa:2048 -nodes \
                      -keyout $out/key.pem \
                      -out $out/request.csr \
                      -config ${conf}
                  '';
            in
            {
              security.acme.certs."${config.networking.fqdn}" = {
                csr = "${csrData}/request.csr";
                csrKey = "${csrData}/key.pem";
              };
            };
        };
      };
  };

  testScript =
    { nodes, ... }:
    let
      certName = nodes.builtin.networking.fqdn;
      caDomain = nodes.acme.test-support.acme.caDomain;
    in
    ''
      ${(import ./utils.nix).pythonUtils}

      domain = "${domain}"
      cert = "${certName}"
      cert2 = "builtin-2." + domain
      cert3 = "builtin-3." + domain
      legacy_account_dir = "/var/lib/acme/.lego/accounts/1ccf607d9aa280e9af00"

      acme.start()
      wait_for_running(acme)
      acme.wait_for_open_port(443)

      with subtest("Boot and acquire a new cert"):
          builtin.start()
          wait_for_running(builtin)

          check_issuer(builtin, cert, "pebble")
          check_domain(builtin, cert, cert)

      with subtest("Validate permissions"):
          check_permissions(builtin, cert, "acme")

      with subtest("Check renewal behaviour"):
          # First, test no-op behaviour
          hash = builtin.succeed(f"sha256sum /var/lib/acme/{cert}/cert.pem")
          # old_hash will be used in the preservation tests later
          old_hash = hash
          builtin.succeed(f"systemctl start acme-{cert}.service")
          builtin.succeed(f"systemctl start acme-order-renew-{cert}.service")
          builtin.wait_for_unit("renew-triggered.target")

          hash_after = builtin.succeed(f"sha256sum /var/lib/acme/{cert}/cert.pem")
          assert hash == hash_after, "Certificate was unexpectedly changed"

          builtin.succeed("systemctl stop renew-triggered.target")
          switch_to(builtin, "renew")
          builtin.wait_for_unit("renew-triggered.target")

          check_issuer(builtin, cert, "pebble")
          hash_after = builtin.succeed(f"sha256sum /var/lib/acme/{cert}/cert.pem | tee /dev/stderr")
          assert hash != hash_after, "Certificate was not renewed"

          check_permissions(builtin, cert, "acme")

      with subtest("Handles email change correctly"):
          hash = builtin.succeed(f"sha256sum /var/lib/acme/{cert}/cert.pem")

          builtin.succeed("systemctl stop renew-triggered.target")
          switch_to(builtin, "accountchange")
          builtin.wait_for_unit("renew-triggered.target")

          check_issuer(builtin, cert, "pebble")
          # Check that there are now 2 account directories
          builtin.succeed("test $(ls -1 /var/lib/acme/.lego/accounts | tee /dev/stderr | wc -l) -eq 2")
          hash_after = builtin.succeed(f"sha256sum /var/lib/acme/{cert}/cert.pem")
          # Has to do a full run to register account, which creates new certs.
          assert hash != hash_after, "Certificate was not renewed"
          # Remove the new account directory
          builtin.succeed(
              "cd /var/lib/acme/.lego/accounts"
              " && ls -1 --sort=time | tee /dev/stderr | head -1 | xargs rm -rf"
          )
          # old_hash will be used in the preservation tests later
          old_hash = hash_after

          check_permissions(builtin, cert, "acme")

      with subtest("Correctly implements OCSP stapling"):
          check_stapling(builtin, cert, "${caDomain}", fail=True)

          builtin.succeed("systemctl stop renew-triggered.target")
          switch_to(builtin, "ocsp_stapling")
          builtin.wait_for_unit("renew-triggered.target")

          check_stapling(builtin, cert, "${caDomain}")
          check_permissions(builtin, cert, "acme")

      with subtest("Handles keyType change correctly"):
          check_key_bits(builtin, cert, 256)

          builtin.succeed("systemctl stop renew-triggered.target")
          switch_to(builtin, "keytype")
          builtin.wait_for_unit("renew-triggered.target")

          check_key_bits(builtin, cert, 384)
          # keyType is part of the accountHash, thus a new account will be created
          builtin.succeed("test $(ls -1 /var/lib/acme/.lego/accounts | tee /dev/stderr | wc -l) -eq 2")
          check_permissions(builtin, cert, "acme")

      with subtest("Reuses generated, valid certs from previous configurations"):
          # Right now, the hash should not match due to the previous test
          hash = builtin.succeed(f"sha256sum /var/lib/acme/{cert}/cert.pem | tee /dev/stderr")
          assert hash != old_hash, "Expected certificate to differ"

          builtin.succeed("systemctl stop renew-triggered.target")
          switch_to(builtin, "preservation")
          builtin.wait_for_unit("renew-triggered.target")

          hash = builtin.succeed(f"sha256sum /var/lib/acme/{cert}/cert.pem | tee /dev/stderr")
          assert hash == old_hash, "Expected certificate to match from older configuration"
          check_permissions(builtin, cert, "acme")

      with subtest("Add a new cert, extend existing cert domains"):
          check_domain(builtin, cert, f"builtin-alt.{domain}", fail=True)

          builtin.succeed("systemctl stop renew-triggered.target")
          switch_to(builtin, "add_cert_and_domain")
          builtin.wait_for_unit("renew-triggered.target")

          check_issuer(builtin, cert, "pebble")
          check_domain(builtin, cert, f"builtin-alt.{domain}")
          check_issuer(builtin, cert2, "pebble")
          check_domain(builtin, cert2, cert2)
          # There should not be a new account folder created
          builtin.succeed("test $(ls -1 /var/lib/acme/.lego/accounts | tee /dev/stderr | wc -l) -eq 2")
          check_permissions(builtin, cert, "acme")
          check_permissions(builtin, cert2, "acme")

      with subtest("Check account hashing compatibility with pre-24.05 settings"):
          builtin.succeed("systemctl stop renew-triggered.target")
          switch_to(builtin, "legacy_account_hash"
          )
          builtin.wait_for_unit("renew-triggered.target")

          builtin.succeed(f"stat {legacy_account_dir} > /dev/stderr && rm -rf {legacy_account_dir}")
          check_permissions(builtin, cert, "acme")

      with subtest("Ensure concurrency limits work"):
          builtin.succeed("systemctl stop renew-triggered.target")
          switch_to(builtin, "concurrency")
          builtin.wait_for_unit("renew-triggered.target")

          check_issuer(builtin, cert3, "pebble")
          check_domain(builtin, cert3, cert3)
          check_permissions(builtin, cert, "acme")

      with subtest("Can renew using a CSR"):
          builtin.succeed(f"systemctl stop acme-{cert}.service")
          builtin.succeed(f"systemctl clean acme-{cert}.service --what=state")

          builtin.succeed("systemctl stop renew-triggered.target")
          switch_to(builtin, "csr")
          builtin.wait_for_unit("renew-triggered.target")

          check_issuer(builtin, cert, "pebble")

      with subtest("Generate self-signed certs"):
          acme.shutdown()

          check_issuer(builtin, cert, "pebble")

          builtin.succeed(f"systemctl stop acme-{cert}.service")
          builtin.succeed(f"systemctl clean acme-{cert}.service --what=state")
          builtin.succeed(f"systemctl start acme-{cert}.service")

          check_issuer(builtin, cert, "minica")
          check_domain(builtin, cert, cert)

      with subtest("Validate permissions (self-signed)"):
          check_permissions(builtin, cert, "acme")

    '';
}
