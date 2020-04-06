import ../make-test-python.nix ({pkgs, ...}: {
  name = "php-fpm-nginx-test";
  meta.maintainers = with pkgs.stdenv.lib.maintainers; [ etu ];

  machine = { config, lib, pkgs, ... }: {
    services.nginx = {
      enable = true;

      virtualHosts."phpfpm" = let
        testdir = pkgs.writeTextDir "web/index.php" "<?php phpinfo();";
      in {
        root = "${testdir}/web";
        locations."~ \.php$".extraConfig = ''
          fastcgi_pass unix:${config.services.phpfpm.pools.foobar.socket};
          fastcgi_index index.php;
          include ${pkgs.nginx}/conf/fastcgi_params;
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
  };
  testScript = { ... }: ''
    machine.wait_for_unit("nginx.service")
    machine.wait_for_unit("phpfpm-foobar.service")

    # Check so we get an evaluated PHP back
    assert "PHP Version ${pkgs.php.version}" in machine.succeed("curl -vvv -s http://127.0.0.1:80/")

    # Check so we have database and some other extensions loaded
    assert "json" in machine.succeed("curl -vvv -s http://127.0.0.1:80/")
    assert "opcache" in machine.succeed("curl -vvv -s http://127.0.0.1:80/")
    assert "pdo_mysql" in machine.succeed("curl -vvv -s http://127.0.0.1:80/")
    assert "pdo_pgsql" in machine.succeed("curl -vvv -s http://127.0.0.1:80/")
    assert "pdo_sqlite" in machine.succeed("curl -vvv -s http://127.0.0.1:80/")
  '';
})
