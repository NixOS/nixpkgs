{
  lib,
  php,
  ...
}:
{
  name = "php-${php.version}-httpd-test";
  meta.maintainers = lib.teams.php.members;

  containers.machine =
    {
      config,
      pkgs,
      ...
    }:
    {
      services.httpd = {
        enable = true;
        adminAddr = "admin@phpfpm";
        virtualHosts."phpfpm" =
          let
            testdir = pkgs.writeTextDir "web/index.php" "<?php phpinfo();";
          in
          {
            documentRoot = "${testdir}/web";
            locations."/" = {
              index = "index.php index.html";
            };
          };
        phpPackage = php;
        enablePHP = true;
      };
    };
  testScript =
    # python
    ''
      machine.wait_for_unit("httpd.service")

      # Check so we get an evaluated PHP back
      response = machine.wait_until_succeeds("curl -fvvv -s http://127.0.0.1:80/")
      t.assertIn("PHP Version ${php.version}", response, "PHP version not detected")

      # Check so we have database and some other extensions loaded
      for ext in ["json", "opcache", "pdo_mysql", "pdo_pgsql", "pdo_sqlite"]:
          assert ext in response, f"Missing {ext} extension"
    '';
}
