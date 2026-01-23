# Litestream {#module-services-litestream}

[Litestream](https://litestream.io/) is a standalone streaming
replication tool for SQLite.

## Configuration {#module-services-litestream-configuration}

Litestream service is managed by a dedicated user named `litestream`
which needs permission to the database file. Here's an example config which gives
required permissions to access [grafana database](#opt-services.grafana.settings.database.path):
```nix
{ pkgs, ... }:
{
  users.users.litestream.extraGroups = [ "grafana" ];

  systemd.services.grafana.serviceConfig.ExecStartPost =
    "+"
    + pkgs.writeShellScript "grant-grafana-permissions" ''
      timeout=10

      while [ ! -f /var/lib/grafana/data/grafana.db ];
      do
        if [ "$timeout" == 0 ]; then
          echo "ERROR: Timeout while waiting for /var/lib/grafana/data/grafana.db."
          exit 1
        fi

        sleep 1

        ((timeout--))
      done

      find /var/lib/grafana -type d -exec chmod -v 775 {} \;
      find /var/lib/grafana -type f -exec chmod -v 660 {} \;
    '';

  services.litestream = {
    enable = true;

    environmentFile = "/run/secrets/litestream";

    settings = {
      dbs = [
        {
          path = "/var/lib/grafana/data/grafana.db";
          replicas = [ { url = "s3://mybkt.litestream.io/grafana"; } ];
        }
      ];
    };
  };
}
```
