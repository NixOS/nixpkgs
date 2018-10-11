import ./make-test.nix ({ pkgs, lib, ... }:
{
  name = "redmine";
  meta.maintainers = [ lib.maintainers.aanderse ];

  machine =
    { config, pkgs, ... }:
    { services.mysql.enable = true;
      services.mysql.package = pkgs.mariadb;
      services.mysql.ensureDatabases = [ "redmine" ];
      services.mysql.ensureUsers = [
        { name = "redmine";
          ensurePermissions = { "redmine.*" = "ALL PRIVILEGES"; };
        }
      ];

      services.redmine.enable = true;
      services.redmine.database.socket = "/run/mysqld/mysqld.sock";
      services.redmine.plugins = {
        redmine_env_auth = builtins.fetchurl {
          url = https://github.com/Intera/redmine_env_auth/archive/0.6.zip;
          sha256 = "0yyr1yjd8gvvh832wdc8m3xfnhhxzk2pk3gm2psg5w9jdvd6skak";
        };
      };
      services.redmine.themes = {
        dkuk-redmine_alex_skin = builtins.fetchurl {
          url = https://bitbucket.org/dkuk/redmine_alex_skin/get/1842ef675ef3.zip;
          sha256 = "0hrin9lzyi50k4w2bd2b30vrf1i4fi1c0gyas5801wn8i7kpm9yl";
        };
      };
    };

  testScript = ''
    startAll;

    $machine->waitForUnit('redmine.service');
    $machine->waitForOpenPort('3000');
    $machine->succeed("curl --fail http://localhost:3000/");
  '';
})