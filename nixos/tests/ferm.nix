
import ./make-test.nix ({ pkgs, ...} : {
  name = "ferm";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ mic92 ];
  };

  nodes =
    { client =
        { config, pkgs, ... }:
        with pkgs.lib;
        {
          networking = {
            interfaces.eth1.ip6 = mkOverride 0 [ { address = "fd00::2"; prefixLength = 64; } ];
            interfaces.eth1.ip4 = mkOverride 0 [ { address = "192.168.1.2"; prefixLength = 24; } ];
          };
      };
      server =
        { config, pkgs, ... }:
        with pkgs.lib;
        {
          networking = {
            interfaces.eth1.ip6 = mkOverride 0 [ { address = "fd00::1"; prefixLength = 64; } ];
            interfaces.eth1.ip4 = mkOverride 0 [ { address = "192.168.1.1"; prefixLength = 24; } ];
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

  testScript =
    ''
      startAll;

      $client->waitForUnit("network.target");
      $server->waitForUnit("ferm.service");
      $server->waitForUnit("nginx.service");
      $server->waitUntilSucceeds("ss -ntl | grep -q 80");

      subtest "port 80 is allowed", sub {
          $client->succeed("curl --fail -g http://192.168.1.1:80/status");
          $client->succeed("curl --fail -g http://[fd00::1]:80/status");
      };

      subtest "port 8080 is not allowed", sub {
          $server->succeed("curl --fail -g http://192.168.1.1:8080/status");
          $server->succeed("curl --fail -g http://[fd00::1]:8080/status");

          $client->fail("curl --fail -g http://192.168.1.1:8080/status");
          $client->fail("curl --fail -g http://[fd00::1]:8080/status");
      };
    '';
})
