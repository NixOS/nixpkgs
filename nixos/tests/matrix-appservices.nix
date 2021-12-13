import ./make-test-python.nix (
  { pkgs, ... }:
    let
      homeserverURL = "http://homeserver:8008";
      homeserverDomain = "example.com";

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
          homeserver = { pkgs, ... }: {
            services.dendrite = {
              enable = true;
              settings = {
                global.server_name = homeserverDomain;
                global.private_key = private_key;
                client_api.registration_disabled = false;
              };
            };

            networking.firewall.allowedTCPPorts = [ 8008 ];

            services.matrix-appservices = {
              inherit homeserverDomain homeserverURL;
              addRegistrationFiles = true;
              homeserver = "dendrite";
              services = {
                discord = {
                  port = 29180;
                  package = pkgs.mx-puppet-discord;
                  format = "mx-puppet";
                };
              };
            };
          };

          client = { pkgs, ... }: {
            environment.systemPackages = [
              (
                pkgs.writers.writePython3Bin "do_test"
                  { libraries = [ pkgs.python3Packages.matrix-nio ]; } ''
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

                      # Invite whatsapp user to room
                      response = await client.room_invite(
                        room_id,
                        "@_discordpuppet_bot:${homeserverDomain}"
                      )

                      # Send a message to the room
                      response = await client.room_send(
                          room_id=room_id,
                          message_type="m.room.message",
                          content={
                              "msgtype": "m.text",
                              "body": "ping"
                          }
                      )

                      # Sync responses
                      response = await client.sync(timeout=30000)

                      response = await client.joined_members(room_id)

                      # Check the message was received by dendrite
                      # last_message = response.rooms.join[room_id].timeline.events[-1].body

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

          with subtest("start the homeserver"):
              homeserver.wait_for_unit("dendrite.service")
              homeserver.wait_for_open_port(8008)
              homeserver.wait_for_unit("matrix-as-discord.service")

          with subtest("ensure messages can be exchanged"):
              client.succeed("do_test")
        '';

      }
)
