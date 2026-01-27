{ lib, php, ... }:
{
  name = "php-${php.version}-fpm-nginx-test";
  meta.maintainers = lib.teams.php.members;

  nodes.machine =
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
              fastcgi_pass unix:${config.services.phpfpm.pools.foobar.socket};
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

      services.phpfpm.pools."foobar" = {
        user = "nginx";
        phpPackage = php;
        settings = {
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

      specialisation.differentUser.configuration = {
        imports = [ ../common/user-account.nix ];

        services.phpfpm.pools."foobar" = {
          user = lib.mkForce "alice";
          group = lib.mkForce "users";
          settings = {
            "listen.owner" = lib.mkForce "alice";
            "listen.group" = lib.mkForce "users";
          };
        };
      };

      specialisation.nonSocketActivated.configuration = {
        imports = [ ../common/user-account.nix ];

        services.phpfpm.pools."foobar" = {
          socketActivation = false;
        };
      };
    };
  testScript =
    { ... }:
    ''
      machine.wait_for_unit("nginx.service")

      # Check so we get an evaluated PHP back
      response = machine.succeed("curl -fvvv -s http://127.0.0.1:80/")
      assert "PHP Version ${php.version}" in response, "PHP version not detected"

      # Check so we have database and some other extensions loaded
      for ext in ["json", "opcache", "pdo_mysql", "pdo_pgsql", "pdo_sqlite", "apcu"]:
          assert ext in response, f"Missing {ext} extension"
          machine.succeed(f'test -n "$(php -m | grep -i {ext})"')

      with subtest("Socket not owned by nginx should refuse to connect"):
          machine.succeed("/run/booted-system/specialisation/differentUser/bin/switch-to-configuration test 2>&1")
          machine.fail("curl -fvvv -s http://127.0.0.1:80/")

      with subtest("Non-socket-activated service should start automatically"):
          machine.systemctl("stop phpfpm-foobar.socket")
          machine.systemctl("stop phpfpm-foobar.service")
          machine.succeed("/run/booted-system/specialisation/nonSocketActivated/bin/switch-to-configuration test 2>&1")

          machine.systemctl("restart multi-user.target")
          machine.wait_for_unit("phpfpm-foobar.service")

          response = machine.succeed("curl -fvvv -s http://127.0.0.1:80/")
          assert "PHP Version ${php.version}" in response, "PHP version not detected"
    '';
}
