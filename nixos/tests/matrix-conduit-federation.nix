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

in {


  nodes = {
    conduit = args: {
      services.matrix-conduit = {
        enable = true;
        settings.global.server_name = name;
        settings.global.allow_registration = true;
        nginx.enable = true;
        extraEnvironment.RUST_BACKTRACE = "yes";
      };
      services.nginx.virtualHosts."${name}" = {
        enableACME = false;
        forceSSL = false;
        enableSSL = false;
      };
      networking.firewall.allowedTCPPorts = [ 80 ];
    };
  client = { pkgs, ... }: {
    environment.systemPackages = [
      (
        pkgs.writers.writePython3Bin "do_test"
        { libraries = [ pkgs.python3Packages.matrix-nio ]; } ''
          import asyncio

          from nio import AsyncClient


          async def main() -> None:
              # Connect to conduit
              client = AsyncClient("http://conduit:80", "alice")

              # Register as user alice
              response = await client.register("alice", "my-secret-password")

              # Log in as user alice
              response = await client.login("my-secret-password")

              # Create a new room
              response = await client.room_create(federate=False)
              room_id = response.room_id

              # Join the room
              response = await client.join(room_id)

              # Send a message to the room
              response = await client.room_send(
                  room_id=room_id,
                  message_type="m.room.message",
                  content={
                      "msgtype": "m.text",
                      "body": "Hello conduit!"
                  }
              )

              # Sync responses
              response = await client.sync(timeout=30000)

              # Check the message was received by conduit
              last_message = response.rooms.join[room_id].timeline.events[-1].body
              assert last_message == "Hello conduit!"

              # Leave the room
              response = await client.room_leave(room_id)

              # Close the client
              await client.close()

          asyncio.get_event_loop().run_until_complete(main())
        ''
        )
      ];
    };
  };

  testScript = ''
  start_all()

  with subtest("start conduit"):
        conduit.wait_for_unit("conduit.service")
        conduit.wait_for_open_port(80)

  with subtest("ensure messages can be exchanged"):
        client.succeed("do_test")
  '';
})
