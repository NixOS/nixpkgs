import ./make-test-python.nix (
  { pkgs, ... }:

  {
    name = "gerrit";

    meta = with pkgs.lib.maintainers; {
      maintainers = [
        flokli
        zimbatm
      ];
    };

    nodes = {
      server =
        { config, pkgs, ... }:
        {
          networking.firewall.allowedTCPPorts = [
            80
            2222
          ];

          services.gerrit = {
            enable = true;
            serverId = "aa76c84b-50b0-4711-a0a0-1ee30e45bbd0";
            listenAddress = "[::]:80";
            jvmHeapLimit = "1g";

            builtinPlugins = [
              "hooks"
              "webhooks"
            ];
            settings = {
              gerrit.canonicalWebUrl = "http://server";
              sshd.listenAddress = "[::]:2222";
              sshd.advertisedAddress = "[::]:2222";
            };
          };
        };

      client =
        { ... }:
        {
        };
    };

    testScript = ''
      start_all()
      server.wait_for_unit("gerrit.service")
      server.wait_for_open_port(80)
      client.succeed("curl http://server")

      server.wait_for_open_port(2222)
      client.succeed("nc -z server 2222")
    '';
  }
)
