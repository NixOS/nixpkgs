import ../make-test-python.nix ({pkgs, ...}:
let
  testdir = pkgs.writeTextDir "www/info.php" "<?php phpinfo();";

in {
  name = "unit-php-test";
  meta.maintainers = with pkgs.lib.maintainers; [ izorkin ];

  nodes.machine = { config, lib, pkgs, ... }: {
    services.unit = {
      enable = true;
      config = pkgs.lib.strings.toJSON {
        listeners."*:9080".application = "php_80";
        applications.php_80 = {
          type = "php 8.0";
          processes = 1;
          user = "testuser";
          group = "testgroup";
          root = "${testdir}/www";
          index = "info.php";
          options.file = "${pkgs.unit.usedPhp80}/lib/php.ini";
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
    machine.wait_for_unit("unit.service")

    # Check so we get an evaluated PHP back
    response = machine.succeed("curl -f -vvv -s http://127.0.0.1:9080/")
    assert "PHP Version ${pkgs.unit.usedPhp80.version}" in response, "PHP version not detected"

    # Check so we have database and some other extensions loaded
    for ext in ["json", "opcache", "pdo_mysql", "pdo_pgsql", "pdo_sqlite"]:
        assert ext in response, f"Missing {ext} extension"
  '';
})
