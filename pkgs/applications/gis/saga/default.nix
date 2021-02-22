{ stdenv
, mkDerivation
, lib
, fetchurl
# native
, autoreconfHook
, pkg-config
# not native
, gdal
, wxGTK31-gtk3
, proj
, dxflib
, curl
, libiodbc
, lzma
, libharu
, opencv
, vigra
, postgresql
, Cocoa
, unixODBC
, poppler
, hdf4
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
  version = "7.8.2";

  src = fetchurl {
    url = "mirror://sourceforge/saga-gis/SAGA%20-%20${lib.versions.major version}/SAGA%20-%20${version}/saga-${version}.tar.gz";
    sha256 = "1008l8f4733vsxy3y6d1yg8m4h8pp65d2p48ljc9kp5nyrg5vfy5";
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
    wxGTK31-gtk3
    proj
    libharu
    opencv
    vigra
    postgresql
    libiodbc
    lzma
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
