{
  pkgs,
  makeTest,
  genTests,
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
          extensions = with package.pkgs; [ wal2json ];
          settings = {
            wal_level = "logical";
            max_replication_slots = "10";
            max_wal_senders = "10";
          };
        };
      };

      testScript = ''
        machine.wait_for_unit("postgresql.target")
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
genTests {
  inherit makeTestFor;
  filter = _: p: !p.pkgs.wal2json.meta.broken;
}
