{ lib
, stdenv
, fetchurl
, pkg-config
, freexl
, geos
, expat
, librttopo
, libspatialite
, libxml2
, minizip
, proj
, readosm
, sqlite
, testers
, spatialite_tools
}:

stdenv.mkDerivation rec {
  pname = "spatialite-tools";
  version = "5.1.0";

  src = fetchurl {
    url = "https://www.gaia-gis.it/gaia-sins/spatialite-tools-sources/spatialite-tools-${version}.tar.gz";
    hash = "sha256-3zAwNnwInKkPpmMIl/PxooB4TaKeG6Y080DbpLCFg7U=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    expat
    freexl
    geos
    librttopo
    libspatialite
    libxml2
    minizip
    proj
    readosm
    sqlite
  ];

  enableParallelBuilding = true;

  passthru.tests.version = testers.testVersion {
    package = spatialite_tools;
    command = "! spatialite_tool --version";
    version = "${libspatialite.version}";
  };

  meta = with lib; {
    description = "A complete sqlite3-compatible CLI front-end for libspatialite";
    homepage = "https://www.gaia-gis.it/fossil/spatialite-tools";
    license = with licenses; [ mpl11 gpl2Plus lgpl21Plus ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ dotlambda ];
    mainProgram = "spatialite_tool";
  };
}
