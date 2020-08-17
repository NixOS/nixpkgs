{ mkDerivation
, stdenv
, fetchFromGitHub
# native
, cmake
, extra-cmake-modules
# not native
, qtserialport
, kconfig
, syntax-highlighting
, karchive
, kcrash
, kconfigwidgets
, knewstuff
, kparts
, gsl
, liborigin
, hdf5
, fftw
, netcdf
, lz4
, libzip
, cfitsio
, libcerf
, shared-mime-info
, poppler
, cantor
}:

mkDerivation rec {
  pname = "labplot";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "KDE";
    repo = "labplot";
    rev = version;
    sha256 = "1h5qxkn3gkkx5x49zg260irdfznca9x9rqjm3b21dqp6nfk80dwk";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];
  buildInputs = [
    qtserialport
    liborigin
    hdf5
    fftw
    netcdf
    gsl
    lz4
    libzip
    libcerf
    cfitsio
    shared-mime-info
    cantor
    poppler
  ];

  propagatedBuildInputs = [
    kconfig
    syntax-highlighting
    kconfigwidgets
    knewstuff
    kparts
    karchive
    kcrash
  ];

  meta = with stdenv.lib; {
    license = with stdenv.lib.licenses; [ gpl2 lgpl21 fdl12 ];
    homepage = "https://labplot.kde.org/";
    description = "Application for interactive graphing and analysis of scientific data";
    maintainers = with maintainers; [ doronbehar ];
    platforms = platforms.linux;
  };
}

