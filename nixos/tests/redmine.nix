{ system ? builtins.currentSystem,
  config ? {},
  pkgs ? import ../.. { inherit system config; }
}:

with import ../lib/testing-python.nix { inherit system pkgs; };
with pkgs.lib;

let
  redmineTest = { name, type }: makeTest {
    name = "redmine-${name}";
    nodes.machine = { config, pkgs, ... }: {
      services.redmine = {
        enable = true;
        package = pkgs.redmine;
        database.type = type;
        plugins = {
          redmine_env_auth = pkgs.fetchurl {
            url = "https://github.com/Intera/redmine_env_auth/archive/0.7.zip";
            sha256 = "1xb8lyarc7mpi86yflnlgyllh9hfwb9z304f19dx409gqpia99sc";
          };
        };
        themes = {
          dkuk-redmine_alex_skin = pkgs.fetchurl {
            url = "https://bitbucket.org/dkuk/redmine_alex_skin/get/1842ef675ef3.zip";
            sha256 = "0hrin9lzyi50k4w2bd2b30vrf1i4fi1c0gyas5801wn8i7kpm9yl";
          };
        };
      };
    };

    testScript = ''
      start_all()
      machine.wait_for_unit("redmine.service")
      machine.wait_for_open_port(3000)
      machine.succeed("curl --fail http://localhost:3000/")
    '';
  } // {
    meta.maintainers = [ maintainers.aanderse ];
  };
in {
  sqlite3 = redmineTest { name = "sqlite3"; type = "sqlite3"; };
  mysql = redmineTest { name = "mysql"; type = "mysql2"; };
  pgsql = redmineTest { name = "pgsql"; type = "postgresql"; };
}
