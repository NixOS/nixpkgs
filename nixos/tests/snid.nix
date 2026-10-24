{ lib, pkgs, ... }:
let
  domain = "backend.example.com";
  port = 443;
  certs =
    pkgs.runCommand "snid-test-certs"
      {
        nativeBuildInputs = [ pkgs.openssl ];
      }
      ''
        mkdir -p $out
        openssl req -x509 \
          -subj '/CN=${domain}/' \
          -addext 'subjectAltName = DNS:${domain}' \
          -keyout "$out/key.pem" \
          -out "$out/cert.pem" -noenc
      '';
in
{
  _class = "nixosTest";
  name = "snid";

  nodes = {
    # Serves a simple HTTPS page that we expect to receive via snid
    backend =
      { ... }:
      {
        services.nginx = {
          enable = true;
          virtualHosts.${domain} = {
            onlySSL = true;
            sslCertificate = "${certs}/cert.pem";
            sslCertificateKey = "${certs}/key.pem";
            root = pkgs.writeTextDir "index.html" "snid test OK";
          };
        };
        networking.firewall.allowedTCPPorts = [ port ];
      };

    # Runs snid, proxying to the backend.
    snid =
      { nodes, pkgs, ... }:
      let
        backendIp = nodes.backend.networking.primaryIPv6Address;
      in
      {
        system.services.snid = {
          imports = [ pkgs.snid.services.default ];
          snid = {
            listen = [ "tcp:${toString port}" ];
            mode = "tcp";
            backendCidrs = [ "${backendIp}/128" ];
          };
        };

        networking.hosts.${backendIp} = [ domain ];
        networking.firewall.allowedTCPPorts = [ port ];
      };

    # Makes HTTPS requests to snid.
    client =
      { nodes, pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.curl ];
        networking.hosts.${nodes.snid.networking.primaryIPAddress} = [ domain ];
      };
  };

  testScript = ''
    start_all()

    backend.wait_for_unit("nginx.service")
    backend.wait_for_open_port(${toString port})

    snid.wait_for_unit("snid.service")
    snid.wait_for_open_port(${toString port})

    with subtest("snid proxies HTTPS connection based on SNI"):
        result = client.succeed("curl -k -sf https://${domain}")
        assert "snid test OK" in result, f"Unexpected response: {result!r}"
  '';

  meta.maintainers = with lib.maintainers; [ tomfitzhenry ];
}
