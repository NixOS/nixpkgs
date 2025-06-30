{ pkgs, ... }:
{
  name = "ghostunnel";
  nodes = {
    backend =
      { pkgs, ... }:
      {
        services.nginx.enable = true;
        services.nginx.virtualHosts."backend".root = pkgs.runCommand "webroot" { } ''
          mkdir $out
          echo hi >$out/hi.txt
        '';
        networking.firewall.allowedTCPPorts = [ 80 ];
      };
    service =
      { ... }:
      {
        services.ghostunnel.enable = true;
        services.ghostunnel.servers."plain-old" = {
          listen = "0.0.0.0:443";
          cert = "/root/service-cert.pem";
          key = "/root/service-key.pem";
          disableAuthentication = true;
          target = "backend:80";
          unsafeTarget = true;
        };
        services.ghostunnel.servers."client-cert" = {
          listen = "0.0.0.0:1443";
          cert = "/root/service-cert.pem";
          key = "/root/service-key.pem";
          cacert = "/root/ca.pem";
          target = "backend:80";
          allowCN = [ "client" ];
          unsafeTarget = true;
        };
        networking.firewall.allowedTCPPorts = [
          443
          1443
        ];
      };
    client =
      { pkgs, ... }:
      {
        environment.systemPackages = [
          pkgs.curl
        ];
      };
  };

  testScript = ''

    # prepare certificates

    def cmd(command):
      print(f"+{command}")
      r = os.system(command)
      if r != 0:
        raise Exception(f"Command {command} failed with exit code {r}")

    # Create CA
    cmd("${pkgs.openssl}/bin/openssl genrsa -out ca-key.pem 4096")
    cmd("${pkgs.openssl}/bin/openssl req -new -x509 -days 365 -key ca-key.pem -sha256 -subj '/C=NL/ST=Zuid-Holland/L=The Hague/O=Stevige Balken en Planken B.V./OU=OpSec/CN=Certificate Authority' -out ca.pem")

    # Create service
    cmd("${pkgs.openssl}/bin/openssl genrsa -out service-key.pem 4096")
    cmd("${pkgs.openssl}/bin/openssl req -subj '/CN=service' -sha256 -new -key service-key.pem -out service.csr")
    cmd("echo subjectAltName = DNS:service,IP:127.0.0.1 >> extfile.cnf")
    cmd("echo extendedKeyUsage = serverAuth >> extfile.cnf")
    cmd("${pkgs.openssl}/bin/openssl x509 -req -days 365 -sha256 -in service.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out service-cert.pem -extfile extfile.cnf")

    # Create client
    cmd("${pkgs.openssl}/bin/openssl genrsa -out client-key.pem 4096")
    cmd("${pkgs.openssl}/bin/openssl req -subj '/CN=client' -new -key client-key.pem -out client.csr")
    cmd("echo extendedKeyUsage = clientAuth > extfile-client.cnf")
    cmd("${pkgs.openssl}/bin/openssl x509 -req -days 365 -sha256 -in client.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out client-cert.pem -extfile extfile-client.cnf")

    cmd("ls -al")

    start_all()

    # Configuration
    service.copy_from_host("ca.pem", "/root/ca.pem")
    service.copy_from_host("service-cert.pem", "/root/service-cert.pem")
    service.copy_from_host("service-key.pem", "/root/service-key.pem")
    client.copy_from_host("ca.pem", "/root/ca.pem")
    client.copy_from_host("service-cert.pem", "/root/service-cert.pem")
    client.copy_from_host("client-cert.pem", "/root/client-cert.pem")
    client.copy_from_host("client-key.pem", "/root/client-key.pem")

    backend.wait_for_unit("nginx.service")
    service.wait_for_unit("multi-user.target")
    service.wait_for_unit("multi-user.target")
    client.wait_for_unit("multi-user.target")

    # Check assumptions before the real test
    client.succeed("bash -c 'diff <(curl -v --no-progress-meter http://backend/hi.txt) <(echo hi)'")

    # Plain old simple TLS can connect, ignoring cert
    client.succeed("bash -c 'diff <(curl -v --no-progress-meter --insecure https://service/hi.txt) <(echo hi)'")

    # Plain old simple TLS provides correct signature with its cert
    client.succeed("bash -c 'diff <(curl -v --no-progress-meter --cacert /root/ca.pem https://service/hi.txt) <(echo hi)'")

    # Client can authenticate with certificate
    client.succeed("bash -c 'diff <(curl -v --no-progress-meter --cert /root/client-cert.pem --key /root/client-key.pem --cacert /root/ca.pem https://service:1443/hi.txt) <(echo hi)'")

    # Client must authenticate with certificate
    client.fail("bash -c 'diff <(curl -v --no-progress-meter --cacert /root/ca.pem https://service:1443/hi.txt) <(echo hi)'")
  '';

  meta.maintainers = with pkgs.lib.maintainers; [
    roberth
  ];
}
