import ./make-test-python.nix ({ pkgs, lib, ... }:
let
  port = 5000;
in {
  name = "osrm-backend";
  meta.maintainers = [ lib.maintainers.erictapen ];

  machine = { config, pkgs, ... }:{

    services.osrm = {
      enable = true;
      inherit port;
      dataFile = let
        filename = "monaco";
        osrm-data = pkgs.stdenv.mkDerivation {
          name = "osrm-data";

          buildInputs = [ pkgs.osrm-backend ];

          # This is a pbf file of monaco, downloaded at 2019-01-04 from
          # http://download.geofabrik.de/europe/monaco-latest.osm.pbf
          # as apparently no provider of OSM files guarantees immutability,
          # this is hosted as a gist on GitHub.
          src = pkgs.fetchgit {
            url = "https://gist.github.com/erictapen/01e39f73a6c856eac53ba809a94cdb83";
            rev = "9b1ff0f24deb40e5cf7df51f843dbe860637b8ce";
            sha256 = "1scqhmrfnpwsy5i2a9jpggqnvfgj4hv9p4qyvc79321pzkbv59nx";
          };

          buildCommand = ''
            cp $src/${filename}.osm.pbf .
            ${pkgs.osrm-backend}/bin/osrm-extract -p ${pkgs.osrm-backend}/share/osrm/profiles/car.lua ${filename}.osm.pbf
            ${pkgs.osrm-backend}/bin/osrm-partition ${filename}.osrm
            ${pkgs.osrm-backend}/bin/osrm-customize ${filename}.osrm
            mkdir -p $out
            cp ${filename}* $out/
          '';
        };
      in "${osrm-data}/${filename}.osrm";
    };

    environment.systemPackages = [ pkgs.jq ];
  };

  testScript = let
    query = "http://localhost:${toString port}/route/v1/driving/7.41720,43.73304;7.42463,43.73886?steps=true";
  in ''
    machine.wait_for_unit("osrm.service")
    machine.wait_for_open_port(${toString port})
    assert "Boulevard Rainier III" in machine.succeed(
        "curl --silent '${query}' | jq .waypoints[0].name"
    )
    assert "Avenue de la Costa" in machine.succeed(
        "curl --silent '${query}' | jq .waypoints[1].name"
    )
  '';
})
