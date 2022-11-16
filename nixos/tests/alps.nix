let
  certs = import ./common/acme/server/snakeoil-certs.nix;
  domain = certs.domain;
in
import ./make-test-python.nix {
  name = "alps";

  nodes = {
    server = {
      imports = [ ./common/user-account.nix ];
      security.pki.certificateFiles = [
        certs.ca.cert
      ];
      networking.extraHosts = ''
        127.0.0.1 ${domain}
      '';
      networking.firewall.allowedTCPPorts = [ 25 465 993 ];
      services.postfix = {
        enable = true;
        enableSubmission = true;
        enableSubmissions = true;
        tlsTrustedAuthorities = "${certs.ca.cert}";
        sslCert = "${certs.${domain}.cert}";
        sslKey = "${certs.${domain}.key}";
      };
      services.dovecot2 = {
        enable = true;
        enableImap = true;
        sslCACert = "${certs.ca.cert}";
        sslServerCert = "${certs.${domain}.cert}";
        sslServerKey = "${certs.${domain}.key}";
      };
    };

    client = { nodes, ... }: {
      security.pki.certificateFiles = [
        certs.ca.cert
      ];
      networking.extraHosts = ''
        ${nodes.server.config.networking.primaryIPAddress} ${domain}
      '';
      services.alps = {
        enable = true;
        theme = "alps";
        imaps = {
          host = domain;
          port = 993;
        };
        smtps = {
          host = domain;
          port = 465;
        };
      };
    };
  };

  testScript = ''
    server.start()
    server.wait_for_unit("postfix.service")
    server.wait_for_unit("dovecot2.service")
    server.wait_for_open_port(465)
    server.wait_for_open_port(993)

    client.start()
    client.wait_for_unit("alps.service")
    client.wait_until_succeeds("curl -fvvv -s http://127.0.0.1:1323/", timeout=60)
  '';
}
