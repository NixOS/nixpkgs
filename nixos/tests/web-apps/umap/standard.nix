{ pkgs, ... }:
{
  name = "umap-standard";

  meta.maintainers = pkgs.umap.meta.maintainers;

  nodes.machine =
    { ... }:
    {
      services.umap = {
        enable = true;
        settings = {
          SITE_URL = "http://localhost";
          UMAP_ALLOW_ANONYMOUS = true;
        };
      };
    };

  testScript = ''
    import json

    machine.wait_for_unit("umap.service")
    machine.wait_for_unit("postgresql.service")
    machine.wait_for_unit("nginx.service")

    machine.wait_for_open_port(80)

    # Wait for umap socket to be created
    machine.wait_for_file("/run/umap/umap.sock")

    with subtest("Umap web interface is accessible"):
        machine.succeed("curl -sSfL http://localhost/ | grep -i umap")

    with subtest("PostgreSQL with PostGIS is set up"):
        machine.succeed("sudo -u postgres psql -d umap -c 'SELECT PostGIS_version()'")

    with subtest("Static files are served"):
        manifest = json.loads(machine.succeed("cat ${pkgs.umap.static}/staticfiles.json"))
        machine.succeed("curl -sSfL http://localhost/static/" + manifest["paths"]["umap/base.css"])

    with subtest("Map creation page is accessible"):
        machine.succeed("curl -sSfL http://localhost/map/new/")

    with subtest("Create map with data layer and verify file storage"):
        count_before = machine.succeed(
            "sudo -u postgres psql -d umap -t -c 'SELECT COUNT(*) FROM umap_map'"
        ).strip()

        # Create a map with a marker point so that geojson files are written
        output = machine.succeed("""
          umap-manage shell -c "\
    from umap.models import Map, DataLayer
    from django.contrib.gis.geos import Point
    from django.core.files.base import ContentFile
    import json
    import uuid

    map_obj = Map.objects.create(name='TestMap', center=Point(0, 0), zoom=5)
    layer = DataLayer.objects.create(uuid=uuid.uuid4(), map=map_obj, name='TestLayer')

    geojson_data = {
        'type': 'FeatureCollection',
        'features': [{
            'type': 'Feature',
            'geometry': {'type': 'Point', 'coordinates': [0, 0]},
            'properties': {}
        }]
    }

    layer.geojson.save('data.geojson', ContentFile(json.dumps(geojson_data)))
          "
        """)
        print(f"Shell command output: {output}")

        # Verify map was created in database
        count_after = machine.succeed(
            "sudo -u postgres psql -d umap -t -c 'SELECT COUNT(*) FROM umap_map'"
        ).strip()

        assert int(count_after) == int(count_before) + 1, f"Map not created: before={count_before}, after={count_after}"

        # Verify files were written to media_root (uploads directory)
        machine.succeed("test -d /var/lib/umap/uploads")
        file_count = machine.succeed("find /var/lib/umap/uploads -type f | wc -l").strip()
        assert int(file_count) > 0, "No files created in uploads directory"
        machine.succeed("ls -lah /var/lib/umap/uploads")
  '';
}
