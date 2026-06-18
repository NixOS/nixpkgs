{ lib, ... }:

let
  domain = "ddns-go.test";
  testDomain = "domain.test";
in
{
  name = "ddns-go";

  meta.maintainers = with lib.maintainers; [ moraxyc ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.nginx = {
        enable = true;
        commonHttpConfig = ''
          log_format ddns_log '[$time_local] myip=$arg_myip zone=$arg_zone';
        '';
        virtualHosts."${domain}" = {
          extraConfig = ''
            access_log  /var/log/nginx/ddns.log ddns_log;
          '';
          locations = {
            "/callback".return = 200;
            "/".proxyPass = "http://[::1]:1000";
          };
        };
      };

      networking.hosts."::1" = [ domain ];

      # Fake DNS to trick ddns-go online check.
      services.dnsmasq = {
        enable = true;
        settings.address = [ "/#/::1" ];
      };

      systemd.services.ddns-go.after = [ "nginx.service" ];
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
                domains = [ testDomain ];
              };
              ipv6 = {
                enable = true;
                gettype = "netInterface";
                netinterface = "eth1";
                domains = [ testDomain ];
              };
              dns = {
                name = "callback";
                id = "http://${domain}/callback?myip=#{ip}&zone=#{domain}";
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

  extraPythonPackages =
    p: with p; [
      pyyaml
      types-pyyaml
    ];

  testScript =
    { nodes, ... }: # python
    ''
      import json
      import yaml

      with subtest("Wait for units"):
        machine.wait_for_unit("nginx")
        machine.wait_for_open_port(80)
        machine.wait_for_unit("ddns-go")
        machine.wait_for_open_port(1000)
        machine.succeed("curl -sf http://ddns-go.test")

      with subtest("Test DDNS request"):
        machine.wait_until_succeeds("grep ${(lib.head nodes.machine.networking.interfaces.eth1.ipv4.addresses).address} < /var/log/nginx/ddns.log")
        machine.wait_until_succeeds("grep ${(lib.head nodes.machine.networking.interfaces.eth1.ipv6.addresses).address} < /var/log/nginx/ddns.log")
        machine.wait_until_succeeds("grep ${testDomain} < /var/log/nginx/ddns.log")

      with subtest("Test ddns-go login"):
        result = json.loads(machine.succeed("""
          curl -X POST http://${domain}/loginFunc --data-raw '{"Username": "test", "Password": "password"}'
        """))
        t.assertEqual(result["Code"], 200)

        result = json.loads(machine.succeed("""
          curl -X POST http://${domain}/loginFunc --data-raw '{"Username": "test", "Password": "wrong"}'
        """))
        t.assertEqual(result["Code"], 500)

      with subtest("Test mutableConfig"):
        machine.succeed("systemctl stop ddns-go")
        machine.succeed("echo 'notallowwanaccess: false' > /etc/ddns-go/config.yaml")
        machine.succeed("systemctl start ddns-go")
        machine.wait_for_unit("ddns-go")
        config = yaml.safe_load(machine.succeed("cat /etc/ddns-go/config.yaml"))
        t.assertEqual(config["notallowwanaccess"], False, "unexpected value for notallowwanaccess")
    '';
}
