{ lib, ... }:
{
  name = "nomad";
  nodes = {
    default_server =
      { pkgs, lib, ... }:
      {
        networking = {
          interfaces.eth1.ipv4.addresses = lib.mkOverride 0 [
            {
              address = "192.168.1.1";
              prefixLength = 16;
            }
          ];
        };

        environment.etc."nomad.custom.json".source = (pkgs.formats.json { }).generate "nomad.custom.json" {
          region = "universe";
          datacenter = "earth";
        };

        services.nomad = {
          enable = true;

          settings = {
            server = {
              enabled = true;
              bootstrap_expect = 1;
            };
          };

          extraSettingsPaths = [ "/etc/nomad.custom.json" ];
          enableDocker = false;
        };
      };

    custom_state_dir_server =
      { pkgs, lib, ... }:
      {
        networking = {
          interfaces.eth1.ipv4.addresses = lib.mkOverride 0 [
            {
              address = "192.168.1.1";
              prefixLength = 16;
            }
          ];
        };

        environment.etc."nomad.custom.json".source = (pkgs.formats.json { }).generate "nomad.custom.json" {
          region = "universe";
          datacenter = "earth";
        };

        services.nomad = {
          enable = true;
          dropPrivileges = false;

          settings = {
            data_dir = "/nomad/data/dir";
            server = {
              enabled = true;
              bootstrap_expect = 1;
            };
          };

          extraSettingsPaths = [ "/etc/nomad.custom.json" ];
          enableDocker = false;
        };

        systemd.services.nomad.serviceConfig.ExecStartPre = "${pkgs.writeShellScript "mk_data_dir" ''
          set -euxo pipefail

          ${pkgs.coreutils}/bin/mkdir -p /nomad/data/dir
        ''}";
      };
  };

  testScript = ''
    def test_nomad_server(server):
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


    servers = [default_server, custom_state_dir_server]

    for server in servers:
        test_nomad_server(server)
  '';
}
