import ../make-test-python.nix (
  { pkgs, ... }:
  let
    # Set up SSL certs for Synapse to be happy.
    runWithOpenSSL =
      file: cmd:
      pkgs.runCommand file {
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
    name = "matrix-alertmanager";
    meta.maintainers = with pkgs.lib.maintainers; [ erethon ];

    nodes = {
      homeserver =
        { pkgs, ... }:
        {
          services.matrix-synapse = {
            enable = true;
            settings = {
              database.name = "sqlite3";
              tls_certificate_path = "${cert}";
              tls_private_key_path = "${key}";
              enable_registration = true;
              enable_registration_without_verification = true;
              registration_shared_secret = "supersecret-registration";

              listeners = [
                {
                  # The default but tls=false
                  bind_addresses = [
                    "0.0.0.0"
                  ];
                  port = 8448;
                  resources = [
                    {
                      compress = true;
                      names = [ "client" ];
                    }
                    {
                      compress = false;
                      names = [ "federation" ];
                    }
                  ];
                  tls = false;
                  type = "http";
                  x_forwarded = false;
                }
              ];
            };
          };

          networking.firewall.allowedTCPPorts = [ 8448 ];

          environment.systemPackages = [
            (pkgs.writeShellScriptBin "register_alertmanager_user" ''
              exec ${pkgs.matrix-synapse}/bin/register_new_matrix_user \
                -u alertmanager \
                -p alertmanager-password \
                --admin \
                --shared-secret supersecret-registration \
                http://localhost:8448
            '')
            # This is needed to solve a chicken and egg
            # problem. Matrix-alertmanager expects a token for authentication,
            # but a token is created after the user has been registered. This
            # changes the token in the database to match the one specified in
            # the service settings.
            (pkgs.writers.writePython3Bin "hardcode_matrix_values"
              {
                libraries = with pkgs.python3Packages; [
                  sqlite-utils
                ];
              }
              ''
                import sqlite3
                con = sqlite3.connect("/var/lib/matrix-synapse/homeserver.db")
                cur = con.cursor()
                cur.execute(
                    "update access_tokens set token='%s' where user_id = '%s'"
                    % ("faketoken", "@alertmanager:homeserver")
                )
                con.commit()
                con.close()
              ''
            )
          ];
        };

      matrix_alertmanager =
        { pkgs, ... }:
        {
          services.matrix-alertmanager = {
            enable = true;
            tokenFile = pkgs.writeText "token.txt" "faketoken";
            secretFile = pkgs.writeText "secret.txt" "wontbeused";
            homeserverUrl = "http://homeserver:8448";
            # Matrix-alertmanager expects at least a room in its configuration
            # in order to start. However, the room doesn't have to exist for
            # matrix-alertmanager to start, so this is a configuration only
            # placeholder.
            matrixRooms = [
              {
                receivers = [ "matrix" ];
                roomId = "!room_id:homeserver";
              }
            ];
            matrixUser = "alertmanager";
          };
        };
    };

    testScript = ''
      with subtest("start homeserver"):
        homeserver.start()
        homeserver.wait_for_unit("matrix-synapse.service")
        homeserver.wait_until_succeeds("curl --fail -L http://localhost:8448/")

      with subtest("register user"):
        # register alertmanager user
        homeserver.succeed("register_alertmanager_user")

      with subtest("hardcode matrix values for matrix-alertmanager to use"):
        homeserver.succeed("hardcode_matrix_values")

      with subtest("start matrix_alertmanager"):
        matrix_alertmanager.start()
        matrix_alertmanager.wait_for_unit("matrix-alertmanager.service")
        matrix_alertmanager.wait_until_succeeds("curl --fail -L http://localhost:3000/")
        matrix_alertmanager.wait_for_console_text("matrix-alertmanager initialized and ready")
    '';
  }
)
