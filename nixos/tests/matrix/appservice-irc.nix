{ pkgs, ... }:
  let
    homeserverUrl = "http://homeserver:8008";
  in
  {
    name = "matrix-appservice-irc";
    meta = {
      maintainers = pkgs.matrix-appservice-irc.meta.maintainers;
    };

    nodes = {
      homeserver = {
        # We'll switch to this once the config is copied into place
        specialisation.running.configuration = {
          services.matrix-synapse = {
            enable = true;
            settings = {
              database.name = "sqlite3";
              app_service_config_files = [ "/registration.yml" ];

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

      ircd = {
        services.ngircd = {
          enable = true;
          config = ''
            [Global]
              Name = ircd.ircd
              Info = Server Info Text
              AdminInfo1 = _

            [Channel]
              Name = #test
              Topic = a cool place

            [Options]
              PAM = no
          '';
        };
        networking.firewall.allowedTCPPorts = [ 6667 ];
      };

      appservice = { pkgs, ... }: {
        services.matrix-appservice-irc = {
          enable = true;
          registrationUrl = "http://appservice:8009";

          settings = {
            homeserver.url = homeserverUrl;
            homeserver.domain = "homeserver";

            ircService = {
              servers."ircd" = {
                name = "IRCd";
                port = 6667;
                dynamicChannels = {
                  enabled = true;
                  aliasTemplate = "#irc_$CHANNEL";
                };
              };
              mediaProxy = {
                publicUrl = "http://localhost:11111/media";
                ttl = 0;
              };
            };
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
              import socket
              import functools
              from time import sleep
              import asyncio

              from nio import AsyncClient, RoomMessageText, JoinResponse


              async def matrix_room_message_text_callback(matrix: AsyncClient, msg: str, _r, e):
                  print("Received matrix text message: ", e)
                  if msg in e.body:
                      print("Received hi from IRC")
                      await matrix.close()
                      exit(0)  # Actual exit point


              class IRC:
                  def __init__(self):
                      sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
                      sock.connect(("ircd", 6667))
                      sock.setsockopt(socket.IPPROTO_TCP, socket.TCP_NODELAY, 1)
                      sock.send(b"USER bob bob bob :bob\n")
                      sock.send(b"NICK bob\n")
                      self.sock = sock

                  def join(self, room: str):
                      self.sock.send(f"JOIN {room}\n".encode())

                  def privmsg(self, room: str, msg: str):
                      self.sock.send(f"PRIVMSG {room} :{msg}\n".encode())

                  def expect_msg(self, body: str):
                      buffer = ""
                      while True:
                          buf = self.sock.recv(1024).decode()
                          buffer += buf
                          if body in buffer:
                              return


              async def run(homeserver: str):
                  irc = IRC()

                  matrix = AsyncClient(homeserver)
                  response = await matrix.register("alice", "foobar")
                  print("Matrix register response: ", response)

                  response = await matrix.join("#irc_#test:homeserver")
                  print("Matrix join room response:", response)
                  assert isinstance(response, JoinResponse)
                  room_id = response.room_id

                  irc.join("#test")
                  # FIXME: what are we waiting on here? Matrix? IRC? Both?
                  # 10s seem bad for busy hydra machines.
                  sleep(10)

                  # Exchange messages
                  print("Sending text message to matrix room")
                  response = await matrix.room_send(
                      room_id=room_id,
                      message_type="m.room.message",
                      content={"msgtype": "m.text", "body": "hi from matrix"},
                  )
                  print("Matrix room send response: ", response)
                  irc.privmsg("#test", "hi from irc")

                  print("Waiting for the matrix message to appear on the IRC side...")
                  irc.expect_msg("hi from matrix")

                  callback = functools.partial(
                      matrix_room_message_text_callback, matrix, "hi from irc"
                  )
                  matrix.add_event_callback(callback, RoomMessageText)

                  print("Waiting for matrix message...")
                  await matrix.sync_forever()

                  exit(1)  # Unreachable


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

      ircd.wait_for_unit("ngircd.service")
      ircd.wait_for_open_port(6667)

      with subtest("start the appservice"):
          appservice.wait_for_unit("matrix-appservice-irc.service")
          appservice.wait_for_open_port(8009)
          appservice.wait_for_file("/var/lib/matrix-appservice-irc/media-signingkey.jwk")
          appservice.wait_for_open_port(11111)

      with subtest("copy the registration file"):
          appservice.copy_from_vm("/var/lib/matrix-appservice-irc/registration.yml")
          homeserver.copy_from_host(
              str(pathlib.Path(os.environ.get("out", os.getcwd())) / "registration.yml"), "/"
          )
          homeserver.succeed("chmod 444 /registration.yml")

      with subtest("start the homeserver"):
          homeserver.succeed(
              "/run/current-system/specialisation/running/bin/switch-to-configuration test >&2"
          )

          homeserver.wait_for_unit("matrix-synapse.service")
          homeserver.wait_for_open_port(8008)

      with subtest("ensure messages can be exchanged"):
          client.succeed("do_test ${homeserverUrl} >&2")
    '';
  }
