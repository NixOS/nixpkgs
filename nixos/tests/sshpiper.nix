{
  pkgs,
  lib,
  ...
}:
let
  inherit (import ./ssh-keys.nix pkgs)
    snakeOilEd25519PrivateKey
    snakeOilEd25519PublicKey
    ;
in
{
  name = "sshpiper";
  meta.maintainers = with lib.maintainers; [ cashmeredev ];

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

      services.openssh = {
        enable = true;
        settings = {
          PasswordAuthentication = false;
          PermitRootLogin = "no";
        };
      };

      # The upstream key is generated at runtime by the sshpiper service.
      # We inject it into the server's authorized_keys in the test script.
      users.users.testuser = {
        isNormalUser = true;
      };
    };

    proxy = {
      networking = {
        useNetworkd = true;
        useDHCP = false;
        firewall.enable = false;
      };

      systemd.network.networks."01-eth1" = {
        name = "eth1";
        networkConfig.Address = "10.0.0.2/24";
      };

      services.sshpiper = {
        enable = true;
        port = 2222;
        logLevel = "debug";

        authorizedKeys = [
          snakeOilEd25519PublicKey
        ];

        pipes = [
          {
            from = [
              { username = "testuser"; }
            ];
            to = {
              host = "10.0.0.1:22";
              username = "testuser";
            };
          }
        ];
      };
    };
  };

  testScript = ''
    start_all()

    server.wait_for_unit("sshd.service")
    server.wait_for_open_port(22)

    proxy.wait_for_unit("sshpiper.service")
    proxy.wait_for_open_port(2222)

    # Add the sshpiper upstream public key to the server's testuser so that
    # the proxied connection is accepted.
    proxy.wait_for_file("/var/lib/sshpiper/upstream_key.pub")
    upstream_pub = proxy.succeed("cat /var/lib/sshpiper/upstream_key.pub").strip()
    server.succeed(
        f"mkdir -p ~testuser/.ssh && echo '{upstream_pub}' >> ~testuser/.ssh/authorized_keys && "
        "chown -R testuser:users ~testuser/.ssh && chmod 700 ~testuser/.ssh && "
        "chmod 600 ~testuser/.ssh/authorized_keys"
    )

    # Connect through sshpiper and run a command on the server.
    proxy.succeed("cat ${snakeOilEd25519PrivateKey} > /tmp/privkey && chmod 600 /tmp/privkey")
    result = proxy.succeed(
        "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "
        "-i /tmp/privkey "
        "-p 2222 testuser@127.0.0.1 echo hello-from-sshpiper"
    )
    assert "hello-from-sshpiper" in result, f"unexpected output: {result}"
  '';
}
