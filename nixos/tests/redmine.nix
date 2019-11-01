{ system ? builtins.currentSystem,
  config ? {},
  pkgs ? import ../.. { inherit system config; }
}:

with import ../lib/testing.nix { inherit system pkgs; };
with pkgs.lib;

let
  mysqlTest = package: makeTest {
    machine =
      { config, pkgs, ... }:
      { services.redmine.enable = true;
        services.redmine.package = package;
        services.redmine.database.type = "mysql2";
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

  pgsqlTest = package: makeTest {
    machine =
      { config, pkgs, ... }:
      { services.redmine.enable = true;
        services.redmine.package = package;
        services.redmine.database.type = "postgresql";
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
  v3-mysql = mysqlTest pkgs.redmine // {
    name = "v3-mysql";
    meta.maintainers = [ maintainers.aanderse ];
  };

  v4-mysql = mysqlTest pkgs.redmine_4 // {
    name = "v4-mysql";
    meta.maintainers = [ maintainers.aanderse ];
  };

  v4-pgsql = pgsqlTest pkgs.redmine_4 // {
    name = "v4-pgsql";
    meta.maintainers = [ maintainers.aanderse ];
  };
}
