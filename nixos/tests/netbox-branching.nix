{ pkgs, lib, ... }:
{
  name = "netbox-branching";

  nodes = {
    machine = {
      environment.etc."netbox/secret.key".text = ''
        secretsecretsecretsecretsecretsecretsecretsecret00
      '';

      services = {
        postgresql = {
          enable = true;
          ensureDatabases = [ "netbox" ];
          ensureUsers = [
            {
              name = "netbox";
              ensureDBOwnership = true;
            }
          ];
        };

        netbox = {
          enable = true;
          secretKeyFile = "/etc/netbox/secret.key";
          plugins = ps: [
            ps.netbox-branching
          ];
          settings = {
            PLUGINS = [
              # Note that netbox_branching MUST be the last plugin listed
              # (see https://github.com/netboxlabs/netbox-branching/blob/main/README.md)
              "netbox_branching"
            ];
          };
          extraConfig = ''
            from netbox_branching.utilities import DynamicSchemaDict

            DATABASES = DynamicSchemaDict(DATABASE)
            del DATABASE

            DATABASE_ROUTERS = [
              'netbox_branching.database.BranchAwareRouter',
            ]
          '';
        };
      };

      # initial django database migrations exceeds default timeout
      systemd.services.netbox.serviceConfig.TimeoutStartSec = "10min";
    };
  };

  testScript = ''
    start_all()
    machine.wait_for_unit("netbox.service")
    machine.wait_for_open_port(8001)

    # check if the plugin is installed
    machine.succeed("${lib.getExe pkgs.netbox} shell -c 'from django.conf import settings; print(settings.PLUGINS)' | grep netbox_branching")
  '';

  meta.maintainers = with lib.maintainers; [ felbinger ];
}
