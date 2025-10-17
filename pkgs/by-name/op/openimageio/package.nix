{
  lib,
  stdenv,
  fetchFromGitHub,
  boost,
  cmake,
  giflib,
  libjpeg,
  libpng,
  libtiff,
  libwebp,
  libjxl,
  libheif,
  opencolorio,
  openexr,
  openjph,
  robin-map,
  unzip,
  fmt,
  bzip2,
  ptex,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openimageio";
  version = "3.1.6.2";

  src = fetchFromGitHub {
    owner = "AcademySoftwareFoundation";
    repo = "OpenImageIO";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0AfkJXFn+dEPUJF4GJq6Gk5vBJDRPL2Z03dVa5+xKVA=";
  };

  outputs = [
    "bin"
    "out"
    "dev"
    "doc"
  ];

  nativeBuildInputs = [
    cmake
    unzip
  ];

  buildInputs = [
    boost
    giflib
    libheif
    libjpeg
    libjxl
    libpng
    libtiff
    libwebp
    opencolorio
    openexr
    openjph
    robin-map
    bzip2
    ptex
  ];

  propagatedBuildInputs = [
    fmt
  ];

  cmakeFlags = [
    "-DUSE_PYTHON=OFF"
    "-DUSE_QT=OFF"
    # GNUInstallDirs
    "-DCMAKE_INSTALL_LIBDIR=lib" # needs relative path for pkg-config
    # Do not install a copy of fmt header files
    "-DINTERNALIZE_FMT=OFF"
  ];

  postFixup = ''
    substituteInPlace $dev/lib/cmake/OpenImageIO/OpenImageIOTargets-*.cmake \
      --replace "\''${_IMPORT_PREFIX}/lib/lib" "$out/lib/lib"
  '';

  meta = {
    homepage = "https://openimageio.org";
    description = "Library and tools for reading and writing images";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ yzx9 ];
    platforms = lib.platforms.unix;
  };
})
