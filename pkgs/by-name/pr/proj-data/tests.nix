{ runCommand, proj, proj-data }:

let
  inherit (proj-data) pname;
in
runCommand "${pname}-tests" { meta.timeout = 60; }
  ''
    set -o pipefail

    # add proj-data files to proj resources search path
    export PROJ_DATA=${proj}/share/proj:${proj-data}

    # conversion from NZGD1949 to NZGD2000 using proj strings
    echo '173 -41 0' \
      | ${proj}/bin/cs2cs --only-best -f %.8f \
        +proj=longlat +ellps=intl +datum=nzgd49 +nadgrids=nz_linz_nzgd2kgrid0005.tif \
        +to +proj=longlat +ellps=GRS80 +towgs84=0,0,0 \
      | grep -E '[0-9\.\-]+*'

    # conversion from NZGD1949 to NZGD2000 using EPSG codes
    echo '-41 173 0' | ${proj}/bin/cs2cs --only-best -f %.8f EPSG:4272 EPSG:4167 \
      | grep -E '[0-9\.\-]+*'

    touch $out
  ''
