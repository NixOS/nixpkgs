import ./make-test-python.nix ({ pkgs, ... }:
  let
    client = { config, pkgs, ... }: {
      virtualisation.memorySize = 256;
      environment.systemPackages = [ pkgs.seafile-shared pkgs.curl ];
    };
  in {
    name = "seafile";
    meta = with pkgs.stdenv.lib.maintainers; {
      maintainers = [ kampfschlaefer schmittlauch ];
    };

    nodes = {
      server = { config, pkgs, ... }: {
        virtualisation.memorySize = 512;
        services.seafile = {
          enable = true;
          ccnetSettings.General.SERVICE_URL = "http://server";
          adminEmail = "admin@example.com";
          initialAdminPassword = "seafile_password";
        };
        services.nginx = {
          enable = true;
          virtualHosts."server" = {
            locations."/".proxyPass = "http://unix:/run/seahub/gunicorn.sock";
            locations."/seafhttp" = {
              proxyPass = "http://127.0.0.1:8082";
              extraConfig = ''
                rewrite ^/seafhttp(.*)$ $1 break;
                client_max_body_size 0;
                proxy_connect_timeout  36000s;
                proxy_read_timeout  36000s;
                proxy_send_timeout  36000s;
                send_timeout  36000s;
                proxy_http_version 1.1;
              '';
            };
          };
        };
        networking.firewall = { allowedTCPPorts = [ 80 ]; };
      };
      client1 = client pkgs;
      client2 = client pkgs;
    };

    testScript = ''
      start_all()

      with subtest("start seaf-server"):
          server.wait_for_unit("seaf-server.service")
          server.wait_for_file("/run/seafile/seafile.sock")

      with subtest("start seahub"):
          server.wait_for_unit("seahub.service")
          server.wait_for_unit("nginx.service")
          server.wait_for_file("/run/seahub/gunicorn.sock")

      with subtest("client1 fetch seahub page"):
          client1.succeed("curl -L http://server | grep 'Log In' >&2")

      with subtest("client1 connect"):
          client1.wait_for_unit("default.target")
          client1.succeed("seaf-cli init -d . >&2")
          client1.succeed("seaf-cli start >&2")
          client1.succeed(
              "seaf-cli list-remote -s http://server -u admin\@example.com -p seafile_password >&2"
          )

          libid = client1.succeed(
              'seaf-cli create -s http://server -n test01 -u admin\@example.com -p seafile_password -t "first test library"'
          ).strip()

          client1.succeed(
              "seaf-cli list-remote -s http://server -u admin\@example.com -p seafile_password |grep test01"
          )
          client1.fail(
              "seaf-cli list-remote -s http://server -u admin\@example.com -p seafile_password |grep test02"
          )

          client1.succeed(
              f"seaf-cli download -l {libid} -s http://server -u admin\@example.com -p seafile_password -d . >&2"
          )

          client1.sleep(3)

          client1.succeed("seaf-cli status |grep synchronized >&2")

          client1.succeed("ls -la >&2")
          client1.succeed("ls -la test01 >&2")

          client1.execute("echo bla > test01/first_file")

          client1.sleep(2)

          client1.succeed("seaf-cli status |grep synchronized >&2")

      with subtest("client2 sync"):
          client2.wait_for_unit("default.target")

          client2.succeed("seaf-cli init -d . >&2")
          client2.succeed("seaf-cli start >&2")

          client2.succeed(
              "seaf-cli list-remote -s http://server -u admin\@example.com -p seafile_password >&2"
          )

          libid = client2.succeed(
              "seaf-cli list-remote -s http://server -u admin\@example.com -p seafile_password |grep test01 |cut -d' ' -f 2"
          ).strip()

          client2.succeed(
              f"seaf-cli download -l {libid} -s http://server -u admin\@example.com -p seafile_password -d . >&2"
          )

          client2.sleep(3)

          client2.succeed("seaf-cli status |grep synchronized >&2")

          client2.succeed("ls -la test01 >&2")

          client2.succeed('[ `cat test01/first_file` = "bla" ]')
    '';
  })
