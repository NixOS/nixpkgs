{ pkgs, ... }:
let
  homeserverDomain = "server";
  homeserverUrl = "http://server:8008";
  username = "alice";
  instagramBotUsername = "instagrambot";
  metaBotUsername = "metabot";
in
{
  name = "mautrix-meta-sqlite";
  meta.maintainers = pkgs.mautrix-meta.meta.maintainers;

  nodes = {
    server =
      { config, pkgs, ... }:
      {
        services.matrix-synapse = {
          enable = true;
          settings = {
            database.name = "sqlite3";

            enable_registration = true;

            # don't use this in production, always use some form of verification
            enable_registration_without_verification = true;

            listeners = [
              {
                # The default but tls=false
                bind_addresses = [
                  "0.0.0.0"
                ];
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

        services.mautrix-meta.instances.facebook = {
          enable = true;

          settings = {
            homeserver = {
              address = homeserverUrl;
              domain = homeserverDomain;
            };

            appservice = {
              port = 8009;

              bot = {
                username = metaBotUsername;
                avatar = "";
              };
            };

            encryption = {
              allow = false;
              default = false;
              require = false;
            };

            bridge.permissions."@${username}:server" = "user";
          };
        };

        services.mautrix-meta.instances.instagram = {
          enable = true;

          settings = {
            homeserver = {
              address = homeserverUrl;
              domain = homeserverDomain;
            };

            appservice = {
              port = 8010;

              bot = {
                username = instagramBotUsername;
                avatar = "";
              };
            };

            encryption = {
              allow = false;
              default = false;
              require = false;
            };

            bridge.permissions."@${username}:server" = "user";
          };
        };

        networking.firewall.allowedTCPPorts = [ 8008 ];
      };

    client =
      { pkgs, ... }:
      {
        environment.systemPackages = [
          (pkgs.writers.writePython3Bin "register_user"
            {
              libraries = [ pkgs.python3Packages.matrix-nio ];
              flakeIgnore = [
                # We don't live in the dark ages anymore.
                # Languages like Python that are whitespace heavy will overrun
                # 79 characters..
                "E501"
              ];
            }
            ''
              import sys
              import asyncio

              from nio import AsyncClient


              async def run(username: str, homeserver: str):
                  matrix = AsyncClient(homeserver)

                  response = await matrix.register(username, "foobar")
                  print("Matrix register response: ", response)


              if __name__ == "__main__":
                  asyncio.run(run(sys.argv[1], sys.argv[2]))
            ''
          )
          (pkgs.writers.writePython3Bin "do_test"
            {
              libraries = [ pkgs.python3Packages.matrix-nio ];
              flakeIgnore = [
                # We don't live in the dark ages anymore.
                # Languages like Python that are whitespace heavy will overrun
                # 79 characters..
                "E501"
              ];
            }
            ''
              import sys
              import functools
              import asyncio

              from nio import AsyncClient, RoomMessageText, RoomCreateResponse, RoomInviteResponse


              async def message_callback(matrix: AsyncClient, expected_msg: str, expected_sender: str, _r, e):
                  print("Received matrix text message: ", e)
                  if getattr(e, "sender", "") == expected_sender and expected_msg in getattr(e, "body", ""):
                      print("Success!")
                      exit(0)  # Success!


              async def run(username: str, bot_username: str, homeserver: str, expected_msg: str):
                  matrix = AsyncClient(homeserver, f"@{username}:${homeserverDomain}")

                  response = await matrix.login("foobar")
                  print("Matrix login response: ", response)

                  # Open a DM with the bridge bot
                  response = await matrix.room_create()
                  print("Matrix create room response:", response)
                  assert isinstance(response, RoomCreateResponse)
                  room_id = response.room_id

                  response = await matrix.room_invite(room_id, f"@{bot_username}:${homeserverDomain}")
                  assert isinstance(response, RoomInviteResponse)

                  callback = functools.partial(
                      message_callback, matrix, expected_msg, f"@{bot_username}:${homeserverDomain}"
                  )
                  matrix.add_event_callback(callback, RoomMessageText)

                  print("Waiting for matrix message...")
                  await matrix.sync_forever(timeout=30000)


              if __name__ == "__main__":
                  asyncio.run(run(sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4]))
            ''
          )
        ];
      };
  };

  testScript = ''
    def extract_token(data):
        stdout = data[1]
        stdout = stdout.strip()
        return stdout.split(':')[-1].strip("\" '\n")

    def get_token_from(token, file):
        data = server.execute(f"grep -E '^\\s*{token}:' {file}")
        return extract_token(data)

    def get_as_token_from(file):
        return get_token_from("as_token", file)

    def get_hs_token_from(file):
        return get_token_from("hs_token", file)

    config_yaml = "/var/lib/mautrix-meta-facebook/config.yaml"
    registration_yaml = "/var/lib/mautrix-meta-facebook/meta-registration.yaml"

    start_all()

    with subtest("wait for bridges and homeserver"):
        # bridge
        server.wait_for_unit("mautrix-meta-facebook.service")
        server.wait_for_unit("mautrix-meta-instagram.service")

        # homeserver
        server.wait_for_unit("matrix-synapse.service")

        server.wait_for_open_port(8008)
        # Bridges only open the port after they contact the homeserver
        server.wait_for_open_port(8009)
        server.wait_for_open_port(8010)

    with subtest("register user"):
        client.succeed("register_user ${username} ${homeserverUrl} >&2")

    with subtest("ensure messages can be exchanged"):
        client.succeed("do_test ${username} ${metaBotUsername} ${homeserverUrl} \"Hello, I'm a Facebook Messenger bridge bot.\" >&2")
        client.succeed("do_test ${username} ${instagramBotUsername} ${homeserverUrl} \"Hello, I'm a Instagram bridge bot.\" >&2")

    with subtest("ensure as_token and hs_token stays same after restart"):
        generated_as_token_facebook = get_as_token_from(config_yaml)
        generated_hs_token_facebook = get_hs_token_from(config_yaml)

        generated_as_token_facebook_registration = get_as_token_from(registration_yaml)
        generated_hs_token_facebook_registration = get_hs_token_from(registration_yaml)

        # Indirectly checks the as token is not set to something like empty string or "null"
        assert len(generated_as_token_facebook) > 20, f"as_token ({generated_as_token_facebook}) is too short, something went wrong"
        assert len(generated_hs_token_facebook) > 20, f"hs_token ({generated_hs_token_facebook}) is too short, something went wrong"

        assert generated_as_token_facebook == generated_as_token_facebook_registration, f"as_token should be the same in registration ({generated_as_token_facebook_registration}) and configuration ({generated_as_token_facebook}) files"
        assert generated_hs_token_facebook == generated_hs_token_facebook_registration, f"hs_token should be the same in registration ({generated_hs_token_facebook_registration}) and configuration ({generated_hs_token_facebook}) files"

        server.systemctl("restart mautrix-meta-facebook")
        server.systemctl("restart mautrix-meta-instagram")

        server.wait_for_open_port(8009)
        server.wait_for_open_port(8010)

        new_as_token_facebook = get_as_token_from(config_yaml)
        new_hs_token_facebook = get_hs_token_from(config_yaml)

        assert generated_as_token_facebook == new_as_token_facebook, f"as_token should stay the same after restart inside the configuration file (is: {new_as_token_facebook}, was: {generated_as_token_facebook})"
        assert generated_hs_token_facebook == new_hs_token_facebook, f"hs_token should stay the same after restart inside the configuration file (is: {new_hs_token_facebook}, was: {generated_hs_token_facebook})"

        new_as_token_facebook = get_as_token_from(registration_yaml)
        new_hs_token_facebook = get_hs_token_from(registration_yaml)

        assert generated_as_token_facebook == new_as_token_facebook, f"as_token should stay the same after restart inside the registration file (is: {new_as_token_facebook}, was: {generated_as_token_facebook})"
        assert generated_hs_token_facebook == new_hs_token_facebook, f"hs_token should stay the same after restart inside the registration file (is: {new_hs_token_facebook}, was: {generated_hs_token_facebook})"

    with subtest("ensure messages can be exchanged after restart"):
        client.succeed("do_test ${username} ${instagramBotUsername} ${homeserverUrl} \"Hello, I'm a Instagram bridge bot.\" >&2")
        client.succeed("do_test ${username} ${metaBotUsername} ${homeserverUrl} \"Hello, I'm a Facebook Messenger bridge bot.\" >&2")
  '';
}
