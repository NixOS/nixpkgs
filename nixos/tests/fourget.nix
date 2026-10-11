{ lib, ... }:

{
  name = "fourget";
  meta.maintainers = with lib.maintainers; [ gs-101 ];

  nodes.machine =
    { config, pkgs, ... }:
    let
      cfg = config.services.fourget;
    in
    {
      services.fourget = {
        enable = true;
        settings = {
          SERVER_NAME = "Test 4get";
        };
      };

      services.nginx = {
        enable = true;
        virtualHosts.localhost = {
          root = "${cfg.finalPackage}";
          locations = {
            "/" = {
              tryFiles = "$uri @php";
            };
            "@php" = {
              extraConfig = ''
                try_files $uri.php $uri/index.php =404;
                fastcgi_pass unix:${config.services.phpfpm.pools.fourget.socket};
                fastcgi_index index.php;
                include ${config.services.nginx.package}/conf/fastcgi.conf;
                fastcgi_intercept_errors on;
              '';
            };
            "~* ^(/[a-zA-Z0-9_/-]+)\\.php$" = {
              extraConfig = ''
                return 301 $1;
              '';
            };
          };
        };
      };
    };

  testScript = ''
    machine.wait_for_unit("phpfpm-fourget.service")
    machine.wait_for_unit("nginx.service")
    machine.wait_for_open_port(80)

    # Check home page
    response = machine.succeed("curl -fsSL http://localhost/")
    assert "Test 4get" in response

    # Check about page
    about = machine.succeed("curl -fsSL http://localhost/about")
    assert "Test 4get" in about
  '';
}
