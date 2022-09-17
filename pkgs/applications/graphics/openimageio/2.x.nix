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
  version = "2.2.17.0";

  src = fetchFromGitHub {
    owner = "OpenImageIO";
    repo = "oiio";
    rev = "Release-${version}";
    sha256 = "0jqpb1zci911wdm928addsljxx8zsh0gzbhv9vbw6man4wi93h6h";
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

  postFixup = ''
    substituteInPlace $dev/lib/cmake/OpenImageIO/OpenImageIOTargets-*.cmake \
      --replace "\''${_IMPORT_PREFIX}/lib/lib" "$out/lib/lib"
  '';

  meta = with lib; {
    homepage = "http://www.openimageio.org";
    description = "A library and tools for reading and writing images";
    license = licenses.bsd3;
    maintainers = with maintainers; [ goibhniu jtojnar ];
    platforms = platforms.unix;
  };
}
