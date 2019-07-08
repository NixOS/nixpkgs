import ./make-test.nix ({ pkgs, ... } : let


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
    serverpostgres = args: {
      services.matrix-synapse = {
        enable = true;
        database_type = "psycopg2";
        tls_certificate_path = "${cert}";
        tls_private_key_path = "${key}";
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
    startAll;
    $serverpostgres->waitForUnit("matrix-synapse.service");
    $serverpostgres->waitUntilSucceeds("curl -L --cacert ${ca_pem} https://localhost:8448/");
    $serverpostgres->requireActiveUnit("postgresql.service");
    $serversqlite->waitForUnit("matrix-synapse.service");
    $serversqlite->waitUntilSucceeds("curl -L --cacert ${ca_pem} https://localhost:8448/");
    $serversqlite->mustSucceed("[ -e /var/lib/matrix-synapse/homeserver.db ]");
  '';

})
