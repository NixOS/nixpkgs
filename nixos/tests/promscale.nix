# mostly copied from ./timescaledb.nix which was copied from ./postgresql.nix
# as it seemed unapproriate to test additional extensions for postgresql there.

{ system ? builtins.currentSystem
, config ? { }
, pkgs ? import ../.. { inherit system config; }
}:

with import ../lib/testing-python.nix { inherit system pkgs; };
with pkgs.lib;

let
  postgresql-versions = import ../../pkgs/servers/sql/postgresql pkgs;
  test-sql = pkgs.writeText "postgresql-test" ''
    CREATE USER promscale SUPERUSER PASSWORD 'promscale';
    CREATE DATABASE promscale OWNER promscale;
  '';

  make-postgresql-test = postgresql-name: postgresql-package: makeTest {
    name = postgresql-name;
    meta = with pkgs.lib.maintainers; {
      maintainers = [ anpin ];
    };

    nodes.machine = { config, pkgs, ... }:
      {
        services.postgresql = {
          enable = true;
          package = postgresql-package;
          extraPlugins = with postgresql-package.pkgs; [
            timescaledb
            promscale_extension
          ];
          settings = { shared_preload_libraries = "timescaledb, promscale"; };
        };
        environment.systemPackages = with pkgs; [ promscale ];
      };

    testScript = ''
      machine.start()
      machine.wait_for_unit("postgresql")
      with subtest("Postgresql with extensions timescaledb and promscale is available just after unit start"):
          print(machine.succeed("sudo -u postgres psql -f ${test-sql}"))
          machine.succeed("sudo -u postgres psql promscale -c 'SHOW shared_preload_libraries;' | grep promscale")
          machine.succeed(
            "promscale --db.name promscale --db.password promscale --db.user promscale --db.ssl-mode allow --startup.install-extensions --startup.only"
          )
      machine.succeed("sudo -u postgres psql promscale -c 'SELECT ps_trace.get_trace_retention_period();' | grep '(1 row)'")
      machine.shutdown()
    '';
  };
  #version 15 is not supported yet
  applicablePostgresqlVersions = filterAttrs (_: value: versionAtLeast value.version "12" && !(versionAtLeast value.version "15")) postgresql-versions;
in
mapAttrs'
  (name: package: {
    inherit name;
    value = make-postgresql-test name package;
  })
  applicablePostgresqlVersions
