{ system ? builtins.currentSystem,
  config ? {},
  pkgs ? import ../.. { inherit system config; }
}:

with import ../lib/testing-python.nix { inherit system pkgs; };

let
  hosts = ''
    192.168.2.101 acme.test
  '';

in

builtins.listToAttrs (
  builtins.map
    (nginxPackage:
      {
        name = pkgs.lib.getName nginxPackage;
        value = makeTest {
          name = "nginx-http3-${pkgs.lib.getName nginxPackage}";
          meta.maintainers = with pkgs.lib.maintainers; [ izorkin ];

          nodes = {
            server = { lib, pkgs, ... }: {
              networking = {
                interfaces.eth1 = {
                  ipv4.addresses = [
                    { address = "192.168.2.101"; prefixLength = 24; }
                  ];
                };
                extraHosts = hosts;
                firewall.allowedTCPPorts = [ 443 ];
                firewall.allowedUDPPorts = [ 443 ];
              };

              security.pki.certificates = [
                (builtins.readFile ./common/acme/server/ca.cert.pem)
              ];

              services.nginx = {
                enable = true;
                package = nginxPackage;

                virtualHosts."acme.test" = {
                  onlySSL = true;
                  sslCertificate = ./common/acme/server/acme.test.cert.pem;
                  sslCertificateKey = ./common/acme/server/acme.test.key.pem;
                  http2 = true;
                  http3 = true;
                  http3_hq = false;
                  quic = true;
                  reuseport = true;
                  root = lib.mkForce (pkgs.runCommandLocal "testdir" {} ''
                    mkdir "$out"
                    cat > "$out/index.html" <<EOF
                    <html><body>Hello World!</body></html>
                    EOF
                    cat > "$out/example.txt" <<EOF
                    Check http3 protocol.
                    EOF
                  '');
                };
              };
            };

            client = { pkgs, ... }: {
              environment.systemPackages = [ pkgs.curlHTTP3 ];
              networking = {
                interfaces.eth1 = {
                  ipv4.addresses = [
                    { address = "192.168.2.201"; prefixLength = 24; }
                  ];
                };
                extraHosts = hosts;
              };

              security.pki.certificates = [
                (builtins.readFile ./common/acme/server/ca.cert.pem)
              ];
            };
          };

          testScript = ''
            start_all()

            server.wait_for_unit("nginx")
            server.wait_for_open_port(443)

            # Check http connections
            client.succeed("curl --verbose --http3-only https://acme.test | grep 'Hello World!'")

            # Check downloadings
            client.succeed("curl --verbose --http3-only https://acme.test/example.txt --output /tmp/example.txt")
            client.succeed("cat /tmp/example.txt | grep 'Check http3 protocol.'")

            # Check header reading
            client.succeed("curl --verbose --http3-only --head https://acme.test | grep 'content-type'")
            client.succeed("curl --verbose --http3-only --head https://acme.test | grep 'HTTP/3 200'")
            client.succeed("curl --verbose --http3-only --head https://acme.test/error | grep 'HTTP/3 404'")

            # Check change User-Agent
            client.succeed("curl --verbose --http3-only --user-agent 'Curl test 3.0' https://acme.test")
            server.succeed("cat /var/log/nginx/access.log | grep 'Curl test 3.0'")

            server.shutdown()
            client.shutdown()
          '';
        };
      }
    )
    [ pkgs.angieQuic pkgs.nginxQuic ]
)
