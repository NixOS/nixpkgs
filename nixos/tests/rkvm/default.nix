import ../make-test-python.nix (
  { pkgs, ... }:
  let
    # Generated with
    #
    # nix shell .#rkvm --command "rkvm-certificate-gen --ip-addresses 10.0.0.1 cert.pem key.pem"
    #
    snakeoil-cert = ./cert.pem;
    snakeoil-key = ./key.pem;
  in
  {
    name = "rkvm";

    nodes = {
      server =
        { pkgs, ... }:
        {
          imports = [ ../common/user-account.nix ];

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

          services.getty.autologinUser = "alice";

          services.rkvm.server = {
            enable = true;
            settings = {
              certificate = snakeoil-cert;
              key = snakeoil-key;
              password = "snakeoil";
              switch-keys = [
                "left-alt"
                "right-alt"
              ];
            };
          };
        };

      client =
        { pkgs, ... }:
        {
          imports = [ ../common/user-account.nix ];

          virtualisation.vlans = [ 1 ];

          networking = {
            useNetworkd = true;
            useDHCP = false;
            firewall.enable = false;
          };

          systemd.network.networks."01-eth1" = {
            name = "eth1";
            networkConfig.Address = "10.0.0.2/24";
          };

          services.getty.autologinUser = "alice";

          services.rkvm.client = {
            enable = true;
            settings = {
              server = "10.0.0.1:5258";
              certificate = snakeoil-cert;
              key = snakeoil-key;
              password = "snakeoil";
            };
          };
        };
    };

    testScript = ''
      server.wait_for_unit("getty@tty1.service")
      server.wait_until_succeeds("pgrep -f 'agetty.*tty1'")
      server.wait_for_unit("rkvm-server")
      server.wait_for_open_port(5258)

      client.wait_for_unit("getty@tty1.service")
      client.wait_until_succeeds("pgrep -f 'agetty.*tty1'")
      client.wait_for_unit("rkvm-client")

      server.sleep(1)

      # Switch to client
      server.send_key("alt-alt_r", delay=0.2)
      server.send_chars("echo 'hello client' > /tmp/test.txt\n")

      # Switch to server
      server.send_key("alt-alt_r", delay=0.2)
      server.send_chars("echo 'hello server' > /tmp/test.txt\n")

      server.sleep(1)

      client.systemctl("stop rkvm-client.service")
      server.systemctl("stop rkvm-server.service")

      server_file = server.succeed("cat /tmp/test.txt")
      assert server_file.strip() == "hello server"

      client_file = client.succeed("cat /tmp/test.txt")
      assert client_file.strip() == "hello client"
    '';
  }
)
