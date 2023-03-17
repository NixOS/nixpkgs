{ stdenv
, mkDerivation
, lib
, fetchurl
# native
, cmake
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

mkDerivation rec {
  pname = "saga";
  version = "8.5.1";

  src = fetchurl {
    url = "mirror://sourceforge/saga-gis/SAGA%20-%20${lib.versions.major version}/SAGA%20-%20${version}/saga-${version}.tar.gz";
    sha256 = "sha256-JnZ0m0GAgfz3BbiKxqLoMoa4pX//r5t+mbhMCdAo9OE=";
  };

  sourceRoot = "saga-${version}/saga-gis";

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

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
    homepage = "http://www.saga-gis.org";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ michelk mpickering ];
    platforms = with platforms; unix;
  };
}
