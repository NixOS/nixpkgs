{ lib, pkgs, ... }:
let
  inherit (import ../ssh-keys.nix pkgs) snakeOilPrivateKey snakeOilPublicKey;
  backupPath = "/home/backup";
  cipherPassFile = "/run/cipher-pass";
  cipherPass = "my_cipher";
  cipherType = "aes-256-cbc";
in
{
  name = "pgbackrest-sftp";

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

      # Stands in for whatever secret manager provides the passphrase at runtime.
      systemd.services.pgbackrest-secrets.preStart = ''
        echo -n "${cipherPass}" > ${cipherPassFile}
      '';

      services.pgbackrest = {
        enable = true;
        repos.backup = {
          type = "sftp";
          path = backupPath;
          sftp-host-key-check-type = "none";
          sftp-host-key-hash-type = "sha256";
          sftp-host-user = "backup";
          sftp-private-key-file = "/var/lib/pgbackrest/sftp_key";
          cipher-type = cipherType;
          cipher-pass-file = cipherPassFile;
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

        # The passphrase reaches pgBackRest without passing through the store.
        primary.fail("grep -r '${cipherPass}' /etc/pgbackrest/pgbackrest.conf")
        primary.succeed("sudo -u postgres test -r /etc/pgbackrest/conf.d/cipher-pass.conf")
        assert "640 pgbackrest pgbackrest" in primary.succeed(
            "stat -c '%a %U %G' /etc/pgbackrest/conf.d/cipher-pass.conf"
        )
        assert "${cipherType}" in primary.succeed("sudo -u pgbackrest pgbackrest --stanza=default info")

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
