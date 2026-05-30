{ pkgs, lib, ... }:
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
              # Don't override as_token/hs_token - let them use the default placeholder
              # which will trigger automatic generation

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
          pkgs.yq
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

        # Verify tokens were generated and are not default values
        config_as_token = homeserver.succeed("yq -r '.appservice.as_token' /var/lib/mautrix-discord/config.yaml").strip()
        config_hs_token = homeserver.succeed("yq -r '.appservice.hs_token' /var/lib/mautrix-discord/config.yaml").strip()
        reg_as_token = homeserver.succeed("yq -r '.as_token' /var/lib/mautrix-discord/discord-registration.yaml").strip()
        reg_hs_token = homeserver.succeed("yq -r '.hs_token' /var/lib/mautrix-discord/discord-registration.yaml").strip()

        print(f"Config as_token: {config_as_token[:20]}...")
        print(f"Config hs_token: {config_hs_token[:20]}...")

        # Verify tokens are not the default placeholder or "generate"
        assert config_as_token not in ["This value is generated when generating the registration", "generate"], \
            f"Config as_token was not replaced: {config_as_token}"
        assert config_hs_token not in ["This value is generated when generating the registration", "generate"], \
            f"Config hs_token was not replaced: {config_hs_token}"

        # Verify tokens match between config and registration
        assert config_as_token == reg_as_token, \
            f"as_token mismatch: config={config_as_token[:20]}... vs reg={reg_as_token[:20]}..."
        assert config_hs_token == reg_hs_token, \
            f"hs_token mismatch: config={config_hs_token[:20]}... vs reg={reg_hs_token[:20]}..."

        print("Tokens generated and synchronized correctly")

    with subtest("verify tokens persist after service restart"):
        # Restart the registration service to simulate rebuild
        homeserver.succeed("systemctl restart mautrix-discord-registration.service")
        homeserver.wait_for_unit("mautrix-discord-registration.service")

        # Verify tokens were preserved
        config_as_token_2 = homeserver.succeed("yq -r '.appservice.as_token' /var/lib/mautrix-discord/config.yaml").strip()
        config_hs_token_2 = homeserver.succeed("yq -r '.appservice.hs_token' /var/lib/mautrix-discord/config.yaml").strip()

        assert config_as_token_2 == config_as_token, \
            f"as_token changed after restart: {config_as_token[:20]}... -> {config_as_token_2[:20]}..."
        assert config_hs_token_2 == config_hs_token, \
            f"hs_token changed after restart: {config_hs_token[:20]}... -> {config_hs_token_2[:20]}..."

        print("Tokens persisted correctly after restart")

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
