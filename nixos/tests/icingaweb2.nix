import ./make-test.nix ({ pkgs, ... }: {
  name = "icingaweb2";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ das_j ];
  };

  nodes = {
    icingaweb2 = { config, pkgs, ... }: {
      services.icingaweb2 = {
        enable = true;

        modulePackages = with pkgs.icingaweb2Modules; {
          particles = theme-particles;
          spring = theme-spring;
        };

        modules = {
          doc.enable = true;
          migrate.enable =  true;
          setup.enable = true;
          test.enable = true;
          translation.enable = true;
        };

        generalConfig = {
          global = {
            module_path = "${pkgs.icingaweb2}/modules";
          };
        };

        authentications = {
          icingaweb = {
            backend = "external";
          };
        };

        groupBackends = {
          icingaweb = {
            backend = "db";
            resource = "icingaweb_db";
          };
        };

        resources = {
          # Not used, so no DB server needed
          icingaweb_db = {
            type = "db";
            db = "mysql";
            host = "localhost";
            username = "icingaweb2";
            password = "icingaweb2";
            dbname = "icingaweb2";
          };
        };

        roles = {
          Administrators = {
            users = "*";
            permissions = "*";
          };
        };
      };
    };
  };

  testScript = ''
    startAll();
    $icingaweb2->waitForUnit("multi-user.target");
    $icingaweb2->succeed("curl -sSf http://icingaweb2/authentication/login");
  '';
})
