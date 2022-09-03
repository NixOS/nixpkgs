import ../make-test-python.nix ({ pkgs, ... } : let


  runWithOpenSSL = file: cmd: pkgs.runCommand file {
    buildInputs = [ pkgs.openssl ];
  } cmd;


  ca_key = runWithOpenSSL "ca-key.pem" "openssl genrsa -out $out 2048";
  ca_pem = runWithOpenSSL "ca.pem" ''
    openssl req \
      -x509 -new -nodes -key ${ca_key} \
      -days 10000 -out $out -subj "/CN=snakeoil-ca"
  '';
  key = runWithOpenSSL "matrix_key.pem" "openssl genrsa -out $out 2048";
  csr = runWithOpenSSL "matrix.csr" ''
    openssl req \
       -new -key ${key} \
       -out $out -subj "/CN=localhost" \
  '';
  cert = runWithOpenSSL "matrix_cert.pem" ''
    openssl x509 \
      -req -in ${csr} \
      -CA ${ca_pem} -CAkey ${ca_key} \
      -CAcreateserial -out $out \
      -days 365
  '';


  mailerCerts = import ../common/acme/server/snakeoil-certs.nix;
  mailerDomain = mailerCerts.domain;
  registrationSharedSecret = "unsecure123";
  testUser = "alice";
  testPassword = "alicealice";
  testEmail = "alice@example.com";

  listeners = [ {
    port = 8448;
    bind_addresses = [
      "127.0.0.1"
      "::1"
    ];
    type = "http";
    tls = true;
    x_forwarded = false;
    resources = [ {
      names = [
        "client"
      ];
      compress = true;
    } {
      names = [
        "federation"
      ];
      compress = false;
    } ];
  } ];

in {

  name = "matrix-synapse";
  meta = with pkgs.lib; {
    maintainers = teams.matrix.members;
  };

  nodes = {
    # Since 0.33.0, matrix-synapse doesn't allow underscores in server names
    serverpostgres = { pkgs, nodes, ... }: let
      mailserverIP = nodes.mailserver.config.networking.primaryIPAddress;
    in
    {
      services.matrix-synapse = {
        enable = true;
        settings = {
          inherit listeners;
          database = {
            name = "psycopg2";
            args.password = "synapse";
          };
          tls_certificate_path = "${cert}";
          tls_private_key_path = "${key}";
          registration_shared_secret = registrationSharedSecret;
          public_baseurl = "https://example.com";
          email = {
            smtp_host = mailerDomain;
            smtp_port = 25;
            require_transport_security = true;
            notif_from = "matrix <matrix@${mailerDomain}>";
            app_name = "Matrix";
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

      networking.extraHosts = ''
        ${mailserverIP} ${mailerDomain}
      '';

      security.pki.certificateFiles = [
        mailerCerts.ca.cert ca_pem
      ];

      environment.systemPackages = let
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

        obtainTokenAndRegisterEmail = let
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
        in [ sendTestMailStarttls pkgs.matrix-synapse obtainTokenAndRegisterEmail ];
    };

    # test mail delivery
    mailserver = args: let
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
            "permit_mynetworks" "reject_unauth_destination"
          ];

          # disable obsolete protocols, something old versions of twisted are still using
          smtpd_tls_protocols = "TLSv1.3, TLSv1.2, !TLSv1.1, !TLSv1, !SSLv2, !SSLv3";
          smtp_tls_protocols = "TLSv1.3, TLSv1.2, !TLSv1.1, !TLSv1, !SSLv2, !SSLv3";
          smtpd_tls_mandatory_protocols = "TLSv1.3, TLSv1.2, !TLSv1.1, !TLSv1, !SSLv2, !SSLv3";
          smtp_tls_mandatory_protocols = "TLSv1.3, TLSv1.2, !TLSv1.1, !TLSv1, !SSLv2, !SSLv3";
        };
      };
    };

    serversqlite = args: {
      services.matrix-synapse = {
        enable = true;
        settings = {
          inherit listeners;
          database.name = "sqlite3";
          tls_certificate_path = "${cert}";
          tls_private_key_path = "${key}";
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
    serverpostgres.require_unit_state("postgresql.service")
    serverpostgres.succeed("register_new_matrix_user -u ${testUser} -p ${testPassword} -a -k ${registrationSharedSecret} ")
    serverpostgres.succeed("obtain-token-and-register-email")
    serversqlite.wait_for_unit("matrix-synapse.service")
    serversqlite.wait_until_succeeds(
        "curl --fail -L --cacert ${ca_pem} https://localhost:8448/"
    )
    serversqlite.succeed("[ -e /var/lib/matrix-synapse/homeserver.db ]")
  '';

})
