{ runCommand, pdal }:

let
  inherit (pdal) pname;
in
runCommand "${pname}-tests" { meta.timeout = 60; } ''
  ${pdal}/bin/pdal --drivers
  touch $out
''
