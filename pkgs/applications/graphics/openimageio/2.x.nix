{ stdenv
, fetchFromGitHub
, boost
, cmake
, ilmbase
, libjpeg
, libpng
, libtiff
, opencolorio
, openexr
, robin-map
, unzip
}:

stdenv.mkDerivation rec {
  pname = "openimageio";
  version = "2.0.11";

  src = fetchFromGitHub {
    owner = "OpenImageIO";
    repo = "oiio";
    rev = "Release-${version}";
    sha256 = "1kasp9as81wjvys9qrx10mgdf9bjbdgryhdgjqn05zdmv2rs95nc";
  };

  outputs = [ "bin" "out" "dev" "doc" ];

  nativeBuildInputs = [
    cmake
    unzip
  ];

  buildInputs = [
    boost
    ilmbase
    libjpeg
    libpng
    libtiff
    opencolorio
    openexr
    robin-map
  ];

  cmakeFlags = [
    "-DUSE_PYTHON=OFF"
    "-DUSE_QT=OFF"
    # GNUInstallDirs
    "-DCMAKE_INSTALL_LIBDIR=lib" # needs relative path for pkgconfig
  ];

  meta = with stdenv.lib; {
    homepage = http://www.openimageio.org;
    description = "A library and tools for reading and writing images";
    license = licenses.bsd3;
    maintainers = with maintainers; [ goibhniu jtojnar ];
    platforms = platforms.unix;
  };
}
