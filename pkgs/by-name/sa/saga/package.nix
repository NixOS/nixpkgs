{
  lib,
  stdenv,
  config,
  fetchurl,

  # nativeBuildInputs
  cmake,
  dos2unix,
  pkg-config,
  wrapGAppsHook3,
  # cuda-specific
  cudaPackages,
  # darwin-specific
  desktopToDarwinBundle,

  # buildInputs
  curl,
  fftw,
  gdal,
  giflib,
  hdf5,
  libharu,
  libiodbc,
  libpq,
  libsForQt5,
  libsvm,
  opencv,
  pdal,
  proj,
  qhull,
  vigra,
  wxGTK32,
  xz,
  # darwin-specific
  netcdf,
  poppler,
  sqlite,
  unixODBC,

  cudaSupport ? config.cudaSupport,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "saga";
  version = "9.10.2";

  src = fetchurl {
    url = "mirror://sourceforge/saga-gis/saga-${finalAttrs.version}.tar.gz";
    hash = "sha256-fsMH2dXE0w1DsIYJC3RscT/aDDYeewXLo6MBLCL2zCo=";
  };

  sourceRoot = "saga-${finalAttrs.version}/saga-gis";

  postPatch = ''
    dos2unix src/saga_core/saga_gui/res/org.saga_gis.saga_gui.desktop
  '';

  nativeBuildInputs = [
    cmake
    dos2unix
    pkg-config
    wrapGAppsHook3
  ]
  ++ lib.optionals cudaSupport [
    cudaPackages.cuda_nvcc
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    desktopToDarwinBundle
  ];

  buildInputs = [
    curl
    fftw
    gdal
    giflib
    hdf5
    libharu
    libiodbc
    libpq
    libsForQt5.dxflib
    libsvm
    opencv
    pdal
    proj
    qhull
    vigra
    wxGTK32
    xz
  ]
  ++ lib.optionals cudaSupport [
    cudaPackages.cuda_cudart
  ]
  # See https://groups.google.com/forum/#!topic/nix-devel/h_vSzEJAPXs
  # for why the have additional buildInputs on darwin
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    netcdf
    poppler
    sqlite
    unixODBC
  ];

  cmakeFlags = [
    (lib.cmakeBool "OpenMP_SUPPORT" (!stdenv.hostPlatform.isDarwin))
  ];

  meta = {
    description = "System for Automated Geoscientific Analyses";
    homepage = "https://saga-gis.sourceforge.io";
    changelog = "https://sourceforge.net/p/saga-gis/wiki/Changelog%20${finalAttrs.version}/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      michelk
      mpickering
    ];
    teams = [ lib.teams.geospatial ];
    platforms = with lib.platforms; unix;
  };
})
