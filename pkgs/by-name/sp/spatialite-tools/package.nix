{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  freexl,
  geos,
  expat,
  librttopo,
  libspatialite,
  libxml2,
  libz,
  minizip,
  proj,
  readosm,
  sqlite,
  testers,
  spatialite-tools,
}:

stdenv.mkDerivation rec {
  pname = "spatialite-tools";
  version = "5.1.0a";

  src = fetchurl {
    url = "https://www.gaia-gis.it/gaia-sins/spatialite-tools-sources/spatialite-tools-${version}.tar.gz";
    hash = "sha256-EZ40dY6AiM27Q+2BtKbq6ojHZLC32hkAGlUUslRVAc4=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    expat
    freexl
    geos
    librttopo
    libspatialite
    libxml2
    libz
    minizip
    proj
    readosm
    sqlite
  ];

  env = {
    NIX_LDFLAGS = toString [
      "-lxml2"
      (lib.optionalString stdenv.hostPlatform.isDarwin "-liconv")
    ];
  };

  enableParallelBuilding = true;

  passthru.tests.version = testers.testVersion {
    package = spatialite-tools;
    command = "! spatialite_tool --version";
    version = "${libspatialite.version}";
  };

  meta = {
    description = "Complete sqlite3-compatible CLI front-end for libspatialite";
    homepage = "https://www.gaia-gis.it/fossil/spatialite-tools";
    license = with lib.licenses; [
      mpl11
      gpl2Plus
      lgpl21Plus
    ];
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ dotlambda ];
    teams = [ lib.teams.geospatial ];
    mainProgram = "spatialite_tool";
  };
}
