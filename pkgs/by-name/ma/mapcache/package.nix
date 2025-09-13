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
  gfortran,
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

stdenv.mkDerivation (finalAttrs: {
  pname = "mapcache";
  version = "1.14.1";

  src = fetchFromGitHub {
    owner = "MapServer";
    repo = "mapcache";
    tag = "rel-${lib.replaceStrings [ "." ] [ "-" ] finalAttrs.version}";
    hash = "sha256-AwdZdOEq9SZ5VzuBllg4U1gdVxZ9IVdqiDrn3QuRdCk=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # work around for `ld: file not found: @rpath/libquadmath.0.dylib`
    gfortran.cc
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

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-std=c99";

  prePatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "include_directories(\''${TIFF_INCLUDE_DIR})" "" \
      --replace-fail "target_link_libraries(mapcache \''${TIFF_LIBRARY})" "target_link_libraries(mapcache TIFF::TIFF)"
  '';

  meta = {
    description = "Server that implements tile caching to speed up access to WMS layers";
    homepage = "https://mapserver.org/mapcache/";
    changelog = "https://www.mapserver.org/development/changelog/mapcache/";
    license = lib.licenses.mit;
    teams = [ lib.teams.geospatial ];
    platforms = lib.platforms.unix;
  };
})
