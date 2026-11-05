{
  pkgs,
  config,
  lib,
  ...
}:
let
  warns =
    settings:
    lib.any (lib.hasInfix "services.davis: WebDAV") (
      (import ../lib/eval-config.nix {
        inherit pkgs;
        system = pkgs.stdenv.hostPlatform.system;
        modules = [
          {
            system.stateVersion = "26.11";
            services.davis = {
              enable = true;
              hostname = "davis.example.com";
              appSecretFile = "/test-secret";
              adminPasswordFile = "/test-password";
              config = settings;
            };
          }
        ];
      }).config.warnings
    );
in
{
  name = "davis";

  meta.maintainers = pkgs.davis.meta.maintainers;

  nodes.machine1 =
    { ... }:
    {
      virtualisation = {
        memorySize = 512;
      };

      services.davis = {
        enable = true;
        hostname = "davis.example.com";
        config = {
          WEBDAV_ENABLED = true;
          WEBDAV_TMP_DIR = "/var/lib/davis/webdav/tmp";
          WEBDAV_PUBLIC_DIR = "/var/lib/davis/webdav/public";
        };
        database = {
          driver = "postgresql";
        };
        mail = {
          dsnFile = "${pkgs.writeText "davisMailDns" "smtp://username:password@example.com:25"}";
          inviteFromAddress = "dav@example.com";
        };
        adminLogin = "admin";
        appSecretFile = "${pkgs.writeText "davisAppSecret" "52882ef142066e09ab99ce816ba72522e789505caba224"}";
        adminPasswordFile = "${pkgs.writeText "davisAdminPass" "nixos"}";
      };
      systemd.tmpfiles.rules = [
        "d /var/lib/davis/webdav        0700 davis davis - -"
        "d /var/lib/davis/webdav/tmp    0700 davis davis - -"
        "d /var/lib/davis/webdav/public 0700 davis davis - -"
      ];
    };
  nodes.machine2 =
    { nodes, config, ... }:
    {
      virtualisation = {
        memorySize = 512;
      };
      environment.systemPackages = [ pkgs.fcgi ];

      # no nginx, and no mail dsn
      services.davis = {
        enable = true;
        hostname = "davis.example.com";
        database = {
          driver = "postgresql";
        };
        adminLogin = "admin";
        appSecretFile = "${pkgs.writeText "davisAppSecret" "52882ef142066e09ab99ce816ba72522e789505caba224"}";
        adminPasswordFile = "${pkgs.writeText "davisAdminPass" "nixos"}";
        nginx = null;
      };
    };

  testScript =
    assert lib.all
      (settings: lib.assertMsg (warns settings) "Missing Davis warning for ${builtins.toJSON settings}")
      [
        { WEBDAV_ENABLED = true; }
        { WEBDAV_ENABLED = "true"; }
        {
          WEBDAV_ENABLED = true;
          WEBDAV_TMP_DIR = "/srv/webdav/tmp";
        }
        {
          WEBDAV_ENABLED = true;
          WEBDAV_PUBLIC_DIR = "/srv/webdav/public";
        }
        {
          WEBDAV_ENABLED = true;
          WEBDAV_TMP_DIR = null;
          WEBDAV_PUBLIC_DIR = "";
        }
      ];
    assert lib.all
      (
        settings: lib.assertMsg (!warns settings) "Unexpected Davis warning for ${builtins.toJSON settings}"
      )
      [
        { }
        { WEBDAV_ENABLED = false; }
        { WEBDAV_ENABLED = "false"; }
        {
          WEBDAV_ENABLED = true;
          WEBDAV_TMP_DIR = "/srv/webdav/tmp";
          WEBDAV_PUBLIC_DIR = "/srv/webdav/public";
        }
      ];
    ''
      import html
      import re
      import shlex

      def request(machine, path, options="", expected="200"):
          result = machine.succeed(
              "curl -sS --resolve davis.example.com:80:127.0.0.1 "
              + options + " -w '\\n%{http_code}' " + shlex.quote("http://davis.example.com" + path)
          )
          body, code = result.rsplit("\n", 1)
          assert code.strip() == expected, (path, code, body)
          return body

      def create_user(machine, username, admin=False):
          body = request(machine, "/users/new", "-b /tmp/cookies -c /tmp/cookies")
          token = re.search(r'name="user\[_token\]"[^>]*value="([^"]+)"', body)
          assert token is not None, body
          fields = {
              "user[username]": username,
              "user[displayName]": username,
              "user[email]": username + "@example.com",
              "user[password][first]": "password",
              "user[password][second]": "password",
              "user[_token]": html.unescape(token[1]),
              "user[save]": "",
          }
          if admin:
              fields["user[isAdmin]"] = "1"
          request(machine, "/users/new", "-b /tmp/cookies -X POST " + " ".join(
              "--data-urlencode " + shlex.quote(k + "=" + v) for k, v in fields.items()
          ), "302")

      start_all()

      machine1.wait_for_unit("postgresql.target")
      machine1.wait_for_unit("davis-env-setup.service")
      machine1.wait_for_unit("davis-db-migrate.service")
      machine1.wait_for_unit("phpfpm-davis.service")

      with subtest("enabling WebDAV does not break DAV requests"):
          status = machine1.succeed(
              "curl -sS -o /dev/null -w '%{http_code}' --resolve davis.example.com:80:127.0.0.1 http://davis.example.com/dav/"
          )
          assert status == "401", status

      with subtest("welcome screen loads"):
          machine1.succeed(
              "curl -sSfL --resolve davis.example.com:80:127.0.0.1 http://davis.example.com/ | grep '<title>Davis</title>'"
          )

      with subtest("login works"):
          csrf_token = machine1.succeed(
              "curl -c /tmp/cookies -sSfL --resolve davis.example.com:80:127.0.0.1 http://davis.example.com/login | grep '_csrf_token' | sed -E 's,.*value=\"(.*)\".*,\\1,g'"
          )
          r = machine1.succeed(
              f"curl -b /tmp/cookies -c /tmp/cookies --resolve davis.example.com:80:127.0.0.1 http://davis.example.com/login -X POST -F _username=admin -F _password=nixos -F _csrf_token={csrf_token.strip()} -D headers"
          )
          print(r)
          machine1.succeed(
            "[[ $(grep -i 'location: ' headers | cut -d: -f2- | xargs echo) == /dashboard* ]]"
          )
      with subtest("WebDAV shared storage and access control"):
          create_user(machine1, "alice", admin=True)
          create_user(machine1, "bob")
          request(machine1, "/dav/public/", "-u alice:password -X PROPFIND -H 'Depth: 0'", "207")
          request(machine1, "/dav/public/test.txt", "-u alice:password -X PUT --data-binary 'WebDAV content'", "201")
          assert request(machine1, "/dav/public/test.txt", "-u bob:password") == "WebDAV content"
          request(machine1, "/dav/public/test.txt", expected="401")
          request(machine1, "/dav/public/forbidden.txt", "-u bob:password -X PUT --data-binary denied", "403")
          request(machine1, "/dav/public/test.txt", "-u bob:password -X DELETE", "403")
          request(machine1, "/dav/public/.DS_Store", "-X PUT --data-binary denied", "401")
          request(machine1, "/dav/public/.DS_Store", "-u alice:password -X PUT --data-binary temporary", "201")
          assert request(machine1, "/dav/public/.DS_Store", "-u alice:password") == "temporary"
          request(machine1, "/dav/public/.DS_Store", "-u alice:password -X DELETE", "204")
          # Enabling WebDAV must leave the other DAV collections usable.
          request(machine1, "/dav/calendars/bob/", "-u bob:password -X PROPFIND -H 'Depth: 1'", "207")
          request(machine1, "/dav/addressbooks/bob/", "-u bob:password -X PROPFIND -H 'Depth: 1'", "207")
          machine1.succeed("test $(stat -c '%U:%G:%a' /var/lib/davis/webdav/public) = davis:davis:700")
          request(machine1, "/dav/public/test.txt", "-u alice:password -X DELETE", "204")

      machine2.wait_for_unit("davis-env-setup.service")
      machine2.wait_for_unit("davis-db-migrate.service")
      machine2.wait_for_unit("phpfpm-davis.service")
      r = machine2.succeed(
          "find /var/lib/davis/var/log"
      )
      print(r)
      env = (
        "SCRIPT_NAME=/index.php",
        "SCRIPT_FILENAME=${config.nodes.machine2.services.davis.package}/public/index.php",
        "REMOTE_ADDR=127.0.0.1",
        "REQUEST_METHOD=GET",
      );
      page = machine2.succeed(f"{' '.join(env)} ${pkgs.fcgi}/bin/cgi-fcgi -bind -connect ${config.nodes.machine2.services.phpfpm.pools.davis.socket}")
    '';
}
