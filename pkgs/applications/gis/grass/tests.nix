{ runCommand, grass }:

let
  inherit (grass) pname version;

in
runCommand "${pname}-tests" { meta.timeout = 60; }
  ''
    HOME=$(mktemp -d)

    ${grass}/bin/grass --tmp-location EPSG:3857 --exec g.version \
      | grep 'GRASS ${version}'

    ${grass}/bin/grass --tmp-location EPSG:3857 --exec g.mapset -l \
      | grep 'PERMANENT'

    touch $out
  ''
