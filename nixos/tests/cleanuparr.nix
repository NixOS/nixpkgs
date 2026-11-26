{ lib, ... }:
let
  port = 11011;
  basePath = "/cleanuparr";
in
{
  name = "cleanuparr";
  meta.maintainers = with lib.maintainers; [ mistyttm ];

  nodes = {
    # Default configuration: SQLite backend, reachable from other machines.
    sqlite = {
      services.cleanuparr = {
        enable = true;
        openFirewall = true;
      };
    };

    # Locally provisioned PostgreSQL over a Unix socket (peer auth).
    postgres = {
      services.cleanuparr = {
        enable = true;
        settings.database.provider = "postgres";
      };
    };

    # Custom base path, bind address and non-default state directories.
    custom = {
      services.cleanuparr = {
        enable = true;
        dataDir = "/var/lib/cleanuparr-custom";
        logsDir = "/var/log/cleanuparr-custom";
        settings = {
          bindAddress = "127.0.0.1";
          basePath = basePath;
        };
      };
    };
  };

  testScript = ''
    start_all()

    with subtest("SQLite: service starts and responds"):
        sqlite.wait_for_unit("cleanuparr.service")
        sqlite.wait_for_open_port(${toString port})
        sqlite.wait_until_succeeds("curl --fail --silent http://localhost:${toString port}/health")
        sqlite.succeed("curl --fail --silent http://localhost:${toString port}/ | grep -i cleanuparr")

    with subtest("SQLite: runs as the dedicated user with correct state dir"):
        assert sqlite.succeed("systemctl show cleanuparr.service -p User --value").strip() == "cleanuparr"
        assert sqlite.succeed("stat -c %U:%G:%a /var/lib/cleanuparr").strip() == "cleanuparr:cleanuparr:750"
        # migrations ran and the database was written to the data dir
        sqlite.wait_until_succeeds("find /var/lib/cleanuparr -name '*.db' | grep .")

    with subtest("SQLite: openFirewall exposes the port to other machines"):
        postgres.wait_until_succeeds("curl --fail --silent http://sqlite:${toString port}/health")

    with subtest("PostgreSQL: local database is provisioned and used"):
        postgres.wait_for_unit("postgresql.service")
        postgres.wait_for_unit("cleanuparr.service")
        postgres.wait_for_open_port(${toString port})
        postgres.wait_until_succeeds("curl --fail --silent http://localhost:${toString port}/health")
        # migrations created tables in the provisioned database
        postgres.wait_until_succeeds(
            "test \"$(sudo -u cleanuparr psql -d cleanuparr -tAc "
            "\"select count(*) from information_schema.tables "
            "where table_schema not in ('pg_catalog','information_schema')\")\" -gt 0"
        )
        # not exposed externally without openFirewall
        sqlite.fail("curl --fail --silent --max-time 5 http://postgres:${toString port}/health")

    with subtest("Custom: base path, bind address and directories"):
        custom.wait_for_unit("cleanuparr.service")
        custom.wait_for_open_port(${toString port}, "127.0.0.1")
        custom.wait_until_succeeds("curl --fail --silent http://127.0.0.1:${toString port}${basePath}/health")
        assert custom.succeed("stat -c %U:%G:%a /var/lib/cleanuparr-custom").strip() == "cleanuparr:cleanuparr:750"
        assert custom.succeed("stat -c %U:%G:%a /var/log/cleanuparr-custom").strip() == "cleanuparr:cleanuparr:750"
        custom.wait_until_succeeds("find /var/log/cleanuparr-custom -type f | grep .")
  '';
}
