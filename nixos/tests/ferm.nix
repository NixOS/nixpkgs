import ./make-test-python.nix (
  { pkgs, ... }:
  {
    name = "ferm";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ mic92 ];
    };

    nodes = {
      client =
        { pkgs, ... }:
        with pkgs.lib;
        {
          networking = {
            dhcpcd.enable = false;
            interfaces.eth1.ipv6.addresses = mkOverride 0 [
              {
                address = "fd00::2";
                prefixLength = 64;
              }
            ];
            interfaces.eth1.ipv4.addresses = mkOverride 0 [
              {
                address = "192.168.1.2";
                prefixLength = 24;
              }
            ];
          };
        };
      server =
        { pkgs, ... }:
        with pkgs.lib;
        {
          networking = {
            dhcpcd.enable = false;
            useNetworkd = true;
            useDHCP = false;
            interfaces.eth1.ipv6.addresses = mkOverride 0 [
              {
                address = "fd00::1";
                prefixLength = 64;
              }
            ];
            interfaces.eth1.ipv4.addresses = mkOverride 0 [
              {
                address = "192.168.1.1";
                prefixLength = 24;
              }
            ];
          };

          services = {
            ferm.enable = true;
            ferm.config = ''
              domain (ip ip6) table filter chain INPUT {
                interface lo ACCEPT;
                proto tcp dport 8080 REJECT reject-with tcp-reset;
              }
            '';
            nginx.enable = true;
            nginx.httpConfig = ''
              server {
                listen 80;
                listen [::]:80;
                listen 8080;
                listen [::]:8080;

                location /status { stub_status on; }
              }
            '';
          };
        };
    };

    testScript = ''
      start_all()

      client.systemctl("start network-online.target")
      server.systemctl("start network-online.target")
      client.wait_for_unit("network-online.target")
      server.wait_for_unit("network-online.target")
      server.wait_for_unit("ferm.service")
      server.wait_for_unit("nginx.service")
      server.wait_until_succeeds("ss -ntl | grep -q 80")

      with subtest("port 80 is allowed"):
          client.succeed("curl --fail -g http://192.168.1.1:80/status")
          client.succeed("curl --fail -g http://[fd00::1]:80/status")

      with subtest("port 8080 is not allowed"):
          server.succeed("curl --fail -g http://192.168.1.1:8080/status")
          server.succeed("curl --fail -g http://[fd00::1]:8080/status")

          client.fail("curl --fail -g http://192.168.1.1:8080/status")
          client.fail("curl --fail -g http://[fd00::1]:8080/status")
    '';
  }
)
