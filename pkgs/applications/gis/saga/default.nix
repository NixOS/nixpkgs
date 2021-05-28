{ stdenv
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

stdenv.mkDerivation rec {
  pname = "saga";
  version = "7.7.0";

  src = fetchurl {
    url = "https://sourceforge.net/projects/saga-gis/files/SAGA%20-%20${stdenv.lib.versions.major version}/SAGA%20-%20${version}/saga-${version}.tar.gz";
    sha256 = "1nmvrlcpcm2pas9pnav13iydnym9d8yqqnwq47lm0j6b0a2wy9zk";
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
  ++ stdenv.lib.optionals stdenv.isDarwin [
    Cocoa
    unixODBC
    poppler
    netcdf
    sqlite
  ];

  patches = [
    # See https://sourceforge.net/p/saga-gis/bugs/280/
    ./opencv4.patch
  ];

  enableParallelBuilding = true;

  CXXFLAGS = stdenv.lib.optionalString stdenv.cc.isClang "-std=c++11 -Wno-narrowing";

  meta = with stdenv.lib; {
    description = "System for Automated Geoscientific Analyses";
    homepage = "http://www.saga-gis.org";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ michelk mpickering ];
    platforms = with platforms; unix;
  };
}
