{ pkgs, ... }:
{
  name = "umap-remote-database";

  meta.maintainers = pkgs.umap.meta.maintainers;

  nodes = {
    database =
      { config, pkgs, ... }:
      {
        networking = {
          interfaces.eth1 = {
            ipv4.addresses = [
              {
                address = "192.168.2.10";
                prefixLength = 24;
              }
            ];
          };
          firewall.allowedTCPPorts = [ 5432 ];
        };

        services.postgresql = {
          enable = true;
          enableTCPIP = true;
          extensions = p: [ p.postgis ];
          ensureDatabases = [ "umap" ];
          ensureUsers = [
            {
              name = "umap";
              ensureDBOwnership = true;
            }
          ];
          authentication = ''
            hostnossl umap umap 192.168.2.11/32 trust
          '';
        };

        # Create PostGIS extension after database and user are set up
        # This mimics the umap-dbsetup service from the umap module
        systemd.services.postgresql-setup-postgis = {
          description = "Setup PostGIS extension for umap";
          after = [
            "postgresql.service"
            "postgresql-setup.service"
          ];
          requires = [
            "postgresql.service"
            "postgresql-setup.service"
          ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            User = config.services.postgresql.superUser;
          };
          script = ''
            ${config.services.postgresql.package}/bin/psql -d umap -c "CREATE EXTENSION IF NOT EXISTS postgis"
          '';
        };
      };

    server =
      { pkgs, ... }:
      {
        networking = {
          interfaces.eth1 = {
            ipv4.addresses = [
              {
                address = "192.168.2.11";
                prefixLength = 24;
              }
            ];
          };
        };

        environment.systemPackages = [
          pkgs.umap
        ];

        services.umap = {
          enable = true;
          settings = {
            SITE_URL = "http://localhost";
            UMAP_ALLOW_ANONYMOUS = true;
            DATABASE_URL = "postgres://umap@192.168.2.10/umap";
          };
          database.createLocally = false;
        };
      };
  };

  testScript = ''
    start_all()

    database.wait_for_unit("postgresql.service")
    database.wait_for_unit("postgresql-setup-postgis.service")
    database.wait_for_open_port(5432)

    server.wait_for_unit("umap.service")
    server.wait_for_unit("nginx.service")
    server.wait_for_open_port(80)
    server.wait_for_file("/run/umap/umap.sock")

    with subtest("Umap writes data to remote database"):
        count_before = database.succeed(
            "sudo -u postgres psql -d umap -t -c 'SELECT COUNT(*) FROM umap_map'"
        ).strip()

        server.succeed("""
          umap-manage shell -c "\
    from umap.models import Map
    from django.contrib.gis.geos import Point
    Map.objects.create(name='TestMap', center=Point(0, 0), zoom=5)
          "
        """)

        count_after = database.succeed(
            "sudo -u postgres psql -d umap -t -c 'SELECT COUNT(*) FROM umap_map'"
        ).strip()

        assert int(count_after) == int(count_before) + 1, f"Map not created: before={count_before}, after={count_after}"
  '';
}
