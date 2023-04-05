import ./make-test-python.nix ({ pkgs, ... }: {
  name = "owncast";
  meta = with pkgs.lib.maintainers; { maintainers = [ MayNiklas ]; };

  nodes = {
    client = { pkgs, ... }: with pkgs.lib; {
      networking = {
        dhcpcd.enable = false;
        interfaces.eth1.ipv6.addresses = mkOverride 0 [ { address = "fd00::2"; prefixLength = 64; } ];
        interfaces.eth1.ipv4.addresses = mkOverride 0 [ { address = "192.168.1.2"; prefixLength = 24; } ];
      };
    };
    server = { pkgs, ... }: with pkgs.lib; {
      networking = {
        dhcpcd.enable = false;
        useNetworkd = true;
        useDHCP = false;
        interfaces.eth1.ipv6.addresses = mkOverride 0 [ { address = "fd00::1"; prefixLength = 64; } ];
        interfaces.eth1.ipv4.addresses = mkOverride 0 [ { address = "192.168.1.1"; prefixLength = 24; } ];

        firewall.allowedTCPPorts = [ 8080 ];
      };

      services.owncast = {
        enable = true;
        listen = "0.0.0.0";
      };
    };
  };

  testScript = ''
    start_all()

    client.wait_for_unit("network-online.target")
    server.wait_for_unit("network-online.target")
    server.wait_for_unit("owncast.service")
    server.wait_until_succeeds("ss -ntl | grep -q 8080")

    client.succeed("curl http://192.168.1.1:8080/api/status")
    client.succeed("curl http://[fd00::1]:8080/api/status")
  '';
})
