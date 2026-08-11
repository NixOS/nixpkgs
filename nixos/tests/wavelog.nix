{ pkgs, ... }:
let
  common = {
    services.wavelog.enable = true;
    services.wavelog.initialUser.passwordFile = "/etc/wavelog-password";
    environment.etc."wavelog-password".text = "hunter2";
    networking.firewall.allowedTCPPorts = [ 80 ];
  };
  httpd = {
    services.wavelog.webserver = "httpd";
    services.httpd.adminAddr = "webmaster@localhost";
  };
  nginx = {
    services.wavelog.webserver = "nginx";
  };
  mariadb = {
    services.mysql.package = pkgs.mariadb;
  };
  mysql = {
    services.mysql.package = pkgs.mysql84;
  };
in
{
  name = "wavelog";

  nodes = {
    nginx_mariadb.imports = [
      common
      nginx
      mariadb
    ];
    nginx_mysql.imports = [
      common
      nginx
      mysql
    ];
    httpd_mariadb.imports = [
      common
      httpd
      mariadb
    ];
    httpd_mysql.imports = [
      common
      httpd
      mysql
    ];

  };

  testScript = ''
    start_all()

    for machine in [nginx_mariadb, nginx_mysql, httpd_mariadb, httpd_mysql]:
        machine.wait_for_unit("wavelog-setup-database.service")
        machine.wait_for_unit("phpfpm-wavelog.service")
        machine.wait_for_open_port(80)
        machine.wait_for_unit("wavelog-migrate.service")
        machine.succeed("curl -sS -L --fail http://localhost/ -o /tmp/login.html")
        machine.succeed("grep -F '<title>Login - Wavelog</title>' /tmp/login.html")

        machine.succeed(
            "test $(curl -sS -o /dev/null -w '%{http_code}' "
            "http://localhost/application/config/database.php) = 403"
        )

        machine.succeed("systemctl start wavelog-cron.service")
  '';
}
