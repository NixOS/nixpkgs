let

  port = 4222;
  username = "client";
  password = "password";

in
import ./make-test-python.nix ({ pkgs, lib, ... }: {
  name = "nats";
  meta = with pkgs.lib; { maintainers = with maintainers; [ c0deaddict ]; };

  nodes =
    let
      client = { pkgs, ... }: {
        environment.systemPackages = with pkgs; [ natscli ];
      };
    in
    {
      server = { pkgs, ... }: {
        networking.firewall.allowedTCPPorts = [ port ];
        services.nats = {
          inherit port;
          enable = true;
          jetstream = true;
          settings = {
            jetstream = {
              max_file = "32M";
              max_mem = "32M";
            };
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

  testScript =
    let
      stream = pkgs.writeText "stream.json" (builtins.toJSON {
        name = "TEST";
        subjects = [ "TEST.>" ];
        retention = "limits";
        storage = "file";
        num_replicas = 1;
      });
      consumer = pkgs.writeText "consumer.json" (builtins.toJSON {
        deliver_policy = "all";
        deliver_subject = "consume";
        filter_subject = "TEST.topic";
      });
    in
    ''
      def nats_cmd(*args):
          return (
              "nats "
              "--server=nats://server:${toString port} "
              "--user=${username} "
              "--password=${password} "
              "{}"
          ).format(" ".join(args))

      def parallel(*fns):
          from threading import Thread
          threads = [ Thread(target=fn) for fn in fns ]
          for t in threads: t.start()
          for t in threads: t.join()

      start_all()
      server.wait_for_unit("nats.service")

      with subtest("pub sub"):
          parallel(
              lambda: client1.succeed(nats_cmd("sub", "--count", "1", "foo.bar")),
              lambda: client2.succeed("sleep 2 && {}".format(nats_cmd("pub", "foo.bar", "hello"))),
          )

      with subtest("jetstream publish and consume"):
          client1.succeed(nats_cmd("str", "add", "TEST", "--config", "${stream}"))
          client1.succeed(nats_cmd("con", "add", "TEST", "CON", "--config", "${consumer}"))
          client1.succeed(nats_cmd("pub", "TEST.topic", "hello"))
          print(client1.succeed(nats_cmd("str", "info", "TEST")))
          client2.succeed(nats_cmd("sub", "--count", "1", "--ack", "consume"))
    '';
})
