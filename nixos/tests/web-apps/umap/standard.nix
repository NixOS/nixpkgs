{ pkgs, ... }:
{
  name = "umap-standard";

  meta.maintainers = pkgs.umap.meta.maintainers;

  nodes.machine =
    { ... }:
    {
      services.umap = {
        enable = true;
        settings.SITE_URL = "http://localhost";
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
          # Not every URL goes through the manifest: the default marker icon and
          # the pictogram sources below are requested unhashed.
          machine.succeed("curl -sSfL -o /dev/null http://localhost/static/umap/img/marker.svg")
          # Umap lists the collection from its configured path, so the icons have
          # to be in the static root as well.
          machine.succeed("curl -sSfL http://localhost/pictogram/json/ | grep -q Osmic")
          machine.succeed(
              "curl -sSfL -o /dev/null http://localhost/static/pictograms/transport/airport.svg"
          )

      with subtest("The umap user can reach the local Redis socket"):
          machine.succeed(
              "umap-manage shell -c \""
              "import redis; from django.conf import settings; "
              "assert redis.from_url(settings.REDIS_URL).ping()\""
          )

      output = machine.succeed("""
        umap-manage shell -c "\
      from umap.models import Map, DataLayer
      from django.contrib.gis.geos import Point
      from django.core.files.base import ContentFile
      import json
      import uuid

      map_obj = Map.objects.create(name='TestMap', center=Point(0, 0), zoom=5, share_status=Map.PUBLIC)
      layer = DataLayer.objects.create(uuid=uuid.uuid4(), map=map_obj, name='TestLayer')

      feature = {'type': 'Feature', 'geometry': {'type': 'Point', 'coordinates': [0, 0]}, 'properties': {'name': 'datalayer-xaccel-ok'}}
      geojson_data = {'type': 'FeatureCollection', 'features': [feature]}

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
    '';
}
