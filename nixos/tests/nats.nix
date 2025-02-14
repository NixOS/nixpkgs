let

  port = 4222;
  username = "client";
  password = "password";
  topic = "foo.bar";

in
import ./make-test-python.nix (
  { pkgs, lib, ... }:
  {
    name = "nats";
    meta = with pkgs.lib; {
      maintainers = with maintainers; [ c0deaddict ];
    };

    nodes =
      let
        client =
          { pkgs, ... }:
          {
            environment.systemPackages = with pkgs; [ natscli ];
          };
      in
      {
        server =
          { pkgs, ... }:
          {
            networking.firewall.allowedTCPPorts = [ port ];
            services.nats = {
              inherit port;
              enable = true;
              settings = {
                authorization = {
                  users = [
                    {
                      user = username;
                      inherit password;
                    }
                  ];
                };
              };
            };
          };

        client1 = client;
        client2 = client;
      };

    testScript =
      let
        file = "/tmp/msg";
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
                lambda: client1.succeed(nats_cmd("sub", "--count", "1", "${topic}")),
                lambda: client2.succeed("sleep 2 && {}".format(nats_cmd("pub", "${topic}", "hello"))),
            )
      '';
  }
)
