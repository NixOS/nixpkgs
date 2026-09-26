{ lib, ... }:
let
  name = "continuwuity";
  user = "alice";
  pass = "my-secret-password";
in
{
  inherit name;

  nodes = {
    continuwuity = {
      services.matrix-continuwuity = {
        enable = true;
        settings.global = {
          server_name = name;
          address = [ "0.0.0.0" ];
          admin_execute = [ "users create ${user} ${pass}" ];
        };
        extraEnvironment.RUST_BACKTRACE = "yes";
      };
      networking.firewall.allowedTCPPorts = [ 6167 ];
    };

    client =
      { pkgs, ... }:
      {
        environment.systemPackages = [
          (pkgs.writers.writePython3Bin "do_test" { libraries = [ pkgs.python3Packages.mautrix ]; } ''
            import asyncio

            from mautrix.client import Client
            from mautrix.types import EventType, RoomFilter, Filter


            async def main() -> None:
                # Connect to continuwuity
                client = Client(
                    mxid="@${user}:${name}",
                    base_url="http://continuwuity:6167",
                )

                # Log in as user alice
                await client.login(password="${pass}")

                # Create a new room
                room_id = await client.create_room()
                print("Created room:", room_id)

                # Join the room
                await client.join_room_by_id(room_id)
                print("Joined room")

                # Send a message to the room
                received = asyncio.Event()
                msg = "Hello continuwuity!"

                async def on_message(evt):
                    if (
                        evt.room_id != room_id
                        or evt.sender != client.mxid
                        or evt.type != EventType.ROOM_MESSAGE
                    ):
                        return

                    assert evt.content.body == msg
                    received.set()

                client.add_event_handler(EventType.ROOM_MESSAGE, on_message)
                sync_task = client.start(Filter(room=RoomFilter(rooms=[room_id])))

                await client.send_text(room_id, msg)

                # Sync until message is received
                await asyncio.wait_for(received.wait(), timeout=30)

                # Leave the room
                await client.leave_room(room_id)
                print("Left room")

                # Close the client
                client.stop()
                await sync_task


            if __name__ == "__main__":
                asyncio.run(main())
          '')
        ];
      };
  };

  testScript = ''
    start_all()

    with subtest("start continuwuity"):
          continuwuity.wait_for_unit("continuwuity.service")
          continuwuity.wait_for_open_port(6167)

    with subtest("ensure messages can be exchanged"):
          client.succeed("do_test >&2")
  '';

  meta.maintainers = with lib.maintainers; [
    bartoostveen
    nyabinary
    snaki
  ];
}
