{ lib, pkgs, ... }:
let
  inherit (import ../ssh-keys.nix pkgs) snakeOilPrivateKey snakeOilPublicKey;
  backupPath = "/var/lib/pgbackrest";
in
{
  name = "pgbackrest-posix";

  meta = {
    maintainers = with lib.maintainers; [ wolfgangwalther ];
  };

  nodes.primary =
    {
      pkgs,
      ...
    }:
    {
      services.openssh.enable = true;
      users.users.postgres.openssh.authorizedKeys.keys = [
        snakeOilPublicKey
      ];

      services.postgresql = {
        enable = true;
        initialScript = pkgs.writeText "init.sql" ''
          CREATE TABLE t(c text);
          INSERT INTO t VALUES ('hello world');
        '';
        # To make sure we're waiting for read-write after recovery.
        ensureUsers = [
          {
            name = "app-user";
            ensureClauses.login = true;
          }
        ];
      };

      services.pgbackrest = {
        enable = true;
        repos.backup = {
          type = "posix";
          path = backupPath;
          host-user = "pgbackrest";
        };
      };
    };

  nodes.backup =
    {
      nodes,
      ...
    }:
    {
      services.openssh.enable = true;
      users.users.pgbackrest.openssh.authorizedKeys.keys = [
        snakeOilPublicKey
      ];

      services.pgbackrest = {
        enable = true;
        repos.localhost.path = backupPath;

        stanzas.default = {
          jobs.future = {
            schedule = "3000-01-01";
            type = "full";
          };
          instances.primary = {
            path = nodes.primary.services.postgresql.dataDir;
            user = "postgres";
          };
        };

        # Examples from https://pgbackrest.org/configuration.html#introduction
        # Not used for the test, except for dumping the config.
        stanzas.config-format.settings = {
          start-fast = true;
          compress-level = 3;
          buffer-size = "2MiB";
          db-timeout = 600;
          db-exclude = [
            "db1"
            "db2"
            "db5"
          ];
          tablespace-map = {
            ts_01 = "/db/ts_01";
            ts_02 = "/db/ts_02";
          };
        };
      };
    };

  testScript =
    { nodes, ... }:
    ''
      start_all()

      primary.wait_for_unit("multi-user.target")
      backup.wait_for_unit("multi-user.target")

      with subtest("config file is written correctly"):
        from textwrap import dedent
        have = backup.succeed("cat /etc/pgbackrest/pgbackrest.conf")
        want = dedent("""\
          [config-format]
          buffer-size=2MiB
          compress-level=3
          db-exclude=db1
          db-exclude=db2
          db-exclude=db5
          db-timeout=600
          start-fast=y
          tablespace-map=ts_01=/db/ts_01
          tablespace-map=ts_02=/db/ts_02
        """)
        assert want in have, repr((want, have))

      primary.log(primary.succeed("""
        HOME="${nodes.primary.services.postgresql.dataDir}"
        mkdir -m 700 -p ~/.ssh
        cat ${snakeOilPrivateKey} > ~/.ssh/id_ecdsa
        chmod 400 ~/.ssh/id_ecdsa
        ssh-keyscan backup >> ~/.ssh/known_hosts
        chown -R postgres:postgres ~/.ssh
      """))

      backup.log(backup.succeed("""
        HOME="${backupPath}"
        mkdir -m 700 -p ~/.ssh
        cat ${snakeOilPrivateKey} > ~/.ssh/id_ecdsa
        chmod 400 ~/.ssh/id_ecdsa
        ssh-keyscan primary >> ~/.ssh/known_hosts
        chown -R pgbackrest:pgbackrest ~
      """))

      with subtest("backup/restore works with remote instance/local repo (SSH)"):
        backup.succeed("sudo -u pgbackrest pgbackrest --stanza=default stanza-create")
        backup.succeed("sudo -u pgbackrest pgbackrest --stanza=default check")

        backup.systemctl("start pgbackrest-default-future")

        # corrupt cluster
        primary.systemctl("stop postgresql")
        primary.execute("rm ${nodes.primary.services.postgresql.dataDir}/global/pg_control")

        primary.succeed("sudo -u postgres pgbackrest --stanza=default restore --delta")

        primary.systemctl("start postgresql")
        primary.wait_for_unit("postgresql.target")
        assert "hello world" in primary.succeed("sudo -u postgres psql -c 'TABLE t;'")
    '';
}
