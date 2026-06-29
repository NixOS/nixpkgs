{ pkgs, ... }:
let
  pictograms = pkgs.runCommand "umap-test-pictograms" { } ''
    mkdir -p $out/pictograms/test
    printf 'pictogram-collection-ok' > $out/pictograms/test/marker.svg
  '';
in
{
  name = "umap-standard";

  meta.maintainers = pkgs.umap.meta.maintainers;

  nodes.machine =
    { ... }:
    {
      services.umap = {
        enable = true;
        nginx.resolver = "127.0.0.1";
        settings = {
          SITE_URL = "http://localhost";
          UMAP_ALLOW_ANONYMOUS = true;
          UMAP_PICTOGRAMS_COLLECTIONS.Test.path = "${pictograms}";
        };
      };
    };

  testScript = ''
    import json
    import re

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

    with subtest("Create a public map with a data layer"):
        output = machine.succeed("""
          umap-manage shell -c "\
    from umap.models import Map, DataLayer
    from django.contrib.gis.geos import Point
    from django.core.files.base import ContentFile
    import json
    import uuid

    map_obj = Map.objects.create(name='TestMap', center=Point(0, 0), zoom=5, share_status=Map.PUBLIC)
    layer = DataLayer.objects.create(uuid=uuid.uuid4(), map=map_obj, name='TestLayer')

    geojson_data = {
        'type': 'FeatureCollection',
        'features': [{
            'type': 'Feature',
            'geometry': {'type': 'Point', 'coordinates': [0, 0]},
            'properties': {'name': 'datalayer-xaccel-ok'}
        }]
    }

    layer.geojson.save('data.geojson', ContentFile(json.dumps(geojson_data)))
    print('RESULT', map_obj.pk, layer.uuid)
          "
        """)
        match = re.search(r"RESULT (\d+) (\S+)", output)
        assert match, f"could not parse map id / layer uuid from: {output}"
        map_id, layer_uuid = match.group(1), match.group(2)

    with subtest("Upload directories are traversable by nginx but not other users"):
        assert machine.succeed("stat -c %a /var/lib/umap/uploads").strip() == "750"
        assert machine.succeed("stat -c %a /var/lib/umap/uploads/datalayer").strip() == "750"

    with subtest("Datalayer is served via the app using X-Accel-Redirect"):
        machine.succeed(
            f"curl -sSfL http://localhost/datalayer/{map_id}/{layer_uuid}/ | grep -q datalayer-xaccel-ok"
        )

    with subtest("Datalayers cannot be fetched directly from /uploads/"):
        machine.fail("curl -sSf http://localhost/uploads/datalayer/")

    with subtest("CORS proxy is not directly accessible"):
        machine.fail("curl -sSf 'http://localhost/proxy/http://example.org/'")

    with subtest("Admin-uploaded pictogram is served from /uploads/"):
        machine.succeed(
            "umap-manage shell -c \""
            "from django.contrib.auth import get_user_model; "
            "get_user_model().objects.create_superuser('admin', 'admin@example.com', 'password123')\""
        )
        machine.succeed("printf 'db-pictogram-ok' > /tmp/icon.svg")
        machine.succeed("""
          set -eu
          jar=$(mktemp)
          curl -sS -c "$jar" http://localhost/admin/login/ -o /dev/null
          csrf=$(awk '$6 == "csrftoken" { print $7 }' "$jar")
          curl -sS -b "$jar" -c "$jar" \
            --data-urlencode "csrfmiddlewaretoken=$csrf" \
            --data-urlencode "username=admin" \
            --data-urlencode "password=password123" \
            --data-urlencode "next=/admin/" \
            http://localhost/admin/login/ -o /dev/null
          csrf=$(awk '$6 == "csrftoken" { print $7 }' "$jar")
          curl -sS -b "$jar" -c "$jar" \
            -F "csrfmiddlewaretoken=$csrf" \
            -F "name=DbIcon" \
            -F "attribution=Test" \
            -F "pictogram=@/tmp/icon.svg" \
            http://localhost/admin/umap/pictogram/add/ -o /dev/null
        """)
        machine.succeed("curl -sSfL http://localhost/uploads/pictogram/icon.svg | grep -q db-pictogram-ok")

    with subtest("Pictogram collection is served from the nix store via nginx"):
        src = machine.succeed(
            "curl -sSfL http://localhost/pictogram/json/ | "
            "grep -oE '/static/pictograms/[^\"]+' | head -1"
        ).strip()
        assert src, "pictogram collection not listed"
        machine.succeed(f"curl -sSfL http://localhost{src} | grep -q pictogram-collection-ok")
  '';
}
