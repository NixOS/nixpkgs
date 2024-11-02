{ pkgs
, makeTest
}:

let
  inherit (pkgs) lib;

  makePostgresqlWal2jsonTest =
    postgresqlPackage:
    makeTest {
      name = "wal2json-${postgresqlPackage.name}";
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
            "sudo -u postgres psql -qAt -f ${./wal2json/example2.sql} postgres > /tmp/example2.out"
        )
        machine.succeed(
            "diff ${./wal2json/example2.out} /tmp/example2.out"
        )
        machine.succeed(
            "sudo -u postgres psql -qAt -f ${./wal2json/example3.sql} postgres > /tmp/example3.out"
        )
        machine.succeed(
            "diff ${./wal2json/example3.out} /tmp/example3.out"
        )
      '';
    };

in
lib.recurseIntoAttrs (
  lib.concatMapAttrs (n: p: { ${n} = makePostgresqlWal2jsonTest p; }) pkgs.postgresqlVersions
  // {
    passthru.override = p: makePostgresqlWal2jsonTest p;
  }
)
