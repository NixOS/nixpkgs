import ./make-test-python.nix {
  name = "sslh";

  nodes = {
    server = { pkgs, lib, ... }: {
      networking.firewall.allowedTCPPorts = [ 443 ];
      networking.interfaces.eth1.ipv6.addresses = [
        {
          address = "fe00:aa:bb:cc::2";
          prefixLength = 64;
        }
      ];
      services.sslh = {
        enable = true;
        settings.transparent = true;
        settings.protocols = [
          { name = "ssh"; service = "ssh"; host = "localhost"; port = "22"; probe = "builtin"; }
          { name = "http"; host = "localhost"; port = "80"; probe = "builtin"; }
        ];
      };
      services.openssh.enable = true;
      users.users.root.openssh.authorizedKeys.keyFiles = [ ./initrd-network-ssh/id_ed25519.pub ];
      services.nginx = {
        enable = true;
        virtualHosts."localhost" = {
          addSSL = false;
          default = true;
          root = pkgs.runCommand "testdir" {} ''
            mkdir "$out"
            echo hello world > "$out/index.html"
          '';
        };
      };
    };
    client = { ... }: {
      networking.interfaces.eth1.ipv6.addresses = [
        {
          address = "fe00:aa:bb:cc::1";
          prefixLength = 64;
        }
      ];
      networking.hosts."fe00:aa:bb:cc::2" = [ "server" ];
      environment.etc.sshKey = {
        source = ./initrd-network-ssh/id_ed25519; # dont use this anywhere else
        mode = "0600";
      };
    };
  };

  testScript = ''
    start_all()

    server.wait_for_unit("sslh.service")
    server.wait_for_unit("nginx.service")
    server.wait_for_unit("sshd.service")
    server.wait_for_open_port(80)
    server.wait_for_open_port(443)
    server.wait_for_open_port(22)

    for arg in ["-6", "-4"]:
        client.wait_until_succeeds(f"ping {arg} -c1 server")

        # check that ssh through sslh works
        client.succeed(
            f"ssh {arg} -p 443 -i /etc/sshKey -o StrictHostKeyChecking=accept-new server 'echo $SSH_CONNECTION > /tmp/foo{arg}'"
        )

        # check that 1/ the above ssh command had an effect 2/ transparent proxying really works
        ip = "fe00:aa:bb:cc::1" if arg == "-6" else "192.168.1."
        server.succeed(f"grep '{ip}' /tmp/foo{arg}")

        # check that http through sslh works
        assert client.succeed(f"curl -f {arg} http://server:443").strip() == "hello world"
  '';
}
