{ lib, ... }:
{
  name = "pelican-panel";
  meta.maintainers = [ lib.maintainers.oskardotglobal ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.pelican-panel = {
        enable = true;
        domain = "panel.localhost";
        port = 8081;
        secretEnvironmentFile = pkgs.writeText "pelican-test-secrets.env" ''
          APP_KEY="base64:QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUE="
        '';
      };
    };

  testScript = ''
    with subtest("all required services reach active state"):
      machine.start()
      machine.wait_for_unit("mysql.service")
      machine.wait_for_unit("redis-pelican.service")
      machine.wait_for_unit("pelican-setup.service")
      machine.wait_for_unit("phpfpm-pelican.service")
      machine.wait_for_unit("caddy.service")
      machine.wait_for_unit("pelican-queue.service")

    with subtest("web server is reachable on configured port"):
      machine.wait_for_open_port(8081)

    with subtest("login page is served by PHP-FPM"):
      machine.succeed(
        "curl --fail --silent http://localhost:8081/auth/login | grep -q 'Pelican'"
      )
  '';
}
