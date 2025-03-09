import ./make-test-python.nix (
  { pkgs, lib, ... }:

  let
    successMessage = "Success 3333115147933743662";
  in
  {
    name = "rathole";
    meta.maintainers = with lib.maintainers; [ xokdvium ];
    nodes = {
      server = {
        networking = {
          useNetworkd = true;
          useDHCP = false;
          firewall.enable = false;
        };

        systemd.network.networks."01-eth1" = {
          name = "eth1";
          networkConfig.Address = "10.0.0.1/24";
        };

        services.rathole = {
          enable = true;
          role = "server";
          settings = {
            server = {
              bind_addr = "0.0.0.0:2333";
              services = {
                success-message = {
                  bind_addr = "0.0.0.0:80";
                  token = "hunter2";
                };
              };
            };
          };
        };
      };

      client = {
        networking = {
          useNetworkd = true;
          useDHCP = false;
        };

        systemd.network.networks."01-eth1" = {
          name = "eth1";
          networkConfig.Address = "10.0.0.2/24";
        };

        services.nginx = {
          enable = true;
          virtualHosts."127.0.0.1" = {
            root = pkgs.writeTextDir "success-message.txt" successMessage;
          };
        };

        services.rathole = {
          enable = true;
          role = "client";
          credentialsFile = pkgs.writeText "rathole-credentials.toml" ''
            [client.services.success-message]
            token = "hunter2"
          '';
          settings = {
            client = {
              remote_addr = "10.0.0.1:2333";
              services.success-message = {
                local_addr = "127.0.0.1:80";
              };
            };
          };
        };
      };
    };

    testScript = ''
      start_all()
      server.wait_for_unit("rathole.service")
      server.wait_for_open_port(2333)
      client.wait_for_unit("rathole.service")
      server.wait_for_open_port(80)
      response = server.succeed("curl http://127.0.0.1/success-message.txt")
      assert "${successMessage}" in response, "Got invalid response"
      response = client.succeed("curl http://10.0.0.1/success-message.txt")
      assert "${successMessage}" in response, "Got invalid response"
    '';
  }
)
