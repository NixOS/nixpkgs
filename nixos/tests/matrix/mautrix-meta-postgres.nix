{ pkgs, ... }:
let
  homeserverDomain = "server";
  homeserverUrl = "http://server:8008";
  userName = "alice";
  botUserName = "instagrambot";

  asToken = "this-is-my-totally-randomly-generated-as-token";
  hsToken = "this-is-my-totally-randomly-generated-hs-token";
in
{
  name = "mautrix-meta-postgres";
  meta.maintainers = pkgs.mautrix-meta.meta.maintainers;

  nodes = {
    server =
      { config, pkgs, ... }:
      {
        services.postgresql = {
          enable = true;

          ensureUsers = [
            {
              name = "mautrix-meta-instagram";
              ensureDBOwnership = true;
            }
          ];

          ensureDatabases = [
            "mautrix-meta-instagram"
          ];
        };

        systemd.services.mautrix-meta-instagram = {
          wants = [ "postgres.service" ];
          after = [ "postgres.service" ];
        };

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

        services.mautrix-meta.instances.instagram = {
          enable = true;

          environmentFile = pkgs.writeText ''my-secrets'' ''
            AS_TOKEN=${asToken}
            HS_TOKEN=${hsToken}
          '';

          settings = {
            homeserver = {
              address = homeserverUrl;
              domain = homeserverDomain;
            };

            appservice = {
              port = 8009;

              as_token = "$AS_TOKEN";
              hs_token = "$HS_TOKEN";

              database = {
                type = "postgres";
                uri = "postgres:///mautrix-meta-instagram?host=/var/run/postgresql";
              };

              bot.username = botUserName;
            };

            bridge.permissions."@${userName}:server" = "user";
          };
        };

        networking.firewall.allowedTCPPorts = [
          8008
          8009
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

              from nio import AsyncClient, RoomMessageNotice, RoomCreateResponse, RoomInviteResponse


              async def message_callback(matrix: AsyncClient, msg: str, _r, e):
                  print("Received matrix text message: ", e)
                  assert msg in e.body
                  exit(0)  # Success!


              async def run(homeserver: str):
                  matrix = AsyncClient(homeserver)
                  response = await matrix.register("${userName}", "foobar")
                  print("Matrix register response: ", response)

                  # Open a DM with the bridge bot
                  response = await matrix.room_create()
                  print("Matrix create room response:", response)
                  assert isinstance(response, RoomCreateResponse)
                  room_id = response.room_id

                  response = await matrix.room_invite(room_id, "@${botUserName}:${homeserverDomain}")
                  assert isinstance(response, RoomInviteResponse)

                  callback = functools.partial(
                      message_callback, matrix, "Hello, I'm an Instagram bridge bot."
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
    def extract_token(data):
        stdout = data[1]
        stdout = stdout.strip()
        line = stdout.split('\n')[-1]
        return line.split(':')[-1].strip("\" '\n")

    def get_token_from(token, file):
        data = server.execute(f"cat {file} | grep {token}")
        return extract_token(data)

    def get_as_token_from(file):
        return get_token_from("as_token", file)

    def get_hs_token_from(file):
        return get_token_from("hs_token", file)

    config_yaml = "/var/lib/mautrix-meta-instagram/config.yaml"
    registration_yaml = "/var/lib/mautrix-meta-instagram/meta-registration.yaml"

    expected_as_token = "${asToken}"
    expected_hs_token = "${hsToken}"

    start_all()

    with subtest("start the server"):
        # bridge
        server.wait_for_unit("mautrix-meta-instagram.service")

        # homeserver
        server.wait_for_unit("matrix-synapse.service")

        server.wait_for_open_port(8008)
        # Bridge only opens the port after it contacts the homeserver
        server.wait_for_open_port(8009)

    with subtest("ensure messages can be exchanged"):
        client.succeed("do_test ${homeserverUrl} >&2")

    with subtest("ensure as_token, hs_token match from environment file"):
        as_token = get_as_token_from(config_yaml)
        hs_token = get_hs_token_from(config_yaml)
        as_token_registration = get_as_token_from(registration_yaml)
        hs_token_registration = get_hs_token_from(registration_yaml)

        assert as_token == expected_as_token, f"as_token in config should match the one specified (is: {as_token}, expected: {expected_as_token})"
        assert hs_token == expected_hs_token, f"hs_token in config should match the one specified (is: {hs_token}, expected: {expected_hs_token})"
        assert as_token_registration == expected_as_token, f"as_token in registration should match the one specified (is: {as_token_registration}, expected: {expected_as_token})"
        assert hs_token_registration == expected_hs_token, f"hs_token in registration should match the one specified (is: {hs_token_registration}, expected: {expected_hs_token})"

    with subtest("ensure as_token and hs_token stays same after restart"):
        server.systemctl("restart mautrix-meta-instagram")
        server.wait_for_open_port(8009)

        as_token = get_as_token_from(config_yaml)
        hs_token = get_hs_token_from(config_yaml)
        as_token_registration = get_as_token_from(registration_yaml)
        hs_token_registration = get_hs_token_from(registration_yaml)

        assert as_token == expected_as_token, f"as_token in config should match the one specified (is: {as_token}, expected: {expected_as_token})"
        assert hs_token == expected_hs_token, f"hs_token in config should match the one specified (is: {hs_token}, expected: {expected_hs_token})"
        assert as_token_registration == expected_as_token, f"as_token in registration should match the one specified (is: {as_token_registration}, expected: {expected_as_token})"
        assert hs_token_registration == expected_hs_token, f"hs_token in registration should match the one specified (is: {hs_token_registration}, expected: {expected_hs_token})"
  '';
}
