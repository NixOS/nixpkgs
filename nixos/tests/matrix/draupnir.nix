{
  lib,
  ...
}:

{
  name = "draupnir";
  meta.maintainers = with lib.maintainers; [
    RorySys
    emilylange
  ];

  nodes = {
    homeserver =
      { pkgs, ... }:
      {
        services.matrix-synapse = {
          enable = true;
          log.root.level = "WARNING";
          settings = {
            database.name = "sqlite3";
            registration_shared_secret = "supersecret-registration";

            listeners = [
              {
                bind_addresses = [
                  "::"
                ];
                port = 8008;
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

        specialisation.draupnir = {
          inheritParentConfig = true;

          configuration.services.draupnir = {
            enable = true;
            settings = {
              homeserverUrl = "http://localhost:8008";
              managementRoom = "#moderators:homeserver";
            };
            secrets = {
              accessToken = "/tmp/draupnir-access-token";
            };
          };
        };

        environment.systemPackages = with pkgs; [
          curl
          jq
          (writers.writePython3Bin "test_draupnir_in_matrix"
            {
              libraries = [ python3Packages.matrix-nio ];
              flakeIgnore = [ "E501" ];
            }
            ''
              import asyncio
              import time
              from nio import AsyncClient, MatrixRoom, RoomMemberEvent, RoomMessageNotice


              async def main() -> None:
                  client = AsyncClient("http://localhost:8008", "moderator")

                  async def member_callback(room: MatrixRoom, event: RoomMemberEvent) -> None:
                      if event.membership == "join" and event.sender == "@draupnir:homeserver":
                          print("Got draupnir join event!")

                  async def message_callback(room: MatrixRoom, event: RoomMessageNotice) -> None:
                      print(f"{event.sender}:\n{event.body}" if "\n" in event.body else f"{event.sender}: {event.body}")

                      if event.sender == "@draupnir:homeserver" and "Startup complete." in event.body:
                          print("Draupnir reported ready, sending '!draupnir status'")
                          await client.room_send(
                              room_id=room.room_id,
                              message_type="m.room.message",
                              content={
                                  "msgtype": "m.text",
                                  "body": "!draupnir status"
                              }
                          )

                      if event.sender == "@draupnir:homeserver" and "Repository: " in event.body and "Version: " in event.body:
                          print("Got status reply, creating policy list")
                          await client.room_send(
                              room_id=room.room_id,
                              message_type="m.room.message",
                              content={
                                  "msgtype": "m.text",
                                  "body": "!draupnir list create test test"
                              }
                          )

                          time.sleep(3)
                          print("Surely it's done by now (couldnt find a good way to trigger the next step), protecting a room")

                          await client.room_send(
                              room_id=room.room_id,
                              message_type="m.room.message",
                              content={
                                  "msgtype": "m.text",
                                  "body": "!draupnir rooms add #protected:homeserver"
                              }
                          )
                          time.sleep(3)
                          print("Surely it's done by now (there's no text reply), sending a ban command")

                          await client.room_send(
                              room_id=room.room_id,
                              message_type="m.room.message",
                              content={
                                  "msgtype": "m.text",
                                  "body": "!draupnir ban @bad:homeserver test spam"
                              }
                          )
                          time.sleep(3)
                          print("Surely it's done by now (there's no text reply), sending a server ban command")

                          await client.room_send(
                              room_id=room.room_id,
                              message_type="m.room.message",
                              content={
                                  "msgtype": "m.text",
                                  "body": "!draupnir ban meow test spam"
                              }
                          )
                          time.sleep(3)
                          print("Surely it's done by now (there's no text reply), assuming all is good")

                          await client.close()
                          exit(0)

                  client.add_event_callback(member_callback, RoomMemberEvent)
                  client.add_event_callback(message_callback, RoomMessageNotice)

                  print(await client.login("password"))

                  room = await client.room_create(
                      name="Moderators",
                      alias="moderators",
                      invite=["@draupnir:homeserver"],
                      power_level_override={
                          "users": {
                              "@draupnir:homeserver": 100,
                              "@moderator:homeserver": 100,
                          }
                      }
                  )
                  print(room)

                  protectedRoom = await client.room_create(
                      name="Protected",
                      alias="protected",
                      invite=["@draupnir:homeserver"],
                      power_level_override={
                          "users": {
                              "@draupnir:homeserver": 100,
                              "@moderator:homeserver": 100,
                          }
                      }
                  )
                  print(protectedRoom)

                  print(await client.join(room.room_id))

                  await client.sync_forever(timeout=30000)


              asyncio.run(main())
            ''
          )
        ];
      };
  };

  testScript =
    { nodes, ... }:
    ''
      import json

      homeserver.wait_for_unit("matrix-synapse.service")
      homeserver.wait_until_succeeds("curl --fail -L http://localhost:8008/")

      homeserver.succeed("matrix-synapse-register_new_matrix_user -u draupnir -p password --no-admin")
      homeserver.succeed("matrix-synapse-register_new_matrix_user -u moderator -p password --no-admin")

      # get draupnir access token
      draupnir_login_payload = json.dumps({ "type": "m.login.password", "user": "draupnir", "password": "password" })
      homeserver.succeed(
          f"curl --fail --json '{draupnir_login_payload}' http://localhost:8008/_matrix/client/v3/login"
          + " | jq -r .access_token"
          + " | tee /tmp/draupnir-access-token"
       )

      homeserver.succeed("${nodes.homeserver.system.build.toplevel}/specialisation/draupnir/bin/switch-to-configuration test")
      homeserver.wait_for_unit("draupnir.service")

      print(homeserver.succeed("test_draupnir_in_matrix >&2", timeout=60))
    '';
}
