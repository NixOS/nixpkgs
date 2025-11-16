{ pkgs, ... }:
let
  pictograms = pkgs.runCommand "umap-test-pictograms" { } ''
    mkdir -p $out/pictograms/test
    printf 'pictogram-collection-ok' > $out/pictograms/test/marker.svg
  '';
  customStatics = pkgs.writeTextDir "custom/test-custom.css" "body { color: red; }";
in
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
          UMAP_PICTOGRAMS_COLLECTIONS.Test.path = "${pictograms}";
          UMAP_CUSTOM_STATICS = "${customStatics}";
        };
      };
    };

  testScript =
    { nodes, ... }:
    let
      staticRoot = nodes.machine.systemd.services.umap.environment.STATIC_ROOT;
    in
    ''
      import json
      import re

      machine.wait_for_unit("umap.service")
      machine.wait_for_unit("nginx.service")

      machine.wait_for_open_port(80)
      # The socket exists before uvicorn is serving, so nginx answers 502 for a
      # moment after startup.
      machine.wait_until_succeeds("curl -sSfL http://localhost/ | grep -i umap")

      with subtest("Static files are served"):
          manifest = json.loads(machine.succeed("cat ${staticRoot}/staticfiles.json"))
          machine.succeed("curl -sSfL http://localhost/static/" + manifest["paths"]["umap/base.css"])
          # The frontend requests some paths without the manifest hash, e.g. the default marker icon
          machine.succeed("curl -sSfL -o /dev/null http://localhost/static/umap/img/marker.svg")

      with subtest("Custom static file is served"):
          machine.succeed("curl -sSfL http://localhost/static/" + manifest["paths"]["custom/test-custom.css"])

      with subtest("The umap user can reach the local Redis socket"):
          machine.succeed(
              "umap-manage shell -c \""
              "import redis; from django.conf import settings; "
              "assert redis.from_url(settings.REDIS_URL).ping()\""
          )

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
      print('RESULT', map_obj.pk, layer.uuid, layer.geojson.name)
            "
          """)
          match = re.search(r"RESULT (\d+) (\S+) (\S+)", output)
          assert match, f"could not parse map id / layer uuid from: {output}"
          map_id, layer_uuid, geojson_name = match.group(1), match.group(2), match.group(3)

      with subtest("Datalayer is served via the app using X-Accel-Redirect"):
          machine.succeed(
              f"curl -sSfL http://localhost/datalayer/{map_id}/{layer_uuid}/ | grep -q datalayer-xaccel-ok"
          )

      with subtest("Datalayers cannot be fetched directly from /uploads/"):
          machine.fail(f"curl -sSf http://localhost/uploads/{geojson_name}")

      with subtest("Ajax proxy cache directory is writable by the service"):
          machine.succeed("runuser -u umap -- test -w /var/cache/umap")

      with subtest("Uploaded pictogram is served from /uploads/"):
          machine.succeed("""
            umap-manage shell -c "\
      from umap.models import Pictogram
      from django.core.files.base import ContentFile

      pictogram = Pictogram.objects.create(name='DbIcon', attribution='Test')
      pictogram.pictogram.save('icon.svg', ContentFile('db-pictogram-ok'))
            "
          """)
          machine.succeed("curl -sSfL http://localhost/uploads/pictogram/icon.svg | grep -q db-pictogram-ok")

      with subtest("Pictogram collection is served from the nix store via nginx"):
          src = machine.succeed(
              "curl -sSfL http://localhost/pictogram/json/ | "
              "grep -oE '/static/pictograms/[^\"]+' | head -1"
          ).strip()
          assert src, "pictogram collection not listed"
          machine.succeed(f"curl -sSfL http://localhost{src} | grep -q pictogram-collection-ok")

      with subtest("Statics are not collected again on an unchanged restart"):
          # collectstatic --clear empties STATIC_ROOT, so the sentinel only
          # survives a restart that skipped the collection.
          machine.succeed("touch ${staticRoot}/sentinel")
          machine.systemctl("restart umap.service")
          machine.wait_for_unit("umap.service")
          machine.wait_for_file("/run/umap/umap.sock")
          machine.succeed("test -e ${staticRoot}/sentinel")

      with subtest("A stamp that no longer matches collects the statics again"):
          machine.succeed("echo stale > /var/lib/umap/.setup-stamp")
          machine.systemctl("restart umap.service")
          machine.wait_for_unit("umap.service")
          machine.wait_for_file("/run/umap/umap.sock")
          machine.fail("test -e ${staticRoot}/sentinel")
          machine.succeed("curl -sSfL -o /dev/null http://localhost/static/umap/img/marker.svg")
    '';
}
