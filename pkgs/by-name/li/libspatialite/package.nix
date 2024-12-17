{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  validatePkgConfig,
  freexl,
  geos,
  librttopo,
  libxml2,
  minizip,
  proj,
  sqlite,
  libiconv,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "libspatialite";
  version = "5.1.0";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "https://www.gaia-gis.it/gaia-sins/libspatialite-sources/libspatialite-${version}.tar.gz";
    hash = "sha256-Q74t00na/+AW3RQAxdEShYKMIv6jXKUQnyHz7VBgUIA=";
  };

  patches = [
    # Drop use of deprecated libxml2 HTTP API.
    # From: https://www.gaia-gis.it/fossil/libspatialite/info/7c452740fe
    # see also: https://github.com/NixOS/nixpkgs/issues/347085
    ./xmlNanoHTTPCleanup.patch
  ];

  nativeBuildInputs = [
    pkg-config
    validatePkgConfig
    geos # for geos-config
  ];

  buildInputs =
    [
      freexl
      geos
      librttopo
      libxml2
      minizip
      proj
      sqlite
      zlib
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      libiconv
    ];

  enableParallelBuilding = true;

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    ln -s $out/lib/mod_spatialite.{so,dylib}
  '';

  # Failed tests (linux & darwin):
  # - check_virtualtable6
  # - check_drop_rename
  doCheck = false;

  preCheck = ''
    export LD_LIBRARY_PATH=$(pwd)/src/.libs
    export DYLD_LIBRARY_PATH=$(pwd)/src/.libs
  '';

  meta = with lib; {
    description = "Extensible spatial index library in C++";
    homepage = "https://www.gaia-gis.it/fossil/libspatialite";
    # They allow any of these
    license = with licenses; [
      gpl2Plus
      lgpl21Plus
      mpl11
    ];
    platforms = platforms.unix;
    maintainers = with maintainers; teams.geospatial.members ++ [ dotlambda ];
  };
}
