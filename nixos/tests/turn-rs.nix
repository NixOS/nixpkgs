import ./make-test-python.nix (
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
            turn = {
              realm = "localhost";
              interfaces = [
                {
                  transport = "udp";
                  bind = "127.0.0.1:3478";
                  external = "127.0.0.1:3478";
                }
                {
                  transport = "tcp";
                  bind = "127.0.0.1:3478";
                  external = "127.0.0.1:3478";
                }
              ];
            };

            auth.static_credentials.user1 = "$USER_1_CREDS";
          };
        };
      };
    };

    testScript = # python
      ''
        import json

        start_all()
        server.wait_for_unit('turn-rs.service')
        server.wait_for_open_port(3000, "127.0.0.1")

        info = server.succeed('curl http://localhost:3000/info')
        jsonInfo = json.loads(info)
        assert len(jsonInfo['interfaces']) == 2, f'Interfaces doesn\'t contain two entries:\n{json.dumps(jsonInfo, indent=2)}'

        config = server.succeed('cat /run/turn-rs/config.toml')
        assert 'foobar' in config, f'Secrets are not properly injected:\n{config}'
      '';
  }
)
