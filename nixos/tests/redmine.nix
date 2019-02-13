{ system ? builtins.currentSystem,
  config ? {},
  pkgs ? import ../.. { inherit system config; }
}:

with import ../lib/testing.nix { inherit system pkgs; };
with pkgs.lib;

let
  redmineTest = package: makeTest {
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
        services.redmine.package = package;
        services.redmine.database.socket = "/run/mysqld/mysqld.sock";
        services.redmine.plugins = {
          redmine_env_auth = pkgs.fetchurl {
            url = https://github.com/Intera/redmine_env_auth/archive/0.7.zip;
            sha256 = "1xb8lyarc7mpi86yflnlgyllh9hfwb9z304f19dx409gqpia99sc";
          };
        };
        services.redmine.themes = {
          dkuk-redmine_alex_skin = pkgs.fetchurl {
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
  };
in
{
  redmine_3 = redmineTest pkgs.redmine // {
    name = "redmine_3";
    meta.maintainers = [ maintainers.aanderse ];
  };

  redmine_4 = redmineTest pkgs.redmine_4 // {
    name = "redmine_4";
    meta.maintainers = [ maintainers.aanderse ];
  };
}
