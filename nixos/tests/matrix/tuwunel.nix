{ lib, pkgs, ... }:
let
  name = "tuwunel";
in
{
  inherit name;

  nodes = {
    host1 = {
      services.matrix-conduit = {
        enable = true;
        package = pkgs.matrix-tuwunel;
        settings.global = {
          server_name = name;
          address = "0.0.0.0";
          allow_registration = true;
          yes_i_am_very_very_sure_i_want_an_open_registration_server_prone_to_abuse = true;
        };
        extraEnvironment.RUST_BACKTRACE = "yes";
      };
      systemd.services.conduit.serviceConfig.ExecStart = lib.mkForce "${pkgs.matrix-tuwunel}/bin/tuwunel";
      networking.firewall.allowedTCPPorts = [ 6167 ];
    };
    client =
      { pkgs, ... }:
      {
        environment.systemPackages = [
          (pkgs.writers.writePython3Bin "do_test" { libraries = [ pkgs.python3Packages.matrix-nio ]; } ''
            import asyncio
            import nio


            async def main() -> None:
                # Connect to server
                client = nio.AsyncClient("http://host1:6167", "alice")

                # Register as user alice
                response = await client.register("alice", "my-secret-password")

                # Log in as user alice
                response = await client.login("my-secret-password")

                # Create a new room
                response = await client.room_create(federate=False)
                print("Matrix room create response:", response)
                assert isinstance(response, nio.RoomCreateResponse)
                room_id = response.room_id

                # Join the room
                response = await client.join(room_id)
                print("Matrix join response:", response)
                assert isinstance(response, nio.JoinResponse)

                # Send a message to the room
                response = await client.room_send(
                    room_id=room_id,
                    message_type="m.room.message",
                    content={
                        "msgtype": "m.text",
                        "body": "Hello matrix!"
                    }
                )
                print("Matrix room send response:", response)
                assert isinstance(response, nio.RoomSendResponse)

                # Sync responses
                response = await client.sync(timeout=30000)
                print("Matrix sync response:", response)
                assert isinstance(response, nio.SyncResponse)

                # Check the message was received by server
                last_message = response.rooms.join[room_id].timeline.events[-1].body
                assert last_message == "Hello matrix!"

                # Leave the room
                response = await client.room_leave(room_id)
                print("Matrix room leave response:", response)
                assert isinstance(response, nio.RoomLeaveResponse)

                # Close the client
                await client.close()


            if __name__ == "__main__":
                asyncio.run(main())
          '')
        ];
      };
  };

  testScript = ''
    start_all()

    with subtest("start tuwunel"):
          host1.wait_for_unit("conduit.service")
          host1.wait_for_open_port(6167)

    with subtest("ensure messages can be exchanged"):
          client.succeed("do_test >&2")
  '';

  meta.maintainers = with lib.maintainers; [
    scvalex
  ];
}
