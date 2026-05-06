{ pkgs, ... }:
{
  name = "turn-rs";

  nodes = {
    server = {
      virtualisation.vlans = [ 1 ];

      networking = {
        useNetworkd = true;
        useDHCP = false;
        firewall.enable = false;
      };

      systemd.network.networks."01-eth1" = {
        name = "eth1";
        networkConfig.Address = "10.0.0.1/24";
      };

      services.turn-rs = {
        enable = true;
        secretFile = pkgs.writeText "secret" ''
          USER_1_CREDS="foobar"
        '';
        settings = {
          server = {
            realm = "localhost";
            interfaces = [
              {
                transport = "udp";
                listen = "127.0.0.1:3478";
                external = "127.0.0.1:3478";
              }
              {
                transport = "tcp";
                listen = "127.0.0.1:3478";
                external = "127.0.0.1:3478";
              }
            ];
          };

          auth."static-credentials".user1 = "$USER_1_CREDS";
        };
      };
    };
  };

  testScript = # python
    ''
      start_all()
      server.wait_for_unit('turn-rs.service')
      server.wait_for_open_port(3478, "127.0.0.1")

      base = (
          "${pkgs.coturn}/bin/turnutils_uclient"
          " -L 127.0.0.1 -e 127.0.0.1 -u user1 -w foobar -X -y -t"
      )
      for extra in ["", "-s", "-t", "-t -s"]:
          out = server.succeed(f"{base} {extra} 127.0.0.1")
          assert "ERROR" not in out, f"turnutils_uclient errors:\n{out}"
          assert "Total lost packets 0 (0.000000%)" in out, (
              f"turnutils_uclient reported packet loss or did not finish:\n{out}"
          )

      config = server.succeed('cat /run/turn-rs/config.toml')
      assert 'foobar' in config, f'Secrets are not properly injected:\n{config}'
    '';
}
