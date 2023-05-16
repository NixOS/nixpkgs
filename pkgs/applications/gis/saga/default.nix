{ stdenv
<<<<<<< HEAD
=======
, mkDerivation
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, lib
, fetchurl
# native
, cmake
<<<<<<< HEAD
, desktopToDarwinBundle
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
stdenv.mkDerivation rec {
  pname = "saga";
  version = "9.1.1";

  src = fetchurl {
    url = "mirror://sourceforge/saga-gis/saga-${version}.tar.gz";
    sha256 = "sha256-VXupgjoiexZZ1kLXAbbQMW7XQ7FWjd1ejZPeeTffUhM=";
=======
mkDerivation rec {
  pname = "saga";
  version = "9.0.1";

  src = fetchurl {
    url = "mirror://sourceforge/saga-gis/SAGA%20-%20${lib.versions.major version}/SAGA%20-%20${version}/saga-${version}.tar.gz";
    sha256 = "sha256-8S8Au+aLwl8X0GbqPPv2Q6EL98KSoT665aILc5vcbpA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  sourceRoot = "saga-${version}/saga-gis";

  nativeBuildInputs = [
    cmake
    pkg-config
<<<<<<< HEAD
  ] ++ lib.optional stdenv.isDarwin desktopToDarwinBundle;
=======
  ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
<<<<<<< HEAD
    homepage = "https://saga-gis.sourceforge.io";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; teams.geospatial.members ++ [ michelk mpickering ];
=======
    homepage = "http://www.saga-gis.org";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ michelk mpickering ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = with platforms; unix;
  };
}
