{ lib, ... }:
let
  hosts = "192.168.2.101 acme.test";
in
{
  name = "nginx-forcessl";
  meta.maintainers = with lib.maintainers; [ kiara ];

  nodes.server =
    { pkgs, ... }:
    {
      networking = {
        interfaces.eth1.ipv4.addresses = [
          {
            address = "192.168.2.101";
            prefixLength = 24;
          }
        ];
        extraHosts = hosts;
        firewall.allowedTCPPorts = [
          80
          443
        ];
      };

      security.pki.certificates = [
        (builtins.readFile ./common/acme/server/ca.cert.pem)
      ];

      services.nginx = {
        enable = true;
        virtualHosts."acme.test" = {
          forceSSL = true;
          sslCertificate = ./common/acme/server/acme.test.cert.pem;
          sslCertificateKey = ./common/acme/server/acme.test.key.pem;
          root = pkgs.runCommandLocal "testdir" { } ''
            mkdir "$out"
            echo hello > "$out/index.html"
          '';
        };
      };
    };

  testScript = ''
    server.wait_for_unit("nginx")
    server.wait_for_open_port(80)

    # The forceSSL redirect should not set a Content-Type header
    server.succeed("curl -si http://acme.test/ | grep -i '^HTTP/[0-9.]\\+ 301'")
    server.fail("curl -si http://acme.test/ | grep -i '^Content-Type:'")
  '';
}
