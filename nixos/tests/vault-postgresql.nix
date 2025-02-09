/*
  This test checks that
   - multiple config files can be loaded
   - the storage backend can be in a file outside the nix store
     as is required for security (required because while confidentiality is
     always covered, availability isn't)
   - the postgres integration works
*/
import ./make-test-python.nix (
  { pkgs, ... }:
  {
    name = "vault-postgresql";
    meta = with pkgs.lib.maintainers; {
      maintainers = [
        lnl7
        roberth
      ];
    };
    nodes.machine =
      { lib, pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.vault ];
        environment.variables.VAULT_ADDR = "http://127.0.0.1:8200";
        services.vault.enable = true;
        services.vault.extraSettingsPaths = [ "/run/vault.hcl" ];

        systemd.services.vault = {
          after = [
            "postgresql.service"
          ];
          # Try for about 10 minutes rather than the default of 5 attempts.
          serviceConfig.RestartSec = 1;
          serviceConfig.StartLimitBurst = 600;
        };
        # systemd.services.vault.unitConfig.RequiresMountsFor = "/run/keys/";

        services.postgresql.enable = true;
        services.postgresql.initialScript = pkgs.writeText "init.psql" ''
          CREATE USER vaultuser WITH ENCRYPTED PASSWORD 'thisisthepass';
          GRANT CONNECT ON DATABASE postgres TO vaultuser;

          -- https://www.vaultproject.io/docs/configuration/storage/postgresql
          CREATE TABLE vault_kv_store (
            parent_path TEXT COLLATE "C" NOT NULL,
            path        TEXT COLLATE "C",
            key         TEXT COLLATE "C",
            value       BYTEA,
            CONSTRAINT pkey PRIMARY KEY (path, key)
          );
          CREATE INDEX parent_path_idx ON vault_kv_store (parent_path);

          GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO vaultuser;
        '';
      };

    testScript = ''
      secretConfig = """
          storage "postgresql" {
            connection_url = "postgres://vaultuser:thisisthepass@localhost/postgres?sslmode=disable"
          }
          """

      start_all()

      machine.wait_for_unit("multi-user.target")
      machine.succeed("cat >/root/vault.hcl <<EOF\n%s\nEOF\n" % secretConfig)
      machine.succeed(
          "install --owner vault --mode 0400 /root/vault.hcl /run/vault.hcl; rm /root/vault.hcl"
      )
      machine.wait_for_unit("vault.service")
      machine.wait_for_open_port(8200)
      machine.succeed("vault operator init")
      machine.succeed("vault status || test $? -eq 2")
    '';
  }
)
