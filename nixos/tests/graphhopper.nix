{ pkgs, lib, ... }:
let
  osm-data = pkgs.fetchurl {
    url = "https://download.geofabrik.de/antarctica-140101.osm.pbf";
    hash = "sha256-6wxFxsCnKYotddUCsv3ioe8k+EhDViMG3jbtDMwbXsw=";
  };
  gtfs-data = pkgs.fetchurl {
    url = "https://github.com/google/transit/blob/master/gtfs/spec/en/examples/sample-feed-1.zip?raw=true";
    hash = "sha256-RkBPkbj4Ur8QN/eQGrwhXZHRu+KkNixbAqP5ztU8jWU=";
  };
in
{
  name = "graphhopper";
  meta.maintainers = [ lib.maintainers.baileylu ];

  nodes.machine =
    { ... }:
    {
      services.graphhopper = {
        enable = true;
        datareaderFile = osm-data;
        gtfsFile = gtfs-data;
      };
    };

  testScript = ''
    machine.start()

    machine.wait_for_unit("graphhopper.service")

    machine.wait_for_open_port(8989)
    machine.wait_for_open_port(8990)

    machine.wait_until_succeeds("curl -s --max-time 0.5 localhost:8990/healthcheck")
  '';
}
