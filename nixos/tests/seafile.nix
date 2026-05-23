{ pkgs, ... }:
let
  adminPassword = "seafile_test_password";
  adminEmail = "admin@example.com";
in
{
  name = "seafile";

  meta = {
    maintainers = with pkgs.lib.maintainers; [ philocalyst ];
  };

  nodes = {
    server =
      { pkgs, ... }:
      {
        services.seafile = {
          enable = true;
          serverHostname = "server";
          serverProtocol = "http";
          adminEmail = adminEmail;
          # Write the password to a tmpfile so it never touches the Nix store
          initialAdminPasswordFile = pkgs.writeText "seafile-admin-pass" adminPassword;

          seahubAddress = "unix:/run/seahub/gunicorn.sock";

          seafileSettings.fileserver.host = "127.0.0.1";
        };

        services.nginx = {
          enable = true;
          virtualHosts.server = {
            locations."/" = {
              proxyPass = "http://unix:/run/seahub/gunicorn.sock";
              extraConfig = ''
                proxy_set_header Host $http_host;
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
    start_all()

    with subtest("seaf-server starts"):
        server.wait_for_unit("seaf-server.service")
        server.wait_for_file("/run/seafile/seafile.sock")

    with subtest("seahub starts"):
        server.wait_for_unit("seahub.service")
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
            " -p ${adminPassword} >&2"
        )

        libid = client1.succeed(
            "seaf-cli create -s http://server"
            " -n testlib01"
            " -u ${adminEmail}"
            " -p ${adminPassword}"
            ' -t "first test library"'
        ).strip()

        client1.succeed(
            "seaf-cli list-remote -s http://server"
            " -u ${adminEmail}"
            " -p ${adminPassword}"
            " | grep testlib01"
        )

        client1.succeed(
            f"seaf-cli download -l {libid}"
            " -s http://server"
            " -u ${adminEmail}"
            " -p ${adminPassword}"
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
            " -p ${adminPassword}"
            " | grep testlib01 | cut -d' ' -f2"
        ).strip()

        client2.succeed(
            f"seaf-cli download -l {libid}"
            " -s http://server"
            " -u ${adminEmail}"
            " -p ${adminPassword}"
            " -d . >&2"
        )
        client2.wait_until_succeeds("seaf-cli status | grep synchronized >&2")
        client2.succeed("[ \"$(cat testlib01/first_file)\" = hello ]")
  '';
}
