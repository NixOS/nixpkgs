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
  postgresql,
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
  version = "9.6.2";

  src = fetchurl {
    url = "mirror://sourceforge/saga-gis/saga-${version}.tar.gz";
    hash = "sha256-TXnBSIleUdoTek8GpJqR/10OuVvV7UxHxho5fXr8jgk=";
  };

  sourceRoot = "saga-${version}/saga-gis";

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
      postgresql
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
