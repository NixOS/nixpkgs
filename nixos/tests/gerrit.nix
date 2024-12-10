import ./make-test-python.nix (
  { pkgs, ... }:

  let
    lfs = pkgs.fetchurl {
      url = "https://gerrit-ci.gerritforge.com/job/plugin-lfs-bazel-master/90/artifact/bazel-bin/plugins/lfs/lfs.jar";
      sha256 = "023b0kd8djm3cn1lf1xl67yv3j12yl8bxccn42lkfmwxjwjfqw6h";
    };

  in
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

            plugins = [ lfs ];
            builtinPlugins = [
              "hooks"
              "webhooks"
            ];
            settings = {
              gerrit.canonicalWebUrl = "http://server";
              lfs.plugin = "lfs";
              plugins.allowRemoteAdmin = true;
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
