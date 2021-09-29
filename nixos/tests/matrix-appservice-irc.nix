import ./make-test-python.nix ({ pkgs, ... }:
  let
    homeserverUrl = "http://homeserver:8448";
  in
  {
    name = "matrix-appservice-irc";
    meta = {
      maintainers = pkgs.matrix-appservice-irc.meta.maintainers;
    };

    nodes = {
      homeserver = { pkgs, ... }: {
        # We'll switch to this once the config is copied into place
        specialisation.running.configuration = {
          services.matrix-synapse = {
            enable = true;
            database_type = "sqlite3";
            app_service_config_files = [ "/registration.yml" ];

            enable_registration = true;

            listeners = [
              # The default but tls=false
              {
                "bind_address" = "";
                "port" = 8448;
                "resources" = [
                  { "compress" = true; "names" = [ "client" ]; }
                  { "compress" = false; "names" = [ "federation" ]; }
                ];
                "tls" = false;
                "type" = "http";
                "x_forwarded" = false;
              }
            ];
          };

          networking.firewall.allowedTCPPorts = [ 8448 ];
        };
      };

      ircd = { pkgs, ... }: {
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

            ircService.servers."ircd" = {
              name = "IRCd";
              port = 6667;
              dynamicChannels = {
                enabled = true;
                aliasTemplate = "#irc_$CHANNEL";
              };
            };
          };
        };

        networking.firewall.allowedTCPPorts = [ 8009 ];
      };

      client = { pkgs, ... }: {
        environment.systemPackages = [
          (pkgs.writers.writePython3Bin "do_test"
            { libraries = [ pkgs.python3Packages.matrix-nio ]; } ''
            import socket
            from nio import AsyncClient, RoomMessageText
            from time import sleep
            import asyncio


            async def run():
                matrix = AsyncClient("${homeserverUrl}")
                await matrix.register("alice", "foobar")

                irc = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
                irc.connect(("ircd", 6667))
                irc.setsockopt(socket.IPPROTO_TCP, socket.TCP_NODELAY, 1)
                irc.send(b"USER bob bob bob :bob\n")
                irc.send(b"NICK bob\n")

                room_id = (await matrix.join("#irc_#test:homeserver")).room_id
                irc.send(b"JOIN #test\n")

                # plenty of time for the joins to happen
                sleep(10)

                # Exchange messages
                await matrix.room_send(
                    room_id=room_id,
                    message_type="m.room.message",
                    content={
                        "msgtype": "m.text",
                        "body": "hi from matrix"
                    }
                )
                irc.send(b"PRIVMSG #test :hi from irc \r\n")

                print("Waiting for irc message...")
                while True:
                    buf = irc.recv(10000)
                    if b"hi from matrix" in buf:
                        print("Got IRC message")
                        break

                print("Waiting for matrix message...")

                async def callback(room, e):
                    if "hi from irc" in e.body:
                        print("Got Matrix message")
                        await matrix.close()
                        exit(0)  # Actual exit point

                matrix.add_event_callback(callback, RoomMessageText)
                await matrix.sync_forever()
                exit(1)  # Unreachable

            asyncio.run(run())
          ''
          )
        ];
      };
    };

    testScript = ''
      import pathlib

      start_all()

      ircd.wait_for_unit("ngircd.service")
      ircd.wait_for_open_port(6667)

      with subtest("start the appservice"):
          appservice.wait_for_unit("matrix-appservice-irc.service")
          appservice.wait_for_open_port(8009)

      with subtest("copy the registration file"):
          appservice.copy_from_vm("/var/lib/matrix-appservice-irc/registration.yml")
          homeserver.copy_from_host(
              pathlib.Path(os.environ.get("out", os.getcwd())) / "registration.yml", "/"
          )
          homeserver.succeed("chmod 444 /registration.yml")

      with subtest("start the homeserver"):
          homeserver.succeed(
              "/run/current-system/specialisation/running/bin/switch-to-configuration test >&2"
          )

          homeserver.wait_for_unit("matrix-synapse.service")
          homeserver.wait_for_open_port(8448)

      with subtest("ensure messages can be exchanged"):
          client.succeed("do_test >&2")
    '';
  })
