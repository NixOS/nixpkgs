{ lib, stdenv
, fetchFromGitHub
, fetchpatch
, boost
, cmake
, giflib
, ilmbase
, libjpeg
, libpng
, libtiff
, opencolorio
, openexr
, robin-map
, unzip
, fmt
}:

stdenv.mkDerivation rec {
  pname = "openimageio";
  version = "2.4.6.1";

  src = fetchFromGitHub {
    owner = "OpenImageIO";
    repo = "oiio";
    rev = "v${version}";
    sha256 = "sha256-oBICukkborxXFHXyM2rIn5qSbCWECjwDQI9MUg13IRU=";
  };

  patches = [
    (fetchpatch {
      name = "arm-fix-signed-unsigned-simd-mismatch.patch";
      url = "https://github.com/OpenImageIO/oiio/commit/726c51181a2888b0bd1edbef5ac8451e9cc3f893.patch";
      hash = "sha256-G4vexf0OHZ/sbcRob5X92tajkmAv72ok8rcVQtIE9XE=";
    })
  ];

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
    opencolorio
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
    homepage = "https://openimageio.org";
    description = "A library and tools for reading and writing images";
    license = licenses.bsd3;
    maintainers = with maintainers; [ goibhniu ];
    platforms = platforms.unix;
  };
}
