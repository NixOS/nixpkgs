{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  validatePkgConfig,
  cairo,
  curl,
  fontconfig,
  freetype,
  freexl,
  geos,
  giflib,
  libgeotiff,
  libjpeg,
  libpng,
  librttopo,
  libspatialite,
  libtiff,
  libwebp,
  libxml2,
  lz4,
  minizip,
  openjpeg,
  pixman,
  proj,
  sqlite,
  xz,
  zstd,
}:

stdenv.mkDerivation rec {
  pname = "librasterlite2";
  version = "1.1.0-beta1";

  src = fetchurl {
    url = "https://www.gaia-gis.it/gaia-sins/librasterlite2-sources/librasterlite2-${version}.tar.gz";
    hash = "sha256-9yhM38B600OjFOSHjfAwCHSwFF2dMxsGOwlrSC5+RPQ=";
  };

  # Fix error: unknown type name 'time_t'
  postPatch = ''
    sed -i '49i #include <time.h>' headers/rasterlite2_private.h
  '';

  nativeBuildInputs = [
    pkg-config
    validatePkgConfig
    geos # for geos-config
  ];

  buildInputs = [
    cairo
    curl
    fontconfig
    freetype
    freexl
    giflib
    geos
    libgeotiff
    libjpeg
    libpng
    librttopo
    libspatialite
    libtiff
    libwebp
    libxml2
    lz4
    minizip
    openjpeg
    pixman
    proj
    sqlite
    xz # liblzma
    zstd
  ];

  enableParallelBuilding = true;

  # Failed tests:
  # - check_sql_stmt
  doCheck = false;

<<<<<<< HEAD
  meta = {
    description = "Advanced library supporting raster handling methods";
    homepage = "https://www.gaia-gis.it/fossil/librasterlite2";
    # They allow any of these
    license = with lib.licenses; [
=======
  meta = with lib; {
    description = "Advanced library supporting raster handling methods";
    homepage = "https://www.gaia-gis.it/fossil/librasterlite2";
    # They allow any of these
    license = with licenses; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      gpl2Plus
      lgpl21Plus
      mpl11
    ];
<<<<<<< HEAD
    platforms = lib.platforms.unix;
    teams = [ lib.teams.geospatial ];
=======
    platforms = platforms.unix;
    teams = [ teams.geospatial ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
