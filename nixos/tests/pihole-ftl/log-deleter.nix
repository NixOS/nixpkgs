# Check that the query log deleter removes old entries from the FTL database
{
  lib,
  pkgs,
  ...
}:

{
  name = "pihole-ftl-log-deleter";
  meta.maintainers = with lib.maintainers; [ averyvigolo ];

  nodes.machine = {
    services.pihole-ftl = {
      enable = true;
      queryLogDeleter = {
        enable = true;
        age = 90;
      };
    };
  };

  testScript =
    { nodes, ... }:
    let
      cfg = nodes.machine.services.pihole-ftl;
      db = cfg.settings.files.database;
      sql = "runuser -u ${cfg.user} -- ${lib.getExe cfg.package} sqlite3 ${db}";

      insertRows = pkgs.writeText "insert-rows.sql" ''
        INSERT INTO query_storage (timestamp, type, status, domain, client)
          VALUES (CAST(strftime('%s', 'now', '-100 days') AS INT), 1, 2, 'old.example', '127.0.0.1');
        INSERT INTO query_storage (timestamp, type, status, domain, client)
          VALUES (CAST(strftime('%s', 'now', '-1 day') AS INT), 1, 2, 'recent.example', '127.0.0.1');
      '';
      countRows = pkgs.writeText "count-rows.sql" ''
        SELECT count(*) FROM query_storage WHERE domain IN ('old.example', 'recent.example');
      '';
      remainingRows = pkgs.writeText "remaining-rows.sql" ''
        SELECT domain FROM query_storage WHERE domain IN ('old.example', 'recent.example');
      '';
    in
    ''
      machine.wait_for_unit("pihole-ftl.service")

      # FTL creates the database asynchronously after startup
      machine.wait_until_succeeds(
        "${sql} \"SELECT name FROM sqlite_master WHERE type = 'table' AND name = 'query_storage'\" | grep -q query_storage"
      )

      # Stop FTL so that it does not write to the database concurrently
      machine.systemctl("stop pihole-ftl.service")

      with subtest("old query log entries are deleted"):
        machine.succeed("${sql} < ${insertRows}")
        assert machine.succeed("${sql} < ${countRows}").strip() == "2"

        machine.succeed("systemctl start pihole-ftl-log-deleter.service")

        remaining = machine.succeed("${sql} < ${remainingRows}").split()
        assert remaining == ["recent.example"], f"expected only the recent entry to remain, got {remaining}"

      with subtest("the deleter does not create a missing database"):
        machine.succeed("mv ${db} ${db}.bak")
        machine.succeed("systemctl start pihole-ftl-log-deleter.service")
        machine.fail("test -e ${db}")
    '';
}
