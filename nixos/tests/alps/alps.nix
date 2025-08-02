{ pkgs, ... }:
{
  name = "alps";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ hmenke ];
  };

  configurations = {
    server = ./alps-server.nix;
    client = ./alps-client.nix;
  };

  nodes = {
    server = {
      # empty because node needs to be defined but has
      # no test components
    };

    client =
      { nodes, config, ... }:
      {
        environment.systemPackages = [
          (pkgs.writers.writePython3Bin "test-alps-login" { } ''
            from urllib.request import build_opener, HTTPCookieProcessor, Request
            from urllib.parse import urlencode, urljoin
            from http.cookiejar import CookieJar

            baseurl = "http://localhost:${toString config.services.alps.port}"
            username = "alice"
            password = "${nodes.server.users.users.alice.password}"
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

  testScript =
    { nodes, ... }:
    ''
      server.start()
      server.wait_for_unit("postfix.service")
      server.wait_for_unit("dovecot2.service")
      server.wait_for_open_port(465)
      server.wait_for_open_port(993)

      client.start()
      client.wait_for_unit("alps.service")
      client.wait_for_open_port(${toString nodes.client.services.alps.port})
      client.succeed("test-alps-login")
    '';
}
