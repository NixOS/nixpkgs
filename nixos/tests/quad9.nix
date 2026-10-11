{ lib, pkgs, ... }:
let
  # Throwaway CA and a certificate for the DNS-over-TLS hostname of Quad9
  certs = pkgs.runCommand "quad9-test-certs" { nativeBuildInputs = [ pkgs.openssl ]; } ''
    mkdir $out
    openssl req -x509 -newkey ec -pkeyopt ec_paramgen_curve:prime256v1 -nodes -days 36500 \
      -subj '/CN=Test CA' -keyout ca.key -out $out/ca.crt
    openssl req -newkey ec -pkeyopt ec_paramgen_curve:prime256v1 -nodes \
      -subj '/CN=dns.quad9.net' -keyout $out/server.key -out server.csr
    echo 'subjectAltName = DNS:dns.quad9.net' > server.ext
    openssl x509 -req -in server.csr -CA $out/ca.crt -CAkey ca.key -days 36500 \
      -extfile server.ext -out $out/server.crt
  '';

  # Address, default route and DNS server all come from the router
  dhcpClient = {
    networking.useDHCP = false;
    networking.interfaces.eth1 = {
      useDHCP = true;
      ipv4.addresses = lib.mkForce [ ];
    };
  };
in
{
  name = "quad9";
  meta.maintainers = with lib.maintainers; [ yiyu ];

  nodes = {
    # Home router that offers its own DNS server over DHCP.  As the default
    # gateway, it also stands in for Quad9 on its anycast addresses.
    router =
      { config, ... }:
      {
        networking.firewall.enable = false;
        networking.interfaces.eth1.ipv4.addresses = [
          {
            address = "9.9.9.9";
            prefixLength = 32;
          }
          {
            address = "149.112.112.112";
            prefixLength = 32;
          }
        ];

        # Quad9 stand-in, reachable over DNS-over-TLS only
        services.unbound = {
          enable = true;
          enableRootTrustAnchor = false;
          resolveLocalQueries = false;
          settings.server = {
            interface = [
              "9.9.9.9@853"
              "149.112.112.112@853"
            ];
            access-control = [ "192.168.1.0/24 allow" ];
            tls-service-pem = "${certs}/server.crt";
            tls-service-key = "${certs}/server.key";
            local-zone = [ ''"." static'' ];
            # Unsigned, hence under .test, which systemd-resolved does not validate
            local-data = [ ''"example.test. A 192.0.2.9"'' ];
          };
        };

        # Router's own resolver, which answers differently
        services.dnsmasq = {
          enable = true;
          resolveLocalQueries = false;
          settings = {
            listen-address = config.networking.primaryIPAddress;
            bind-dynamic = true;
            dhcp-range = "192.168.1.100,192.168.1.199";
            domain = "lan";
            no-resolv = true;
            address = "/example.test/192.0.2.53";
            host-record = "printer.lan,192.168.1.50";
            log-queries = true;
          };
        };
      };

    client = {
      imports = [ dhcpClient ];
      services.quad9.enable = true;
      security.pki.certificateFiles = [ "${certs}/ca.crt" ];
      # Lets dhcpcd hand the DNS server from DHCP to systemd-resolved
      security.polkit.enable = true;
    };

    plain = {
      imports = [ dhcpClient ];
      services.quad9 = {
        enable = true;
        dnsOverTls = false;
      };
    };
  };

  testScript =
    { nodes, ... }:
    let
      routerAddress = nodes.router.networking.primaryIPAddress;
    in
    ''
      start_all()
      router.wait_for_unit("unbound.service")
      router.wait_for_open_port(853, "9.9.9.9")
      router.wait_for_unit("dnsmasq.service")

      with subtest("Queries go to Quad9 over DNS-over-TLS"):
          client.wait_for_unit("systemd-resolved.service")
          # dhcpcd hands the DNS server of the router to systemd-resolved
          client.wait_until_succeeds("resolvectl dns eth1 | grep -F '${routerAddress}'")
          out = client.succeed("resolvectl query --cache=no example.test")
          t.assertIn("192.0.2.9", out)
          t.assertIn("encrypted transport: yes", out)
          client.succeed("getent hosts example.test | grep -F 192.0.2.9")

      with subtest("Quad9 is preferred over the DNS server from DHCP"):
          # The router lacks DNS-over-TLS, so turn it off for its link
          client.succeed("resolvectl dnsovertls eth1 no")
          client.succeed("resolvectl query --cache=no example.test | grep -F 192.0.2.9")
          # Search domains from DHCP still go to the router
          client.succeed("resolvectl query printer.lan | grep -F 192.168.1.50")
          router.wait_until_succeeds("journalctl -u dnsmasq | grep -F 'query[A] printer.lan'")
          router.fail("journalctl -u dnsmasq | grep -F example.test")

      with subtest("Plain DNS leaves out the DNS server from DHCP"):
          plain.wait_until_succeeds("dhcpcd -U eth1 | grep -F 'domain_name_servers=' | grep -F '${routerAddress}'")
          plain.succeed("grep -Fx 'nameserver 9.9.9.9' /etc/resolv.conf")
          plain.fail("grep -F '${routerAddress}' /etc/resolv.conf")
    '';
}
