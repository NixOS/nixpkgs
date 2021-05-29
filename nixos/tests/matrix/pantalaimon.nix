import ../make-test-python.nix (
  { pkgs, ... }: let
    # Set up SSL certs for Synapse to be happy.
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
  in
    {
      name = "pantalaimon";
      meta = with pkgs.lib; {
        maintainers = teams.matrix.members;
      };

      machine = { pkgs, ... }: {
        services.pantalaimon = {
          enable = true;
          settings = {
            Default = {
              LogLevel = "Debug";
              SSL = true;
              Notifications = "Off";
            };

            Clocktown = {
              Homeserver = "https://localhost:8448";
              ListenAddress = "0.0.0.0";
              ListenPort = 8888;
              SSL = false;
            };
          };
        };

        services.matrix-synapse = {
          enable = true;
          database_type = "sqlite3";
          tls_certificate_path = "${cert}";
          tls_private_key_path = "${key}";
        };
      };

      testScript = ''
        start_all()
        machine.wait_for_unit("pantalaimon.service")
        machine.wait_for_unit("matrix-synapse.service")
        machine.wait_until_succeeds(
            "curl --fail -L http://localhost:8888/"
        )
      '';
    }
)
