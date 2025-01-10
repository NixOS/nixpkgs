{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  apacheHttpd,
  apr,
  aprutil,
  curl,
  db,
  fcgi,
  gdal,
  geos,
  libgeotiff,
  libjpeg,
  libpng,
  libtiff,
  pcre2,
  pixman,
  proj,
  sqlite,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "mapcache";
  version = "1.14.1";

  src = fetchFromGitHub {
    owner = "MapServer";
    repo = "mapcache";
    rev = "rel-${lib.replaceStrings [ "." ] [ "-" ] version}";
    hash = "sha256-AwdZdOEq9SZ5VzuBllg4U1gdVxZ9IVdqiDrn3QuRdCk=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    apacheHttpd
    apr
    aprutil
    curl
    db
    fcgi
    gdal
    geos
    libgeotiff
    libjpeg
    libpng
    libtiff
    pcre2
    pixman
    proj
    sqlite
    zlib
  ];

  cmakeFlags = [
    (lib.cmakeBool "WITH_BERKELEY_DB" true)
    (lib.cmakeBool "WITH_MEMCACHE" true)
    (lib.cmakeBool "WITH_TIFF" true)
    (lib.cmakeBool "WITH_GEOTIFF" true)
    (lib.cmakeBool "WITH_PCRE2" true)
    (lib.cmakeFeature "APACHE_MODULE_DIR" "${placeholder "out"}/modules")
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-std=c99";

  meta = {
    description = "Server that implements tile caching to speed up access to WMS layers";
    homepage = "https://mapserver.org/mapcache/";
    changelog = "https://www.mapserver.org/development/changelog/mapcache/";
    license = lib.licenses.mit;
    maintainers = lib.teams.geospatial.members;
    platforms = lib.platforms.unix;
  };
}
