import ../make-test-python.nix (
  { pkgs, ... }:
  let
    homeserverUrl = "http://homeserver:8008";

    private_key = pkgs.runCommand "matrix_key.pem" {
      buildInputs = [ pkgs.dendrite ];
    } "generate-keys --private-key $out";
  in
  {
    name = "dendrite";
    meta = with pkgs.lib; {
      maintainers = teams.matrix.members;
    };

    nodes = {
      homeserver =
        { pkgs, ... }:
        {
          services.dendrite = {
            enable = true;
            loadCredential = [ "test_private_key:${private_key}" ];
            openRegistration = true;
            settings = {
              global.server_name = "test-dendrite-server.com";
              global.private_key = "$CREDENTIALS_DIRECTORY/test_private_key";
              client_api.registration_disabled = false;
            };
          };

          networking.firewall.allowedTCPPorts = [ 8008 ];
        };

      client =
        { pkgs, ... }:
        {
          environment.systemPackages = [
            (pkgs.writers.writePython3Bin "do_test" { libraries = [ pkgs.python3Packages.matrix-nio ]; } ''
              import asyncio

              from nio import AsyncClient


              async def main() -> None:
                  # Connect to dendrite
                  client = AsyncClient("http://homeserver:8008", "alice")

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
                          "body": "Hello world!"
                      }
                  )

                  # Sync responses
                  response = await client.sync(timeout=30000)

                  # Check the message was received by dendrite
                  last_message = response.rooms.join[room_id].timeline.events[-1].body
                  assert last_message == "Hello world!"

                  # Leave the room
                  response = await client.room_leave(room_id)

                  # Close the client
                  await client.close()

              asyncio.get_event_loop().run_until_complete(main())
            '')
          ];
        };
    };

    testScript = ''
      start_all()

      with subtest("start the homeserver"):
          homeserver.wait_for_unit("dendrite.service")
          homeserver.wait_for_open_port(8008)

      with subtest("ensure messages can be exchanged"):
          client.succeed("do_test")
    '';

  }
)
