import ../make-test-python.nix ({pkgs, ...}: {
  name = "php-httpd-test";
  meta.maintainers = with pkgs.stdenv.lib.maintainers; [ etu ];

  machine = { config, lib, pkgs, ... }: {
    services.httpd = {
      enable = true;
      adminAddr = "admin@phpfpm";
      virtualHosts."phpfpm" = let
        testdir = pkgs.writeTextDir "web/index.php" "<?php phpinfo();";
      in {
        documentRoot = "${testdir}/web";
        locations."/" = {
          index = "index.php index.html";
        };
      };
      enablePHP = true;
    };
  };
  testScript = { ... }: ''
    machine.wait_for_unit("httpd.service")

    # Check so we get an evaluated PHP back
    response = machine.succeed("curl -vvv -s http://127.0.0.1:80/")
    assert "PHP Version ${pkgs.php.version}" in response, "PHP version not detected"

    # Check so we have database and some other extensions loaded
    for ext in ["json", "opcache", "pdo_mysql", "pdo_pgsql", "pdo_sqlite"]:
        assert ext in response, f"Missing {ext} extension"
  '';
})
