{ stdenv
, lib
, fetchurl
# native
, cmake
, desktopToDarwinBundle
, pkg-config
# not native
, gdal
, wxGTK32
, proj
, dxflib
, curl
, libiodbc
, xz
, libharu
, opencv
, vigra
, postgresql
, Cocoa
, unixODBC
, poppler
, hdf5
, netcdf
, sqlite
, qhull
, giflib
, libsvm
, fftw
}:

stdenv.mkDerivation rec {
  pname = "saga";
  version = "9.0.2";

  src = fetchurl {
    url = "mirror://sourceforge/saga-gis/saga-${version}.tar.gz";
    sha256 = "sha256-dyqunuROQlF1Lo/XsNj9QlN7WbimksfT1s8TrqB9PXE=";
  };

  sourceRoot = "saga-${version}/saga-gis";

  nativeBuildInputs = [
    cmake
    pkg-config
  ] ++ lib.optional stdenv.isDarwin desktopToDarwinBundle;

  buildInputs = [
    curl
    dxflib
    fftw
    libsvm
    hdf5
    gdal
    wxGTK32
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
  ++ lib.optionals stdenv.isDarwin [
    Cocoa
    unixODBC
    poppler
    netcdf
    sqlite
  ];

  cmakeFlags = [
    "-DOpenMP_SUPPORT=${if stdenv.isDarwin then "OFF" else "ON"}"
  ];

  meta = with lib; {
    description = "System for Automated Geoscientific Analyses";
    homepage = "https://saga-gis.sourceforge.io";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; teams.geospatial.members ++ [ michelk mpickering ];
    platforms = with platforms; unix;
  };
}
