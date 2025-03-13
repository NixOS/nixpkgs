{
  stdenv,
  lib,
  fetchurl,
  # native
  cmake,
  desktopToDarwinBundle,
  pkg-config,
  wrapGAppsHook3,
  # not native
  gdal,
  wxGTK32,
  proj,
  libsForQt5,
  curl,
  libiodbc,
  xz,
  libharu,
  opencv,
  vigra,
  pdal,
  libpq,
  darwin,
  unixODBC,
  poppler,
  hdf5,
  netcdf,
  sqlite,
  qhull,
  giflib,
  libsvm,
  fftw,
}:

stdenv.mkDerivation rec {
  pname = "saga";
  version = "9.7.2";

  src = fetchurl {
    url = "mirror://sourceforge/saga-gis/saga-${version}.tar.gz";
    hash = "sha256-1nWpFGRBS49uzKl7m/4YWFI+3lvm2zKByYpR9llxsgY=";
  };

  sourceRoot = "saga-${version}/saga-gis";

  patches = [
    # Patches from https://sourceforge.net/p/saga-gis/code/merge-requests/38/.
    # These are needed to fix building on Darwin (technically the first is not
    # required, but the second doesn't apply without it).
    ./darwin-patch-1.patch
    ./darwin-patch-2.patch
  ];

  nativeBuildInputs = [
    cmake
    wrapGAppsHook3
    pkg-config
  ] ++ lib.optional stdenv.hostPlatform.isDarwin desktopToDarwinBundle;

  buildInputs =
    [
      curl
      libsForQt5.dxflib
      fftw
      libsvm
      hdf5
      gdal
      wxGTK32
      pdal
      proj
      libharu
      opencv
      vigra
      libpq
      libiodbc
      xz
      qhull
      giflib
    ]
    # See https://groups.google.com/forum/#!topic/nix-devel/h_vSzEJAPXs
    # for why the have additional buildInputs on darwin
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.Cocoa
      unixODBC
      poppler
      netcdf
      sqlite
    ];

  cmakeFlags = [
    (lib.cmakeBool "OpenMP_SUPPORT" (!stdenv.hostPlatform.isDarwin))
  ];

  meta = with lib; {
    description = "System for Automated Geoscientific Analyses";
    homepage = "https://saga-gis.sourceforge.io";
    changelog = "https://sourceforge.net/p/saga-gis/wiki/Changelog ${version}/";
    license = licenses.gpl2Plus;
    maintainers =
      with maintainers;
      teams.geospatial.members
      ++ [
        michelk
        mpickering
      ];
    platforms = with platforms; unix;
  };
}
