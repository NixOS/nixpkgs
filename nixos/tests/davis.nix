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
  node = driver: { ... }: {
    virtualisation.memorySize = 768;
    services.davis = {
      enable = true;
      hostname = "davis.example.com";
      database.driver = driver;
      adminLogin = "admin";
      appSecretFile = "${pkgs.writeText "davisAppSecret" "52882ef142066e09ab99ce816ba72522e789505caba224"}";
      adminPasswordFile = "${pkgs.writeText "davisAdminPass" "nixos"}";
    };
    specialisation.appkeys.configuration.services.davis.config.APP_KEYS_ENABLED = true;
  };
in
{
  name = "davis";
  meta.maintainers = pkgs.davis.meta.maintainers;

  nodes = {
    sqlite = node "sqlite";
    mysql = node "mysql";
    postgres = {
      imports = [ (node "postgresql") ];
      services.davis = {
        config = {
          WEBDAV_ENABLED = true;
          WEBDAV_TMP_DIR = "/var/lib/davis/webdav/tmp";
          WEBDAV_PUBLIC_DIR = "/var/lib/davis/webdav/public";
        };
        mail = {
          dsnFile = "${pkgs.writeText "davisMailDsn" "smtp://username:password@example.com:25"}";
          inviteFromAddress = "dav@example.com";
        };
      };
      systemd.tmpfiles.rules = [
        "d /var/lib/davis/webdav        0700 davis davis - -"
        "d /var/lib/davis/webdav/tmp    0700 davis davis - -"
        "d /var/lib/davis/webdav/public 0700 davis davis - -"
      ];
      specialisation.customWebdav.configuration = { lib, ... }: {
        services.davis.config = {
          WEBDAV_TMP_DIR = lib.mkForce "/srv/webdav/tmp";
          WEBDAV_PUBLIC_DIR = lib.mkForce "/srv/webdav/public";
          WEBDAV_PUBLIC_DIR_WRITABLE = true;
        };
        systemd.tmpfiles.rules = [
          "d /srv/webdav        0700 davis davis - -"
          "d /srv/webdav/tmp    0700 davis davis - -"
          "d /srv/webdav/public 0700 davis davis - -"
        ];
        systemd.services.phpfpm-davis.serviceConfig.ReadWritePaths = [ "/srv/webdav" ];
      };
    };
    standalone = { config, ... }: {
      imports = [ (node "sqlite") ];
      services.davis = {
        nginx = null;
        poolConfig = {
          "listen.owner" = "caddy";
          "listen.group" = "caddy";
        };
      };
      services.caddy = {
        enable = true;
        virtualHosts."http://davis.example.com".extraConfig = ''
          root * ${config.services.davis.package}/public
          php_fastcgi unix/${config.services.phpfpm.pools.davis.socket}
          file_server
        '';
      };
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
          assert code.strip() == expected, (machine.name, path, code, body)
          return body

      def extract(pattern, body):
          match = re.search(pattern, body)
          assert match is not None, (pattern, body)
          return match[1]

      def login(machine):
          body = request(machine, "/login", "-c /tmp/cookies")
          token = html.unescape(extract(r'name="_csrf_token"[^>]*value="([^"]+)"', body))
          request(machine, "/login", "-b /tmp/cookies -c /tmp/cookies -X POST "
                  "--data-urlencode _username=admin --data-urlencode _password=nixos "
                  + "--data-urlencode " + shlex.quote("_csrf_token=" + token), "302")
          request(machine, "/dashboard", "-b /tmp/cookies")

      def create_user(machine, username, admin=False):
          body = request(machine, "/users/new", "-b /tmp/cookies -c /tmp/cookies")
          fields = {
              "user[username]": username,
              "user[displayName]": username,
              "user[email]": username + "@example.com",
              "user[password][first]": "password",
              "user[password][second]": "password",
              "user[_token]": html.unescape(extract(r'name="user\[_token\]"[^>]*value="([^"]+)"', body)),
              "user[save]": "",
          }
          if admin:
              fields["user[isAdmin]"] = "1"
          request(machine, "/users/new", "-b /tmp/cookies -X POST " + " ".join(
              "--data-urlencode " + shlex.quote(k + "=" + v) for k, v in fields.items()
          ), "302")

      def console(machine, arguments):
          command = "ENV_DIR=/var/lib/davis APP_ENV=prod ${pkgs.davis}/bin/console " + arguments
          return machine.succeed("su -s /bin/sh davis -c " + shlex.quote(command))

      event = "\r\n".join([
          "BEGIN:VCALENDAR", "VERSION:2.0", "PRODID:-//Davis NixOS test//EN",
          "BEGIN:VEVENT", "UID:nixos-test", "DTSTAMP:20260101T100000Z",
          "DTSTART:20260110T100000Z", "DTEND:20260110T110000Z",
          "SUMMARY:NixOS event", "END:VEVENT", "END:VCALENDAR", "",
      ])
      card = "\r\n".join([
          "BEGIN:VCARD", "VERSION:3.0", "UID:nixos-contact", "FN:NixOS Contact",
          "N:Contact;NixOS;;;", "EMAIL:contact@example.com", "END:VCARD", "",
      ])
      event_path = "/dav/calendars/alice/default/test.ics"
      card_path = "/dav/addressbooks/alice/default/test.vcf"

      start_all()

      for machine in [sqlite, postgres, mysql]:
          with subtest(machine.name + " startup and login"):
              machine.wait_for_unit("davis-env-setup.service")
              machine.wait_for_unit("davis-db-migrate.service")
              machine.wait_for_unit("phpfpm-davis.service")
              machine.wait_for_unit("nginx.service")
              assert "<title>Davis</title>" in request(machine, "/")
              # A bad WebDAV path also breaks CalDAV and CardDAV requests.
              request(machine, "/dav/", expected="401")
              login(machine)
              create_user(machine, "alice")
              create_user(machine, "bob", admin=True)
              create_user(machine, "carol")
              request(machine, "/dashboard/diagnostics", "-b /tmp/cookies")

          with subtest(machine.name + " CalDAV and CardDAV read/write and authorization"):
              for path, data, content_type in [
                  (event_path, event, "text/calendar"), (card_path, card, "text/vcard")
              ]:
                  request(machine, path, "-u alice:password -X PUT -H "
                          + shlex.quote("Content-Type: " + content_type)
                          + " --data-binary " + shlex.quote(data), "201")
                  request(machine, path, expected="401")
                  request(machine, path, "-u carol:password", "403")
              assert "NixOS event" in request(machine, event_path, "-u alice:password")
              assert "NixOS Contact" in request(machine, card_path, "-u alice:password")
              request(machine, "/dav/calendars/alice/", "-u alice:password -X PROPFIND -H 'Depth: 1'", "207")
              request(machine, "/dav/addressbooks/alice/", "-u alice:password -X PROPFIND -H 'Depth: 1'", "207")
              request(machine, card_path, "-u alice:password -X PUT -H 'Content-Type: text/vcard' --data-binary "
                      + shlex.quote(card.replace("NixOS Contact", "Updated Contact")), "204")

          with subtest(machine.name + " repeat migrations preserve data"):
              machine.succeed("systemctl restart davis-db-migrate.service phpfpm-davis.service")
              machine.wait_for_unit("phpfpm-davis.service")
              assert "NixOS event" in request(machine, event_path, "-u alice:password")
              assert "Updated Contact" in request(machine, card_path, "-u alice:password")

          with subtest(machine.name + " app keys are opt-in and scoped"):
              assert "davis:app-key:create" not in console(machine, "list --raw")
              machine.succeed("/run/booted-system/specialisation/appkeys/bin/switch-to-configuration test")
              machine.wait_for_unit("phpfpm-davis.service")
              output = console(machine, "davis:app-key:create test --user alice --no-ansi")
              app_id = extract(r"App id\s+(app_[a-f0-9]+)", output)
              secret = extract(r"Secret\s+(\S+)", output)
              auth = "-u " + shlex.quote("alice*" + app_id + ":" + secret)
              assert "NixOS event" in request(machine, event_path, auth)
              request(machine, "/dav/calendars/bob/default/", "-u "
                      + shlex.quote("bob*" + app_id + ":" + secret), "401")
              console(machine, "davis:app-key:revoke " + app_id)
              request(machine, event_path, auth, "401")
              request(machine, event_path, "-u alice:password")

      with subtest("WebDAV shared storage and access control"):
          request(postgres, "/dav/public/", "-u bob:password -X PROPFIND -H 'Depth: 0'", "207")
          request(postgres, "/dav/public/test.txt", "-u bob:password -X PUT --data-binary 'WebDAV content'", "201")
          assert request(postgres, "/dav/public/test.txt", "-u alice:password") == "WebDAV content"
          request(postgres, "/dav/public/test.txt", expected="401")
          request(postgres, "/dav/public/forbidden.txt", "-u alice:password -X PUT --data-binary denied", "403")
          request(postgres, "/dav/public/test.txt", "-u alice:password -X DELETE", "403")
          request(postgres, "/dav/public/.DS_Store", "-X PUT --data-binary denied", "401")
          request(postgres, "/dav/public/.DS_Store", "-u bob:password -X PUT --data-binary temporary", "201")
          assert request(postgres, "/dav/public/.DS_Store", "-u bob:password") == "temporary"
          request(postgres, "/dav/public/.DS_Store", "-u bob:password -X DELETE", "204")
          postgres.succeed("test $(stat -c '%U:%G:%a' /var/lib/davis/webdav/public) = davis:davis:700")
          request(postgres, "/dav/public/test.txt", "-u bob:password -X DELETE", "204")
          request(sqlite, "/dav/public/", "-u alice:password -X PROPFIND -H 'Depth: 0'", "404")

      with subtest("custom WebDAV directories and opt-in shared writes"):
          postgres.succeed("/run/booted-system/specialisation/customWebdav/bin/switch-to-configuration test")
          postgres.wait_for_unit("phpfpm-davis.service")
          request(postgres, "/dav/public/custom.txt", "-u alice:password -X PUT --data-binary custom", "201")
          assert request(postgres, "/dav/public/custom.txt", "-u carol:password") == "custom"
          postgres.succeed("test -f /srv/webdav/public/custom.txt")
          request(postgres, "/dav/public/custom.txt", "-u alice:password -X DELETE", "204")

      with subtest("FastCGI without nginx or mail settings"):
          standalone.wait_for_unit("davis-env-setup.service")
          standalone.wait_for_unit("davis-db-migrate.service")
          standalone.wait_for_unit("phpfpm-davis.service")
          env = (
              "SCRIPT_NAME=/index.php",
              "SCRIPT_FILENAME=${config.nodes.standalone.services.davis.package}/public/index.php",
              "REMOTE_ADDR=127.0.0.1",
              "REQUEST_METHOD=GET",
              "REQUEST_URI=/",
          )
          page = standalone.succeed(f"{' '.join(env)} ${pkgs.fcgi}/bin/cgi-fcgi -bind -connect ${config.nodes.standalone.services.phpfpm.pools.davis.socket}")
          assert "<title>Davis</title>" in page, page
          assert "Status: 500" not in page, page

      with subtest("Davis handles CalDAV and CardDAV discovery behind nginx and Caddy"):
          standalone.wait_for_unit("caddy.service")
          for machine in [sqlite, standalone]:
              for protocol in ["caldav", "carddav"]:
                  response = request(machine, "/.well-known/" + protocol, "-D -", "301")
                  # Relative redirects keep the client's scheme and host.
                  assert re.search(r"(?im)^location: /dav/\r?$", response), response
                  request(machine, "/.well-known/" + protocol, "-L", "401")

      with subtest("migration failure prevents PHP-FPM startup"):
          standalone.succeed("systemctl stop phpfpm-davis.service davis-db-migrate.service")
          standalone.succeed("cp -p /var/lib/davis/davis.db /var/lib/davis/davis.db.backup")
          standalone.succeed("printf 'not an SQLite database' > /var/lib/davis/davis.db")
          standalone.fail("systemctl start phpfpm-davis.service")
          standalone.succeed("systemctl is-failed davis-db-migrate.service")
          standalone.fail("systemctl is-active phpfpm-davis.service")
          standalone.succeed("mv /var/lib/davis/davis.db.backup /var/lib/davis/davis.db")
          standalone.succeed("systemctl reset-failed davis-db-migrate.service phpfpm-davis.service")
          standalone.succeed("systemctl start phpfpm-davis.service")
          standalone.wait_for_unit("davis-db-migrate.service")
          standalone.wait_for_unit("phpfpm-davis.service")
    '';
}
