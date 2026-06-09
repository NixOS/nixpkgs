{ lib, ... }:
let
  dbName = "authdb";
  dbUser = "authuser";
in
{
  name = "pam-pgsql";
  meta.maintainers = with lib.maintainers; [ moraxyc ];

  nodes.machine =
    { lib, pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [ pamtester ];
      environment.etc."pam_pgsql.conf".text = lib.generators.toKeyValue { } {
        connect = "host=/run/postgresql port=5432 dbname=${dbName} user=${dbUser} connect_timeout=15";
        auth_query = "select password from account where username = %u";
        acct_query = "select (expired = 'y' OR expired = '1'), (newtok = 'y' OR newtok = '1'), (password IS NULL OR password = '') from account where username = %u";
        pwd_query = "update account set password = %p where username = %u";
        pw_type = "crypt";
      };

      services.postgresql = {
        enable = true;
        authentication = ''
          local ${dbName} ${dbUser} trust
        '';
        initialScript =
          pkgs.writeText "init.psql"
            # sql
            ''
              CREATE USER ${dbUser};
              CREATE DATABASE ${dbName} OWNER ${dbUser};
              \c ${dbName}

              -- https://github.com/pam-pgsql/pam-pgsql/blob/master/sample.sql
              CREATE TABLE account (
                username varchar(256) UNIQUE NOT NULL,
                password varchar(200),
                expired  boolean,
                newtok   boolean
              );

              GRANT ALL PRIVILEGES ON TABLE account TO ${dbUser};

              CREATE EXTENSION IF NOT EXISTS pgcrypto;
              INSERT INTO account (username, password, expired, newtok)
              VALUES (
                  'alice',
                  crypt('secret', gen_salt('bf')),
                  false,
                  false
              );
            '';
      };
      security.pam.services.pgsql-test.text =
        let
          pam-pgsql-so = "${pkgs.pam-pgsql}/lib/security/pam_pgsql.so";
        in
        ''
          auth        required    ${pam-pgsql-so}
          account     required    ${pam-pgsql-so}
          password    required    ${pam-pgsql-so}
          session     required    ${pam-pgsql-so}
        '';
    };

  testScript =
    # python
    ''
      start_all()

      machine.wait_for_unit("postgresql-setup.service")

      with subtest("Testing successful login..."):
          machine.succeed("echo 'secret' | pamtester -v pgsql-test alice authenticate")

      with subtest("Testing failed login..."):
          machine.fail("echo 'wrongpass' | pamtester -v pgsql-test alice authenticate")

      with subtest("Testing non-existent user..."):
          machine.fail("echo 'secret' | pamtester -v pgsql-test bob authenticate")

      with subtest("Testing expired user..."):
          machine.succeed("psql -U ${dbUser} -d ${dbName} -c 'UPDATE account SET expired = TRUE;'")
          machine.succeed("echo 'secret' | pamtester -v pgsql-test alice authenticate")
          machine.fail("pamtester -v pgsql-test alice acct_mgmt")
    '';
}
