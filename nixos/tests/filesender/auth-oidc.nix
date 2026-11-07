{
  lib,
  ...
}:

let
  oidcPort = 5556;
  oidcIssuer = "http://127.0.0.1:${toString oidcPort}/dex";

  siteUrl = "http://localhost";

  user = {
    username = "user";
    password = "password";
  };
in

{
  name = "FileSender with OIDC";
  meta.teams = with lib.teams; [ ngi ];

  nodes.filesender =
    { ... }:
    {
      services.filesender = {
        enable = true;
        localDomain = "localhost";

        settings = {
          site_url = siteUrl;
          force_ssl = false;
          admin = user.username;
          admin_email = "admin@localhost";
          email_reply_to = "noreply@localhost";
        };

        auth = {
          oidc = {
            issuer = oidcIssuer;
            clientID = "filesender";
            clientSecretFile = "/etc/dex/filesender-secret";
            uidAttribute = "email";
          };
          backend = "oidc";
        };
      };

      services.dex = {
        enable = true;

        settings = {
          issuer = oidcIssuer;
          storage.type = "memory";
          web.http = "127.0.0.1:${toString oidcPort}";
          oauth2.skipApprovalScreen = true;

          staticClients = [
            {
              id = "filesender";
              name = "FileSender";
              redirectURIs = [ "${siteUrl}/oidc.php" ];
              secretFile = "/etc/dex/filesender-secret";
            }
          ];

          connectors = [
            {
              type = "mockPassword";
              id = "mock";
              name = "Test";
              config = {
                inherit (user) username password;
              };
            }
          ];
        };
      };

      # WARN: This is world-readable. Don't do this in production !!!
      environment.etc."dex/filesender-secret" = {
        mode = "0444";
        text = "filesender-secret";
      };

      networking.firewall.allowedTCPPorts = [
        80
      ];
    };

  testScript =
    # python
    ''
      import re
      from shlex import quote

      SITE_URL = "${siteUrl}"
      ISSUER = "${oidcIssuer}"
      USERNAME = "${user.username}"
      PASSWORD = "${user.password}"
      COOKIE_JAR = "/tmp/cookies"


      def curl(url, *flags):
          """GET/POST `url` like a browser (persistent cookie jar) and return the body."""
          cmd = ["curl", "-fsS", "-b", COOKIE_JAR, "-c", COOKIE_JAR, *flags, url]
          return filesender.succeed(" ".join(quote(arg) for arg in cmd))


      def redirect_target(url, *flags):
          """Request `url` without following redirects and return where it points to."""
          target = curl(url, "-o", "/dev/null", "-w", "%{redirect_url}", *flags)
          assert target, f"expected {url} to redirect"
          return target


      start_all()

      with subtest("FileSender and Dex are up"):
          filesender.wait_for_unit("phpfpm-filesender.service")
          filesender.wait_for_open_port(80)

          filesender.wait_for_unit("dex.service")
          filesender.wait_for_open_port(${toString oidcPort})

          filesender.wait_until_succeeds(
              f"curl -fsS -o /dev/null {ISSUER}/.well-known/openid-configuration"
          )

      with subtest("FileSender redirects an anonymous visitor to Dex"):
          dex_auth_url = redirect_target(f"{SITE_URL}/oidc.php?action=login&target=%2F")

      with subtest("Dex serves the login form"):
          login_form = curl(dex_auth_url, "-L")
          match = re.search(r'state=([^"]+)">', login_form)
          assert match, "no state found in Dex login form"
          state = match.group(1)

      with subtest("Submitting valid credentials redirects back to FileSender"):
          callback_url = redirect_target(
              f"{ISSUER}/auth/mock/login?back=&state={state}",
              "-d", f"login={USERNAME}",
              "-d", f"password={PASSWORD}",
          )

      with subtest("FileSender exchanges the code and starts a session"):
          page = curl(callback_url, "-L")
          assert "topmenu_user" in page, "login did not produce an authenticated page"

      with subtest("The session gives access to the user page"):
          user_page = curl(f"{SITE_URL}/?s=user", "-L")
          assert USERNAME in user_page, "user page does not mention the logged-in user"
    '';

  interactive.sshBackdoor.enable = true;
}
