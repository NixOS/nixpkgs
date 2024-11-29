let
  certs = import ./common/acme/server/snakeoil-certs.nix;
  domain = certs.domain;
in
import ./make-test-python.nix ({ pkgs, ... }: {
  name = "alps";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ hmenke ];
  };

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

    client = { nodes, config, ... }: {
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
      environment.systemPackages = [
        (pkgs.writers.writePython3Bin "test-alps-login" { } ''
          from urllib.request import build_opener, HTTPCookieProcessor, Request
          from urllib.parse import urlencode, urljoin
          from http.cookiejar import CookieJar

          baseurl = "http://localhost:${toString config.services.alps.port}"
          username = "alice"
          password = "${nodes.server.config.users.users.alice.password}"
          cookiejar = CookieJar()
          cookieprocessor = HTTPCookieProcessor(cookiejar)
          opener = build_opener(cookieprocessor)

          data = urlencode({"username": username, "password": password}).encode()
          req = Request(urljoin(baseurl, "login"), data=data, method="POST")
          with opener.open(req) as ret:
              # Check that the alps_session cookie is set
              print(cookiejar)
              assert any(cookie.name == "alps_session" for cookie in cookiejar)

          req = Request(baseurl)
          with opener.open(req) as ret:
              # Check that the alps_session cookie is still there...
              print(cookiejar)
              assert any(cookie.name == "alps_session" for cookie in cookiejar)
              # ...and that we have not been redirected back to the login page
              print(ret.url)
              assert ret.url == urljoin(baseurl, "mailbox/INBOX")

          req = Request(urljoin(baseurl, "logout"))
          with opener.open(req) as ret:
              # Check that the alps_session cookie is now gone
              print(cookiejar)
              assert all(cookie.name != "alps_session" for cookie in cookiejar)
        '')
      ];
    };
  };

  testScript = { nodes, ... }: ''
    server.start()
    server.wait_for_unit("postfix.service")
    server.wait_for_unit("dovecot2.service")
    server.wait_for_open_port(465)
    server.wait_for_open_port(993)

    client.start()
    client.wait_for_unit("alps.service")
    client.wait_for_open_port(${toString nodes.client.config.services.alps.port})
    client.succeed("test-alps-login")
  '';
})
