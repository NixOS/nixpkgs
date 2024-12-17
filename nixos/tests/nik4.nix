# This test downloads some example OpenStreetMap data, imports it into a database and then renders a portion of it. The resulting PNG image will be in the output.
# Importing the data takes some time, at least a couple minutes.

{ lib, pkgs, ... }:
let
  # Fetch a tiny example region
  andorra = pkgs.fetchurl {
    # The OpenStreetMap data from the first of January seems to be kept for at least 10 years
    url = "https://download.geofabrik.de/europe/andorra-240101.osm.pbf";
    hash = "sha256-9RylVK1C28e9qnc8Lu1VGcxS3lNlmjPTWcWvJJlmAf4=";
  };
in
{
  name = "nik4";
  meta.maintainers = lib.teams.geospatial.members ++ (with lib.maintainers; [ Luflosi ]);

  nodes.machine = {
    virtualisation = {
      cores = 2;
      diskSize = 8 * 1024;
      memorySize = 2 * 1024;
    };

    services.postgresql = {
      enable = true;
      extensions = ps: with ps; [ postgis ];
      ensureUsers = lib.singleton {
        name = "osmuser";
        ensureClauses.createdb = true;
      };
    };

    users.users.osmuser = {
      isSystemUser = true;
      group = "osmuser";
    };
    users.groups.osmuser = { };

    environment.systemPackages = with pkgs; [
      osm2pgsql
      nik4
    ];
  };

  testScript = ''
    machine.wait_for_unit("multi-user.target")

    with subtest("Create database"):
      machine.succeed("sudo -u postgres createdb --encoding=UTF8 --owner=osmuser gis")
      machine.succeed("sudo -u postgres psql gis --command='CREATE EXTENSION postgis;'")
      machine.succeed("sudo -u postgres psql gis --command='CREATE EXTENSION hstore;'")

    with subtest("Insert data into database"):
      machine.succeed("mkdir /osm >&2")
      machine.succeed("chown osmuser /osm >&2")

      machine.succeed("sudo -u osmuser '${pkgs.openstreetmap-carto.get_external_data}/bin/get-external-data.py' --config '${pkgs.openstreetmap-carto.get_external_data}/external-data.yml' --data '/osm/get-external-data/'")
      machine.succeed("sudo -u osmuser osm2pgsql --output=flex --style='${pkgs.openstreetmap-carto}/openstreetmap-carto-flex.lua' --database=gis --create '${andorra}'")
      machine.succeed("sudo -u osmuser psql -d gis -f '${pkgs.openstreetmap-carto}/indexes.sql'")
      machine.succeed("sudo -u osmuser psql -d gis -f '${pkgs.openstreetmap-carto}/functions.sql'")

    with subtest("Execute nik4.py"):
      machine.succeed("sudo -u osmuser nik4.py --url 'https://www.openstreetmap.org/#map=17/42.506650/1.525828' --ppi 300 -a 4 '${pkgs.openstreetmap-carto}/mapnik.xml' /tmp/map.png >&2")
      machine.copy_from_vm("/tmp/map.png")
      import os
      image_size = os.stat(machine.out_dir / "map.png").st_size
      assert image_size >= 2 * 1024 * 1024, f"The rendered map image was too small ({image_size} bytes). This indicates, that the map was not rendered correctly."
  '';
}
