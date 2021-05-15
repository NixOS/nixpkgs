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
                  { "compress" = true; "names" = [ "client" "webclient" ]; }
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
            { libraries = [ pkgs.python3Packages.matrix-client ]; } ''
            import socket
            from matrix_client.client import MatrixClient
            from time import sleep

            matrix = MatrixClient("${homeserverUrl}")
            matrix.register_with_password(username="alice", password="foobar")

            irc = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            irc.connect(("ircd", 6667))
            irc.setsockopt(socket.IPPROTO_TCP, socket.TCP_NODELAY, 1)
            irc.send(b"USER bob bob bob :bob\n")
            irc.send(b"NICK bob\n")

            m_room = matrix.join_room("#irc_#test:homeserver")
            irc.send(b"JOIN #test\n")

            # plenty of time for the joins to happen
            sleep(10)

            m_room.send_text("hi from matrix")
            irc.send(b"PRIVMSG #test :hi from irc \r\n")

            print("Waiting for irc message...")
            while True:
                buf = irc.recv(10000)
                if b"hi from matrix" in buf:
                    break

            print("Waiting for matrix message...")


            def callback(room, e):
                if "hi from irc" in e['content']['body']:
                    exit(0)


            m_room.add_listener(callback, "m.room.message")
            matrix.listen_forever()
          ''
          )
        ];
      };
    };

    testScript = ''
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
          client.succeed("do_test")
    '';

  })
