{ stdenv
, mkDerivation
, lib
, fetchurl
# native
, autoreconfHook
, pkg-config
# not native
, gdal
, wxGTK31
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
  version = "7.9.1";

  src = fetchurl {
    url = "mirror://sourceforge/saga-gis/SAGA%20-%20${lib.versions.major version}/SAGA%20-%20${version}/saga-${version}.tar.gz";
    sha256 = "sha256-Jq1LhBSeJuq9SlNl/ko5I8+jnjZnLMfGYNNUnzVWo7w=";
  };

  nativeBuildInputs = [
    # Upstream's gnerated ./configure is not reliable
    autoreconfHook
    pkg-config
  ];
  configureFlags = [
    "--with-system-svm"
    # hdf is no detected otherwise
    "HDF5_LIBS=-l${hdf5}/lib"
    "HDF5_CFLAGS=-I${hdf5.dev}/include"
  ];
  buildInputs = [
    curl
    dxflib
    fftw
    libsvm
    hdf5
    gdal
    wxGTK31
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

  enableParallelBuilding = true;

  CXXFLAGS = lib.optionalString stdenv.cc.isClang "-std=c++11 -Wno-narrowing";

  meta = with lib; {
    description = "System for Automated Geoscientific Analyses";
    homepage = "http://www.saga-gis.org";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ michelk mpickering ];
    platforms = with platforms; unix;
  };
}
