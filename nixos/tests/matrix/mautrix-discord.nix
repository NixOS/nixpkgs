{ pkgs, ... }:
let
  homeserverUrl = "http://homeserver:8008";
in
{
  name = "mautrix-discord";
  meta.maintainers = pkgs.mautrix-discord.meta.maintainers;

  nodes = {
    homeserver =
      { pkgs, ... }:
      {
        services.matrix-synapse = {
          enable = true;
          settings = {
            server_name = "homeserver";
            database.name = "sqlite3";

            enable_registration = true;
            # don't use this in production, always use some form of verification
            enable_registration_without_verification = true;

            listeners = [
              {
                bind_addresses = [ "0.0.0.0" ];
                port = 8008;
                resources = [
                  {
                    "compress" = true;
                    "names" = [ "client" ];
                  }
                  {
                    "compress" = false;
                    "names" = [ "federation" ];
                  }
                ];
                tls = false;
                type = "http";
              }
            ];
          };
        };

        services.mautrix-discord = {
          enable = true;
          registerToSynapse = true; # Enable automatic registration

          settings = {
            homeserver = {
              address = homeserverUrl;
              domain = "homeserver";
            };

            appservice = {
              address = "http://homeserver:8009";
              port = 8009;
              id = "discord";
              bot = {
                username = "discordbot";
                displayname = "Discord bridge bot";
                avatar = "mxc://maunium.net/nIdEykemnwdisvHbpxflpDlC";
              };
              # These will be generated automatically
              as_token = "generate";
              hs_token = "generate";

              database = {
                type = "sqlite3";
                uri = "file:/var/lib/mautrix-discord/mautrix-discord.db?_txlock=immediate";
              };
            };

            bridge = {
              permissions = {
                "@alice:homeserver" = "user";
                "*" = "relay";
              };
            };
          };
        };

        networking.firewall.allowedTCPPorts = [
          8008
          8009
        ];

        environment.systemPackages = [
          pkgs.nettools
        ];
      };

    client =
      { pkgs, ... }:
      {
        environment.systemPackages = [
          (pkgs.writers.writePython3Bin "do_test"
            {
              libraries = [ pkgs.python3Packages.matrix-nio ];
              flakeIgnore = [
                "F401" # imported but unused
                "E302" # expected 2 blank lines
              ];
            }
            ''
              import sys
              import asyncio
              from nio import AsyncClient, RoomMessageNotice, RoomCreateResponse


              async def message_callback(matrix: AsyncClient, msg: str, _r, e):
                  print(f"Received message: {msg}")


              async def run(homeserver: str):
                  client = AsyncClient(homeserver, "@test:homeserver")

                  # Register a new user
                  response = await client.register("test", "password123")
                  if not response.transport_response.ok:
                      print(f"Failed to register: {response}")
                      return False

                  # Login
                  response = await client.login("password123")
                  if not response.transport_response.ok:
                      print(f"Failed to login: {response}")
                      return False

                  print("Successfully logged in and basic functionality works")
                  await client.close()
                  return True


              if __name__ == "__main__":
                  if len(sys.argv) != 2:
                      print("Usage: do_test <homeserver_url>")
                      sys.exit(1)

                  homeserver_url = sys.argv[1]
                  success = asyncio.run(run(homeserver_url))
                  sys.exit(0 if success else 1)
            ''
          )
        ];
      };
  };

  testScript = ''
    start_all()

    with subtest("wait for homeserver and bridge to be ready"):
        homeserver.wait_for_unit("matrix-synapse.service")
        homeserver.wait_for_open_port(8008)
        homeserver.wait_for_unit("mautrix-discord.service")
        homeserver.wait_for_open_port(8009)

    with subtest("verify registration file was created"):
        homeserver.wait_until_succeeds("test -f /var/lib/mautrix-discord/discord-registration.yaml")
        homeserver.succeed("ls -la /var/lib/mautrix-discord/")

    with subtest("verify bridge connects to homeserver"):
        # Give the bridge a moment to connect
        homeserver.sleep(5)

        # Check that the bridge is running and listening
        homeserver.succeed("systemctl is-active mautrix-discord.service")
        homeserver.succeed("netstat -tlnp | grep :8009")

    with subtest("test basic matrix functionality"):
        client.succeed("do_test ${homeserverUrl} >&2")
  '';
}
