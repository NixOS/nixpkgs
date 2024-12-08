{
  pkgs,
  makeTest,
}:

let
  inherit (pkgs) lib;

  makeTestFor =
    package:
    makeTest {
      name = "wal2json-${package.name}";
      meta.maintainers = with pkgs.lib.maintainers; [ euank ];

      nodes.machine = {
        services.postgresql = {
          inherit package;
          enable = true;
          enableJIT = lib.hasInfix "-jit-" package.name;
          extensions = with package.pkgs; [ wal2json ];
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
  lib.concatMapAttrs (n: p: { ${n} = makeTestFor p; }) (
    lib.filterAttrs (_: p: !p.pkgs.wal2json.meta.broken) pkgs.postgresqlVersions
  )
  // {
    passthru.override = p: makeTestFor p;
  }
)
