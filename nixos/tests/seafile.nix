{ lib, pkgs, ... }:
let
  adminPassword = "seafile_$[x]\"\\test";
  adminEmail = "admin@example.com";
in
{
  name = "seafile";

  meta = {
    maintainers = with lib.maintainers; [ philocalyst ];
  };

  nodes = {
    server =
      { pkgs, ... }:
      {
        services.seafile = {
          enable = true;
          serverHostname = "server";
          serverProtocol = "http";
          dataDir = "/srv/seafiledata";
          adminEmail = adminEmail;
          # This deterministic test fixture is not a production credential.
          initialAdminPasswordFile = pkgs.writeText "seafile-admin-pass" adminPassword;

          seahubAddress = "unix:/run/seahub/gunicorn.sock";

          seafileSettings.fileserver.host = "127.0.0.1";
        };

        services.nginx = {
          enable = true;
          virtualHosts.server = {
            # Serve Seahub's static assets
            locations."/media/" = {
              alias = "/var/lib/seafile/seahub/media/";
              extraConfig = ''
                expires 1h;
              '';
            };
            locations."/" = {
              proxyPass = "http://unix:/run/seahub/gunicorn.sock";
              extraConfig = ''
                proxy_set_header Host $host;
                proxy_read_timeout 1200s;
                client_max_body_size 0;
              '';
            };
            locations."/seafhttp" = {
              proxyPass = "http://127.0.0.1:8082";
              extraConfig = ''
                rewrite ^/seafhttp(.*)$ $1 break;
                client_max_body_size 0;
                proxy_connect_timeout 36000s;
                proxy_read_timeout 36000s;
                proxy_send_timeout 36000s;
                send_timeout 36000s;
              '';
            };
          };
        };

        networking.firewall.allowedTCPPorts = [ 80 ];
      };

    client1 =
      { ... }:
      {
        environment.systemPackages = [
          pkgs.seafile-shared
          pkgs.curl
        ];
      };

    client2 =
      { ... }:
      {
        environment.systemPackages = [
          pkgs.seafile-shared
          pkgs.curl
        ];
      };
  };

  testScript = ''
    import shlex

    admin_password_arg = shlex.quote(${builtins.toJSON adminPassword})
    start_all()

    with subtest("seaf-server starts"):
        try:
            server.wait_for_unit("seaf-server.service")
        except Exception:
            print(server.succeed("systemctl status --no-pager seaf-server.service || true"))
            print(server.succeed("cat /var/log/seafile/server.log || true"))
            raise
        server.wait_for_file("/run/seafile/seafile.sock")
        server.wait_for_open_port(8082, timeout=90)
        server.succeed(
            "test \"$(stat -c '%U:%G:%a' /srv/seafiledata)\" = seafile:seafile:750"
        )

    with subtest("seahub starts"):
        try:
            server.wait_for_unit("seahub.service")
        except Exception:
            print(server.succeed("systemctl status --no-pager seahub.service || true"))
            print(server.succeed("systemctl show seahub.service -p Environment -p EnvironmentFiles || true"))
            print(server.succeed("cat /var/lib/seafile/conf/seahub_settings.py || true"))
            print(server.succeed("cat /var/log/seafile/seahub.log || true"))
            raise
        server.wait_for_unit("nginx.service")
        server.wait_for_file("/run/seahub/gunicorn.sock")

    with subtest("seahub login page is reachable"):
        client1.succeed("curl -sL http://server | grep -i 'Log In' >&2")

    with subtest("client1 init and connect"):
        client1.wait_for_unit("default.target")
        client1.succeed("seaf-cli init -d . >&2")
        client1.succeed("seaf-cli start >&2")

        client1.succeed(
            "seaf-cli list-remote -s http://server"
            " -u ${adminEmail}"
            f" -p {admin_password_arg} >&2"
        )

        libid = client1.succeed(
            "seaf-cli create -s http://server"
            " -n testlib01"
            " -u ${adminEmail}"
            f" -p {admin_password_arg}"
            ' -t "first test library"'
        ).strip()

        client1.succeed(
            "seaf-cli list-remote -s http://server"
            " -u ${adminEmail}"
            f" -p {admin_password_arg}"
            " | grep testlib01"
        )

        client1.succeed(
            f"seaf-cli download -l {libid}"
            " -s http://server"
            " -u ${adminEmail}"
            f" -p {admin_password_arg}"
            " -d . >&2"
        )
        client1.wait_until_succeeds("seaf-cli status | grep synchronized >&2")
        client1.execute("echo hello > testlib01/first_file")
        client1.wait_until_succeeds("seaf-cli status | grep synchronized >&2")

    with subtest("client2 syncs the file"):
        client2.wait_for_unit("default.target")
        client2.succeed("seaf-cli init -d . >&2")
        client2.succeed("seaf-cli start >&2")

        libid = client2.succeed(
            "seaf-cli list-remote -s http://server"
            " -u ${adminEmail}"
            f" -p {admin_password_arg}"
            " | grep testlib01 | cut -d' ' -f2"
        ).strip()

        client2.succeed(
            f"seaf-cli download -l {libid}"
            " -s http://server"
            " -u ${adminEmail}"
            f" -p {admin_password_arg}"
            " -d . >&2"
        )
        client2.wait_until_succeeds("seaf-cli status | grep synchronized >&2")
        client2.succeed("[ \"$(cat testlib01/first_file)\" = hello ]")
  '';
}
