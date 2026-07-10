{ lib, pkgs, ... }:
let
  inherit (import ../ssh-keys.nix pkgs) snakeOilPrivateKey snakeOilPublicKey;
  backupPath = "/home/backup";
in
{
  name = "pgbackrest-sftp";

  meta = {
    maintainers = with lib.maintainers; [ wolfgangwalther ];
  };

  nodes.primary =
    {
      pkgs,
      ...
    }:
    {
      services.postgresql = {
        enable = true;
        initialScript = pkgs.writeText "init.sql" ''
          CREATE TABLE t(c text);
          INSERT INTO t VALUES ('hello world');
        '';
      };

      services.pgbackrest = {
        enable = true;
        repos.backup = {
          type = "sftp";
          path = "/home/backup";
          sftp-host-key-check-type = "none";
          sftp-host-key-hash-type = "sha256";
          sftp-host-user = "backup";
          sftp-private-key-file = "/var/lib/pgbackrest/sftp_key";
        };

        stanzas.default.jobs.future = {
          schedule = "3000-01-01";
          type = "diff";
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
      users.users.backup = {
        name = "backup";
        group = "backup";
        isNormalUser = true;
        createHome = true;
        openssh.authorizedKeys.keys = [
          snakeOilPublicKey
        ];
      };
      users.groups.backup = { };
    };

  testScript =
    { nodes, ... }:
    ''
      start_all()

      primary.wait_for_unit("multi-user.target")
      backup.wait_for_unit("multi-user.target")

      primary.log(primary.succeed("""
        HOME="/var/lib/pgbackrest"
        cat ${snakeOilPrivateKey} > ~/sftp_key
        chown -R pgbackrest:pgbackrest ~/sftp_key
        chmod 770 ~
      """))

      with subtest("backup/restore works with local instance/remote repo (SFTP)"):
        primary.succeed("sudo -u pgbackrest pgbackrest --stanza=default stanza-create", timeout=10)
        primary.succeed("sudo -u pgbackrest pgbackrest --stanza=default check")

        primary.systemctl("start pgbackrest-default-future")

        # corrupt cluster
        primary.systemctl("stop postgresql")
        primary.execute("rm ${nodes.primary.services.postgresql.dataDir}/global/pg_control")

        primary.succeed("sudo -u postgres pgbackrest --stanza=default restore --delta")

        primary.systemctl("start postgresql")
        primary.wait_for_unit("postgresql.target")
        assert "hello world" in primary.succeed("sudo -u postgres psql -c 'TABLE t;'")
    '';
}
