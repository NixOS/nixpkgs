# GraphHopper {#module-services-graphhopper}

[GraphHopper](https://www.graphhopper.com/) is a fast and memory-efficient routing engine for [OpenStreetMap](https://www.openstreetmap.org)

## Basic Usage {#module-services-graphhopper-basic-usage}

The most simple usage of the GraphHopper service would look something like:

```nix
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
  services.graphhopper = {
    enable = true;
    datareaderFile = osm-data; # Maps to "graphhopper.datareader.file"
    gtfsFile = gtfs-data; # Maps to "graphhopper.gtfs.file"
  };
}
```

Both `datareaderFile` and `gtfsFile` are mandatory fields as you must select which OSM source data and GTFS data you wish to use with the service.

### Sourcing Data {#module-services-graphhopper-basic-usage-sourcing-data}

Some recommended ways to acquire these datasets are:

| Data Type           | Suggested Source                       |
| ------------------- | -------------------------------------- |
| OpenStreetMap Data  | [Geofabrik](https://www.geofabrik.de/) |
| GTFS Data           | [GTFS.org](https://gtfs.org/)          |

## Extended Options {#module-services-graphhopper-extended-options}

A more advanced configuration of graphhopper may look like:

```nix
{ pkgs, ... }:
# OSM/GTFS sources omitted - see `Basic Usage`
{
  services.graphhopper = {
    enable = true;
    datareaderFile = osm-data;
    gtfsFile = gtfs-data;

    # Customise the cache location graphhopper uses
    # Must be accessible by the systemd DynamicUser for graphhopper
    graphLocation = "/home/graphhopper/cache";

    # Configuration for the graphhopper dropwizard service
    server = {
      application_connectors = [
        {
          type = "http";
          port = 8989;
          bind_host = "localhost";
        }
      ];
      admin_connectors = [
        {
          type = "http";
          port = 8990;
          bind_host = "localhost";
        }
      ];
    };

    # OSM highways to ignore when building the graph
    ignoredHighways = [
      "motorway"
      "trunk"
    ];

    # GraphHopper profiles to build for the dataset
    profiles = [
      {
        name = "foot";
        custom_model_files = [ "foot.json" ];
      }
    ];

    # Values to encode for the graph
    encodedValues = "foot_access, foot_average_speed, foot_priority, hike_rating, mtb_rating, country, road_class";

    # Define any extra configuration that isn't directly mapped to a nix option here:
    # NOTE: GraphHopper config tends to have a lot of options labelled `x.y.z`.
    # In order to use these properly they should be string escaped like `"x.y.z."`
    extraConfig = {
      graphhopper."graph.elevation.dataaccess" = "RAM_STORE";
    };

    # Include extra configuration in yaml format instead of nix
    extraYmlConfig = ''
      graphhopper:
        graph.elevation.dataaccess: RAM_STORE
    '';
  };
}
```
