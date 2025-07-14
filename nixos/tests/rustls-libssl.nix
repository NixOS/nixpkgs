{ pkgs, lib, ... }:
let
  caCert = builtins.readFile ./common/acme/server/ca.cert.pem;
  certPath = ./common/acme/server/acme.test.cert.pem;
  keyPath = ./common/acme/server/acme.test.key.pem;
  hosts = ''
    192.168.2.101 acme.test
  '';
in
{
  name = "rustls-libssl";
  meta.maintainers = with pkgs.lib.maintainers; [
    stephank
    cpu
  ];

  nodes = {
    server =
      { lib, pkgs, ... }:
      {
        networking = {
          interfaces.eth1 = {
            ipv4.addresses = [
              {
                address = "192.168.2.101";
                prefixLength = 24;
              }
            ];
          };
          extraHosts = hosts;
          firewall.allowedTCPPorts = [ 443 ];
        };

        security.pki.certificates = [ caCert ];

        services.nginx = {
          enable = true;
          package = pkgs.nginxMainline.override {
            openssl = pkgs.rustls-libssl;
            modules = [ ]; # slightly reduces the size of the build
          };

          # Hardcoded sole input accepted by rustls-libssl.
          sslCiphers = "HIGH:!aNULL:!MD5";

          virtualHosts."acme.test" = {
            onlySSL = true;
            sslCertificate = certPath;
            sslCertificateKey = keyPath;
            http2 = true;
            reuseport = true;
            root = lib.mkForce (
              pkgs.runCommandLocal "testdir" { } ''
                mkdir "$out"
                cat > "$out/index.html" <<EOF
                <html><body>Hello World!</body></html>
                EOF
              ''
            );
          };
        };
      };

    client =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.curlHTTP3 ];
        networking = {
          interfaces.eth1 = {
            ipv4.addresses = [
              {
                address = "192.168.2.201";
                prefixLength = 24;
              }
            ];
          };
          extraHosts = hosts;
        };

        security.pki.certificates = [ caCert ];
      };
  };

  testScript = ''
    start_all()
    server.wait_for_open_port(443)
    client.succeed("curl --verbose --http1.1 https://acme.test | grep 'Hello World!'")
    client.succeed("curl --verbose --http2-prior-knowledge https://acme.test | grep 'Hello World!'")
  '';
}
