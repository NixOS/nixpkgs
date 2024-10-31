{
  system ? builtins.currentSystem,
  config ? { },
  pkgs ? import ../.. { inherit system config; },
  postgresql ? null,
}:

let
  makeTest = import ./make-test-python.nix;
  # Makes a test for a PostgreSQL package, given by name and looked up from `pkgs`.
  makeTestAttribute = name: {
    inherit name;
    value = makePostgresqlWal2jsonTest pkgs."${name}";
  };

  makePostgresqlWal2jsonTest =
    postgresqlPackage:
    makeTest {
      name = "postgresql-wal2json-${postgresqlPackage.name}";
      meta.maintainers = with pkgs.lib.maintainers; [ euank ];

      nodes.machine = {
        services.postgresql = {
          package = postgresqlPackage;
          enable = true;
          extraPlugins = with postgresqlPackage.pkgs; [ wal2json ];
          settings = {
            wal_level = "logical";
            max_replication_slots = "10";
            max_wal_senders = "10";
          };
        };
      };

      testScript = ''
        machine.wait_for_unit("postgresql")
        machine.succeed(
            "sudo -u postgres psql -qAt -f ${./postgresql/wal2json/example2.sql} postgres > /tmp/example2.out"
        )
        machine.succeed(
            "diff ${./postgresql/wal2json/example2.out} /tmp/example2.out"
        )
        machine.succeed(
            "sudo -u postgres psql -qAt -f ${./postgresql/wal2json/example3.sql} postgres > /tmp/example3.out"
        )
        machine.succeed(
            "diff ${./postgresql/wal2json/example3.out} /tmp/example3.out"
        )
      '';
    };

in
# By default, create one test per postgresql version
if postgresql == null then
  builtins.listToAttrs (
    map makeTestAttribute (builtins.attrNames (import ../../pkgs/servers/sql/postgresql pkgs))
  )
# but if postgresql is set, we're being made as a passthru test for a specific postgres + wal2json version, just run one
else
  makePostgresqlWal2jsonTest postgresql
