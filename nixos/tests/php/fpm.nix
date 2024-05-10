import ../make-test-python.nix ({ pkgs, lib, php, ... }: {
  name = "php-${php.version}-fpm-nginx-test";
  meta.maintainers = lib.teams.php.members;

  nodes.machine = { config, lib, pkgs, ... }: {
    environment.systemPackages = [ php ];

    services.nginx = {
      enable = true;

      virtualHosts."phpfpm" =
        let
          testdir = pkgs.writeTextDir "web/index.php" ''
            <?php
              phpinfo();
              $envNames = [ 'keyword', 'characters', 'quoted' ];
              foreach ($envNames as $env) {
                echo "<!-- $env=''${_SERVER[$env]} -->";
              }
            ?>
          '';
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
      phpEnv = {
        # check that keywords and special characters are escaped properly
        keyword = "false";
        characters = "^ \${hi} \\";
        quoted = "\"'";
      };
    };
  };
  testScript = { ... }: ''
    machine.wait_for_unit("nginx.service")
    machine.wait_for_unit("phpfpm-foobar.service")

    # Check so we get an evaluated PHP back
    response = machine.succeed("curl -fvvv -s http://127.0.0.1:80/")
    assert "PHP Version ${php.version}" in response, "PHP version not detected"
    assert "keyword=false --" in response, "phpEnv.keyword not detected"
    assert "characters=^ ''${hi} \\ --" in response, "phpEnv.characters not detected"
    assert "quoted=\"' --" in response, "phpEnv.quoted not detected"

    # Check so we have database and some other extensions loaded
    for ext in ["json", "opcache", "pdo_mysql", "pdo_pgsql", "pdo_sqlite", "apcu"]:
        assert ext in response, f"Missing {ext} extension"
        machine.succeed(f'test -n "$(php -m | grep -i {ext})"')
  '';
})
