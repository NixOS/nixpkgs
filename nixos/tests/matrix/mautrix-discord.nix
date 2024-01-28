import ../make-test-python.nix ({ pkgs, ... }:
  let
    homeserverUrl = "http://homeserver:8008";
  in
  {
    name = "mautrix-discord";
    meta.maintainers = pkgs.mautrix-discord.meta.maintainers;

    nodes = {
      homeserver = { pkgs, ... }: {
        # We'll switch to this once the registration is copied into place
        specialisation.running.configuration = {
          services.matrix-synapse = {
            enable = true;
            settings = {
              database.name = "sqlite3";
              app_service_config_files = [ "/discord-registration.yaml" ];

              enable_registration = true;

              # don't use this in production, always use some form of verification
              enable_registration_without_verification = true;

              listeners = [ {
                # The default but tls=false
                bind_addresses = [
                  "0.0.0.0"
                ];
                port = 8008;
                resources = [ {
                  "compress" = true;
                  "names" = [ "client" ];
                } {
                  "compress" = false;
                  "names" = [ "federation" ];
                } ];
                tls = false;
                type = "http";
              } ];
            };
          };

          networking.firewall.allowedTCPPorts = [ 8008 ];
        };
      };

      bridge = { pkgs, ... }: {
        services.mautrix-discord = {
          enable = true;

          settings = {
            homeserver = {
              address = homeserverUrl;
              domain = "homeserver";
            };

            appservice = {
              address = "http://bridge:8009";
              port = 8009;
            };

            bridge.permissions."@alice:homeserver" = "user";
          };
        };

        networking.firewall.allowedTCPPorts = [ 8009 ];
      };

      client = { pkgs, ... }: {
        environment.systemPackages = [
          (pkgs.writers.writePython3Bin "do_test"
          {
            libraries = [ pkgs.python3Packages.matrix-nio ];
            flakeIgnore = [
              # We don't live in the dark ages anymore.
              # Languages like Python that are whitespace heavy will overrun
              # 79 characters..
              "E501"
            ];
          } ''
              import sys
              import functools
              import asyncio

              from nio import AsyncClient, RoomMessageNotice, RoomCreateResponse, RoomInviteResponse


              async def message_callback(matrix: AsyncClient, msg: str, _r, e):
                  print("Received matrix text message: ", e)
                  assert msg in e.body
                  exit(0)  # Success!


              async def run(homeserver: str):
                  matrix = AsyncClient(homeserver)
                  response = await matrix.register("alice", "foobar")
                  print("Matrix register response: ", response)

                  # Open a DM with the bridge bot
                  response = await matrix.room_create()
                  print("Matrix create room response:", response)
                  assert isinstance(response, RoomCreateResponse)
                  room_id = response.room_id

                  response = await matrix.room_invite(room_id, "@discordbot:homeserver")
                  assert isinstance(response, RoomInviteResponse)

                  callback = functools.partial(
                      message_callback, matrix, "Hello, I'm a Discord bridge bot."
                  )
                  matrix.add_event_callback(callback, RoomMessageNotice)

                  print("Waiting for matrix message...")
                  await matrix.sync_forever(timeout=30000)


              if __name__ == "__main__":
                  asyncio.run(run(sys.argv[1]))
            ''
          )
        ];
      };
    };

    testScript = ''
      import pathlib
      import os

      start_all()

      with subtest("start the bridge"):
          bridge.wait_for_unit("mautrix-discord.service")

      with subtest("copy the registration file"):
          bridge.copy_from_vm("/var/lib/mautrix-discord/discord-registration.yaml")
          homeserver.copy_from_host(
              str(pathlib.Path(os.environ.get("out", os.getcwd())) / "discord-registration.yaml"), "/"
          )
          homeserver.succeed("chmod 444 /discord-registration.yaml")

      with subtest("start the homeserver"):
          homeserver.succeed(
              "/run/current-system/specialisation/running/bin/switch-to-configuration test >&2"
          )

          homeserver.wait_for_unit("matrix-synapse.service")
          homeserver.wait_for_open_port(8008)
          # Bridge only opens the port after it contacts the homeserver
          bridge.wait_for_open_port(8009)

      with subtest("ensure messages can be exchanged"):
          client.succeed("do_test ${homeserverUrl} >&2")
    '';
  })
