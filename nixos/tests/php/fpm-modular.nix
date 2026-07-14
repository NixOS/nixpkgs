# Run with:
#   nix-build -A nixosTests.php.fpm-modular
{ lib, php, ... }:
{
  name = "php-${php.version}-fpm-modular-nginx-test";
  meta.maintainers = with lib.maintainers; [
    aanderse
  ];

  containers.machine =
    { config, pkgs, ... }:
    {
      environment.systemPackages = [ php ];

      services.nginx = {
        enable = true;

        virtualHosts."phpfpm" =
          let
            testdir = pkgs.writeTextDir "web/index.php" "<?php phpinfo();";
          in
          {
            root = "${testdir}/web";
            locations."~ \\.php$".extraConfig = ''
              fastcgi_pass unix:${config.system.services.php-fpm.php-fpm.settings.foobar.listen};
              fastcgi_index index.php;
              include ${config.services.nginx.package}/conf/fastcgi_params;
              include ${pkgs.nginx}/conf/fastcgi.conf;
            '';
            locations."/" = {
              tryFiles = "$uri $uri/ index.php";
              index = "index.php index.html index.htm";
            };
          };
      };

      system.services.php-fpm = {
        imports = [ php.services.default ];
        php-fpm = {
          package = php;
          settings = {
            foobar = {
              "user" = "nginx";
              "listen.group" = "nginx";
              "listen.mode" = "0600";
              "listen.owner" = "nginx";
              "pm" = "dynamic";
              "pm.max_children" = 5;
              "pm.max_requests" = 500;
              "pm.max_spare_servers" = 3;
              "pm.min_spare_servers" = 1;
              "pm.start_servers" = 2;
            };
          };
        };
      };
    };
  testScript =
    # python
    ''
      machine.wait_for_unit("nginx.service")
      machine.wait_for_unit("php-fpm.service")

      # Check so we get an evaluated PHP back
      response = machine.wait_until_succeeds("curl -fvvv -s http://127.0.0.1:80/")
      t.assertIn("PHP Version ${php.version}", response, "PHP version not detected")

      # Check so we have database and some other extensions loaded
      for ext in ["json", "opcache", "pdo_mysql", "pdo_pgsql", "pdo_sqlite", "apcu"]:
          assert ext in response, f"Missing {ext} extension"
          machine.succeed(f'test -n "$(php -m | grep -i {ext})"')
    '';
}
