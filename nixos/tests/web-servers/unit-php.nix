import ../make-test-python.nix ({pkgs, ...}:
 let
    testdir = pkgs.writeTextDir "www/info.php" "<?php phpinfo();";

in {
  name = "unit-php-test";
  meta.maintainers = with pkgs.stdenv.lib.maintainers; [ izorkin ];

  machine = { config, lib, pkgs, ... }: {
    services.unit = {
      enable = true;
      config = ''
        {
          "listeners": {
            "*:9074": {
              "application": "php_74"
            }
          },
          "applications": {
            "php_74": {
              "type": "php 7.4",
              "processes": 1,
              "user": "testuser",
              "group": "testgroup",
              "root": "${testdir}/www",
              "index": "info.php",
              "options": {
                "file": "${pkgs.unit.usedPhp74}/lib/php.ini"
              }
            }
          }
        }
      '';
    };
    users = {
      users.testuser = {
        isNormalUser = false;
        uid = 1074;
        group = "testgroup";
      };
      groups.testgroup = {
        gid= 1074;
      };
    };
  };
  testScript = ''
    machine.wait_for_unit("unit.service")

    # Check so we get an evaluated PHP back
    response = machine.succeed("curl -vvv -s http://127.0.0.1:9074/")
    assert "PHP Version ${pkgs.unit.usedPhp74.version}" in response, "PHP version not detected"

    # Check so we have database and some other extensions loaded
    for ext in ["json", "opcache", "pdo_mysql", "pdo_pgsql", "pdo_sqlite"]:
        assert ext in response, f"Missing {ext} extension"
  '';
})
