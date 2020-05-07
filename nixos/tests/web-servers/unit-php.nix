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
              "index": "info.php"
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
    assert "PHP Version ${pkgs.php74.version}" in machine.succeed("curl -vvv -s http://127.0.0.1:9074/")
  '';
})
