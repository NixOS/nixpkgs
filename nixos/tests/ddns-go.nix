{ ... }:

let
  IPv4 = "203.0.113.1";
  IPv6 = "2001:db8:1::1";
in
{
  name = "ddns-go";

  nodes = {
    machine =
      { pkgs, ... }:
      {
        services.nginx = {
          enable = true;
          commonHttpConfig = ''
            log_format ddns_log '[$time_local] myip=$arg_myip zone=$arg_zone';
          '';
          virtualHosts."ddns-go.test" = {
            listen = [
              {
                addr = "[::]";
                port = 80;
              }
            ];
            extraConfig = ''
              access_log  /var/log/nginx/ddns.log ddns_log;
            '';
            locations."/" = {
              extraConfig = ''
                default_type text/plain;
                return 200;
              '';
            };
          };
        };

        networking.hosts."::1" = [ "ddns-go.test" ];
        networking.interfaces.eth1 = {
          ipv4.addresses = [
            {
              address = IPv4;
              prefixLength = 24;
            }
          ];
          ipv6.addresses = [
            {
              address = IPv6;
              prefixLength = 128;
            }
          ];
        };

        # Fake DNS to trick ddns-go online check.
        services.dnsmasq = {
          enable = true;
          settings.address = [ "/#/::1" ];
        };

        services.ddns-go = {
          enable = true;
          # Test CAP_NET_BIND_SERVICE
          port = 1000;
          host = "[::]";
          extraFlags = [
            "-dns"
            "127.0.0.1"
          ];
          settings = {
            dnsconf = [
              {
                name = "Webhook";
                ipv4 = {
                  enable = true;
                  gettype = "netInterface";
                  netinterface = "eth1";
                  domains = [ "domain.test" ];
                };
                ipv6 = {
                  enable = true;
                  gettype = "netInterface";
                  netinterface = "eth1";
                  domains = [ "domain.test" ];
                };
                dns = {
                  name = "callback";
                  id = "http://ddns-go.test/?myip=#{ip}&zone=#{domain}";
                };
              }
            ];
            user = {
              username = "test";
              # Test genJqSecretReplacementSnippet
              password._secret = pkgs.writeText "password" "$2a$10$/p.mSJUTm.34ufVdqCCUVeNziyWj1el6I./.mNIzynNAc9O0gVirS";
            };
          };
        };
      };
  };

  testScript =
    { ... }:
    ''
      with subtest("Wait for units"):
        machine.wait_for_unit("nginx")
        machine.wait_for_open_port(80)
        machine.wait_for_unit("ddns-go")
        machine.wait_for_open_port(1000)

      with subtest("Test DDNS request"):
        machine.wait_until_succeeds("grep ${IPv4} < /var/log/nginx/ddns.log")
        machine.wait_until_succeeds("grep ${IPv6} < /var/log/nginx/ddns.log")
        machine.wait_until_succeeds("grep domain.test < /var/log/nginx/ddns.log")

      with subtest("Test ddns-go login"):
        assert "200" in machine.succeed("""
          curl -X POST http://ddns-go.test:1000/loginFunc \
            -H "Content-Type: application/json" \
            -d '{"Username": "test", "Password": "password"}'
        """)
        assert "500" in machine.succeed("""
          curl -X POST http://ddns-go.test:1000/loginFunc \
            -H "Content-Type: application/json" \
            -d '{"Username": "test", "Password": "wrong"}'
        """)

      with subtest("Test mutableConfig"):
        machine.succeed("systemctl stop ddns-go")
        machine.succeed("echo 'notallowwanaccess: false' > /etc/ddns-go/config.yaml")
        machine.succeed("systemctl start ddns-go")
        machine.wait_for_unit("ddns-go")
        assert "notallowwanaccess: false" in machine.succeed("cat /etc/ddns-go/config.yaml")
    '';
}
