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
  name = "mjolnir";
  meta = {
    inherit (pkgs.mjolnir.meta) maintainers;
  };

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
          (pkgs.writeShellScriptBin "register_mjolnir_user" ''
            exec ${pkgs.matrix-synapse}/bin/register_new_matrix_user \
              -u mjolnir \
              -p mjolnir-password \
              --admin \
              --shared-secret supersecret-registration \
              http://localhost:8448
          '')
          (pkgs.writeShellScriptBin "register_moderator_user" ''
            exec ${pkgs.matrix-synapse}/bin/register_new_matrix_user \
              -u moderator \
              -p moderator-password \
              --no-admin \
              --shared-secret supersecret-registration \
              http://localhost:8448
          '')
        ];
      };

    mjolnir =
      { pkgs, ... }:
      {
        services.mjolnir = {
          enable = true;
          homeserverUrl = "http://homeserver:8448";
          pantalaimon = {
            enable = true;
            username = "mjolnir";
            passwordFile = pkgs.writeText "password.txt" "mjolnir-password";
            # otherwise mjolnir tries to connect to ::1, which is not listened by pantalaimon
            options.listenAddress = "127.0.0.1";
          };
          managementRoom = "#moderators:homeserver";
        };
      };

    client =
      { pkgs, ... }:
      {
        environment.systemPackages = [
          (pkgs.writers.writePython3Bin "create_management_room_and_invite_mjolnir"
            {
              libraries = with pkgs.python3Packages; [
                (matrix-nio.override { withOlm = true; })
              ];
            }
            ''
              import asyncio

              from nio import (
                  AsyncClient,
                  EnableEncryptionBuilder
              )


              async def main() -> None:
                  client = AsyncClient("http://homeserver:8448", "moderator")

                  await client.login("moderator-password")

                  room = await client.room_create(
                      name="Moderators",
                      alias="moderators",
                      initial_state=[EnableEncryptionBuilder().as_dict()],
                  )

                  await client.join(room.room_id)
                  await client.room_invite(room.room_id, "@mjolnir:homeserver")

              asyncio.run(main())
            ''
          )
        ];
      };
  };

  testScript = ''
    with subtest("start homeserver"):
      homeserver.start()

      homeserver.wait_for_unit("matrix-synapse.service")
      homeserver.wait_until_succeeds("curl --fail -L http://localhost:8448/")

    with subtest("register users"):
      # register mjolnir user
      homeserver.succeed("register_mjolnir_user")
      # register moderator user
      homeserver.succeed("register_moderator_user")

    with subtest("start mjolnir"):
      mjolnir.start()

      # wait for pantalaimon to be ready
      mjolnir.wait_for_unit("pantalaimon-mjolnir.service")
      mjolnir.wait_for_unit("mjolnir.service")

      mjolnir.wait_until_succeeds("curl --fail -L http://localhost:8009/")

    with subtest("ensure mjolnir can be invited to the management room"):
      client.start()

      client.wait_until_succeeds("curl --fail -L http://homeserver:8448/")

      client.succeed("create_management_room_and_invite_mjolnir")

      mjolnir.wait_for_console_text("Startup complete. Now monitoring rooms")
  '';
}
