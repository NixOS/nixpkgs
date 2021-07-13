{ lib, stdenv
, fetchFromGitHub
, boost
, cmake
, giflib
, ilmbase
, libjpeg
, libpng
, libtiff
, opencolorio_1
, openexr
, robin-map
, unzip
, fmt
}:

stdenv.mkDerivation rec {
  pname = "openimageio";
  version = "2.2.12.0";

  src = fetchFromGitHub {
    owner = "OpenImageIO";
    repo = "oiio";
    rev = "Release-${version}";
    sha256 = "16z8lnsqhljbfaarfwx9rc95p0a9wxf4p271j6kxdfknjb88p56i";
  };

  outputs = [ "bin" "out" "dev" "doc" ];

  nativeBuildInputs = [
    cmake
    unzip
  ];

  buildInputs = [
    boost
    giflib
    ilmbase
    libjpeg
    libpng
    libtiff
    opencolorio_1
    openexr
    robin-map
    fmt
  ];

  cmakeFlags = [
    "-DUSE_PYTHON=OFF"
    "-DUSE_QT=OFF"
    # GNUInstallDirs
    "-DCMAKE_INSTALL_LIBDIR=lib" # needs relative path for pkg-config
  ];

  meta = with lib; {
    homepage = "http://www.openimageio.org";
    description = "A library and tools for reading and writing images";
    license = licenses.bsd3;
    maintainers = with maintainers; [ goibhniu jtojnar ];
    platforms = platforms.unix;
  };
}
