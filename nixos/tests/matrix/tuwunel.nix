{ lib, pkgs, ... }:
let
  name = "tuwunel";
in
{
  inherit name;

  nodes = {
    # Host1 is a fresh install of tuwunel
    host1 = {
      services.matrix-tuwunel = {
        enable = true;
        settings.global = {
          server_name = name;
          address = [ "0.0.0.0" ];
          allow_registration = true;
          yes_i_am_very_very_sure_i_want_an_open_registration_server_prone_to_abuse = true;
        };
        extraEnvironment.RUST_BACKTRACE = "yes";
      };
      networking.firewall.allowedTCPPorts = [ 6167 ];
    };

    # Host2 was upgraded from the matrix-conduit service
    host2 = {
      users.users.conduit = {
        group = "conduit";
        home = "/var/lib/matrix-conduit";
        isSystemUser = true;
      };
      users.groups.conduit = { };
      services.matrix-tuwunel = {
        enable = true;
        user = "conduit";
        group = "conduit";
        stateDirectory = "matrix-conduit";
        settings.global = {
          server_name = name;
          address = [ "0.0.0.0" ];
          allow_registration = true;
          yes_i_am_very_very_sure_i_want_an_open_registration_server_prone_to_abuse = true;
        };
        extraEnvironment.RUST_BACKTRACE = "yes";
      };
      networking.firewall.allowedTCPPorts = [ 6167 ];
    };

    client =
      { pkgs, ... }:
      {
        environment.systemPackages = [
          (pkgs.writers.writePython3Bin "do_test" { libraries = [ pkgs.python3Packages.matrix-nio ]; } ''
            import asyncio
            import nio
            import sys


            async def main(host) -> None:
                # Connect to server
                client = nio.AsyncClient(f"http://{host}:6167", "alice")

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
                asyncio.run(main(sys.argv[1]))
          '')
        ];
      };
  };

  testScript = ''
    start_all()

    with subtest("start tuwunel on host1"):
          host1.wait_for_unit("tuwunel.service")
          host1.wait_for_open_port(6167)

    with subtest("start tuwunel on host2"):
          host1.wait_for_unit("tuwunel.service")
          host1.wait_for_open_port(6167)

    with subtest("ensure messages can be sent to servers"):
          client.succeed("do_test host1 >&2")
          client.succeed("do_test host2 >&2")
  '';

  meta.maintainers = with lib.maintainers; [
    scvalex
  ];
}
