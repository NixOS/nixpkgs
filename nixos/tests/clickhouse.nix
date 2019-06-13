import ./make-test.nix ({ pkgs, ... }: {
  name = "clickhouse";
  meta.maintainers = with pkgs.stdenv.lib.maintainers; [ ma27 ];

  machine = {
    services.clickhouse.enable = true;
  };

  testScript =
    let
      # work around quote/substitution complexity by Nix, Perl, bash and SQL.
      tableDDL = pkgs.writeText "ddl.sql" "CREATE TABLE `demo` (`value` FixedString(10)) engine = MergeTree PARTITION BY value ORDER BY tuple();";
      insertQuery = pkgs.writeText "insert.sql" "INSERT INTO `demo` (`value`) VALUES ('foo');";
      selectQuery = pkgs.writeText "select.sql" "SELECT * from `demo`";
    in
      ''
        $machine->start();
        $machine->waitForUnit("clickhouse.service");
        $machine->waitForOpenPort(9000);

        $machine->succeed("cat ${tableDDL} | clickhouse-client");
        $machine->succeed("cat ${insertQuery} | clickhouse-client");
        $machine->succeed("cat ${selectQuery} | clickhouse-client | grep foo");
      '';
})
