import ./make-test-python.nix ({ pkgs, ... } : let


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

in {

  name = "matrix-synapse";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ corngood ];
  };

  nodes = {
    # Since 0.33.0, matrix-synapse doesn't allow underscores in server names
    serverpostgres = { pkgs, ... }: {
      services.matrix-synapse = {
        enable = true;
        database_type = "psycopg2";
        tls_certificate_path = "${cert}";
        tls_private_key_path = "${key}";
        database_args = {
          password = "synapse";
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
    };

    serversqlite = args: {
      services.matrix-synapse = {
        enable = true;
        database_type = "sqlite3";
        tls_certificate_path = "${cert}";
        tls_private_key_path = "${key}";
      };
    };
  };

  testScript = ''
    start_all()
    serverpostgres.wait_for_unit("matrix-synapse.service")
    serverpostgres.wait_until_succeeds(
        "curl -L --cacert ${ca_pem} https://localhost:8448/"
    )
    serverpostgres.require_unit_state("postgresql.service")
    serversqlite.wait_for_unit("matrix-synapse.service")
    serversqlite.wait_until_succeeds(
        "curl -L --cacert ${ca_pem} https://localhost:8448/"
    )
    serversqlite.succeed("[ -e /var/lib/matrix-synapse/homeserver.db ]")
  '';

})
