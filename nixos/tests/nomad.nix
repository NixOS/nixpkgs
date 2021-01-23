import ./make-test-python.nix (
  { lib, ... }: {
    name = "nomad";
    nodes = {
      server = { config, pkgs, lib, ... }: {
        networking = {
          interfaces.eth1.ipv4.addresses = lib.mkOverride 0 [{
            address = "192.168.1.1";
            prefixLength = 16;
          }];
        };

        environment.etc."nomad.custom.json".source =
          (pkgs.formats.json { }).generate "nomad.custom.json" {
            region = "universe";
            datacenter = "earth";
          };

        services.nomad = {
          enable = true;

          settings = {
            data_dir = "/var/lib/nomad";

            server = {
              enabled = true;
              bootstrap_expect = 1;
            };
          };

          extraSettingsPaths = [ config.environment.etc."nomad.custom.json".source ];
          enableDocker = false;
        };
      };
    };

    testScript = ''
      server.wait_for_unit("nomad.service")

      # wait for healthy server
      server.wait_until_succeeds(
          "[ $(nomad operator raft list-peers | grep true | wc -l) == 1 ]"
      )

      # wait for server liveness
      server.succeed("[ $(nomad server members | grep -o alive | wc -l) == 1 ]")

      # check the region
      server.succeed("nomad server members | grep -o universe")

      # check the datacenter
      server.succeed("[ $(nomad server members | grep -o earth | wc -l) == 1 ]")
    '';
  }
)
