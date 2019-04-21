{ system ? builtins.currentSystem,
  config ? {},
  pkgs ? import ../.. { inherit system config; }
}:

with import ../lib/testing.nix { inherit system pkgs; };
with pkgs.lib;

makeTest {
  machine =
    { config, pkgs, ... }:
    {
      # services.mysql.enable = true;
      # services.mysql.package = pkgs.mariadb;
      # services.mysql.ensureDatabases = [ "redmine" ];
      # services.mysql.ensureUsers = [
      #   { name = "redmine";
      #     ensurePermissions = { "redmine.*" = "ALL PRIVILEGES"; };
      #   }
      # ];

      services.discourse.enable = true;
      # services.redmine.package = package;
      # services.redmine.database.socket = "/run/mysqld/mysqld.sock";
      # services.redmine.plugins = {
      #   redmine_env_auth = pkgs.fetchurl {
      #     url = https://github.com/Intera/redmine_env_auth/archive/0.7.zip;
      #     sha256 = "1xb8lyarc7mpi86yflnlgyllh9hfwb9z304f19dx409gqpia99sc";
      #   };
      # };

    };

  testScript = ''
    startAll;

    $machine->waitForUnit('discourse.service');
    $machine->waitForOpenPort('3000');
    $machine->succeed("curl --fail http://localhost:3000/");
  '';
}
