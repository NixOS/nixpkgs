{ pkgs, ... }:
let
  testdir = pkgs.writeTextDir "www/info.php" "<?php phpinfo();";

in
{
  name = "unit-php-test";
  meta.maintainers = with pkgs.lib.maintainers; [ izorkin ];

  nodes.machine =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      services.unit = {
        enable = true;
        config = pkgs.lib.strings.toJSON {
          listeners."*:9081".application = "php_82";
          applications.php_82 = {
            type = "php 8.2";
            processes = 1;
            user = "testuser";
            group = "testgroup";
            root = "${testdir}/www";
            index = "info.php";
            options.file = "${pkgs.unit.usedPhp82}/lib/php.ini";
          };
        };
      };
      users = {
        users.testuser = {
          isSystemUser = true;
          uid = 1080;
          group = "testgroup";
        };
        groups.testgroup = {
          gid = 1080;
        };
      };
    };
  testScript = ''
    machine.start()

    machine.wait_for_unit("unit.service")
    machine.wait_for_open_port(9081)

    # Check so we get an evaluated PHP back
    response = machine.succeed("curl -f -vvv -s http://127.0.0.1:9081/")
    assert "PHP Version ${pkgs.unit.usedPhp82.version}" in response, "PHP version not detected"

    # Check so we have database and some other extensions loaded
    for ext in ["json", "opcache", "pdo_mysql", "pdo_pgsql", "pdo_sqlite"]:
        assert ext in response, f"Missing {ext} extension"

    machine.shutdown()
  '';
}
