{ lib, ... }:
{
  name = "matomo";

  nodes.machine =
    { config, pkgs, ... }:
    {
      services.matomo = {
        enable = true;
        nginx = {
          forceSSL = false;
          enableACME = false;
        };
      };
      services.mysql = {
        enable = true;
        package = pkgs.mariadb;
      };
      services.nginx.enable = true;
    };

  testScript = ''
    start_all()
    machine.wait_for_unit("mysql.service")
    machine.wait_for_unit("phpfpm-matomo.service")
    machine.wait_for_unit("nginx.service")

    with subtest("matomo.js reachable via HTTP"):
      machine.succeed("curl -sSfk http://machine/matomo.js")

    with subtest("js/piwik.js reachable via HTTP"):
      machine.succeed("curl -sSfk http://machine/js/piwik.js")

    with subtest("matomo.php (API) reachable via HTTP"):
      machine.succeed("curl -sSfk http://machine/matomo.php")

    # without the grep the command does not produce valid utf-8 for some reason
    with subtest("welcome screen loads"):
      machine.succeed(
        "curl -sSfL http://localhost/ | grep '<title>Matomo[^<]*Installation'"
      )

    with subtest("killing the phpfpm process should trigger an automatic restart"):
      machine.succeed("systemctl kill -s KILL phpfpm-matomo")
      machine.sleep(1)
      machine.wait_for_unit("phpfpm-matomo.service")
  '';

  meta.maintainers =
    with lib.maintainers;
    [
      florianjacob
      mmilata
      twey
      boozedog
    ]
    ++ lib.teams.flyingcircus.members;
}
