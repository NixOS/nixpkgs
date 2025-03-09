/*
  This test checks that
   - multiple config files can be loaded
   - the storage backend can be in a file outside the nix store
     as is required for security (required because while confidentiality is
     always covered, availability isn't)
   - the postgres integration works
*/
{ pkgs, ... }:
{
  name = "openbao-postgresql";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ brianmay ];
  };
  nodes.machine =
    { lib, pkgs, ... }:
    {
      environment.variables.VAULT_ADDR = "http://127.0.0.1:8200";
      services.openbao.enable = true;
      services.openbao.extraSettingsPaths = [ "/run/openbao.hcl" ];

      systemd.services.openbao = {
        after = [
          "postgresql.service"
        ];
        # Try for about 10 minutes rather than the default of 5 attempts.
        serviceConfig.RestartSec = 1;
        serviceConfig.StartLimitBurst = 600;
      };
      # systemd.services.openbao.unitConfig.RequiresMountsFor = "/run/keys/";

      services.postgresql.enable = true;
      services.postgresql.ensureDatabases = [ "openbao" ];
      services.postgresql.ensureUsers = [
        {
          name = "openbao";
          ensureDBOwnership = true;
        }
      ];
    };

  testScript = ''
    secretConfig = """
        storage "postgresql" {
          connection_url = "postgres:///openbao?sslmode=disable"
        }
        """

    start_all()

    machine.wait_for_unit("multi-user.target")
    machine.succeed("cat >/root/openbao.hcl <<EOF\n%s\nEOF\n" % secretConfig)
    machine.succeed(
        "install --owner openbao --mode 0400 /root/openbao.hcl /run/openbao.hcl; rm /root/openbao.hcl"
    )
    machine.wait_for_unit("openbao.service")
    machine.wait_for_open_port(8200)
    machine.succeed("bao operator init")
    machine.succeed("bao status || test $? -eq 2")
  '';
}
