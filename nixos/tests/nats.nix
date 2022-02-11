let

  port = 4222;
  username = "client";
  password = "password";
  topic = "foo.bar";

in import ./make-test-python.nix ({ pkgs, lib, ... }: {
  name = "nats";
  meta = with pkgs.lib; { maintainers = with maintainers; [ c0deaddict ]; };

  nodes = let
    client = { pkgs, ... }: {
      environment.systemPackages = with pkgs; [ natscli ];
    };
  in {
    server = { pkgs, ... }: {
      networking.firewall.allowedTCPPorts = [ port ];
      services.nats = {
        inherit port;
        enable = true;
        settings = {
          authorization = {
            users = [{
              user = username;
              inherit password;
            }];
          };
        };
      };
    };

    client1 = client;
    client2 = client;
  };

  testScript = let file = "/tmp/msg";
  in ''
    def nats_cmd(*args):
        return (
            "nats "
            "--server=nats://server:${toString port} "
            "--user=${username} "
            "--password=${password} "
            "{}"
        ).format(" ".join(args))

    start_all()
    server.wait_for_unit("nats.service")

    client1.fail("test -f ${file}")

    # Subscribe on topic on client1 and echo messages to file.
    client1.execute("({} | tee ${file} &)".format(nats_cmd("sub", "--raw", "${topic}")))

    # Give client1 some time to subscribe.
    client1.execute("sleep 2")

    # Publish message on client2.
    client2.execute(nats_cmd("pub", "${topic}", "hello"))

    # Check if message has been received.
    client1.succeed("grep -q hello ${file}")
  '';
})
