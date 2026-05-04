{
  lib,
  boost,
  bzip2,
  cmake,
  enablePython ? true,
  fetchFromGitHub,
  fmt,
  giflib,
  libheif,
  libjpeg,
  libjxl,
  libpng,
  libtiff,
  libultrahdr,
  libwebp,
  opencolorio,
  openexr,
  openjph,
  ptex,
  python3Packages,
  robin-map,
  stdenv,
  unzip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openimageio";
  version = "3.1.13.1";

  src = fetchFromGitHub {
    owner = "AcademySoftwareFoundation";
    repo = "OpenImageIO";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GlQ4e0YGHqQxlwcyC8SVf4y0mKZiEyaT4jtxw0Pva4U=";
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
    bzip2
    giflib
    libheif
    libjpeg
    libjxl
    libpng
    libtiff
    libwebp
    libultrahdr
    opencolorio
    openexr
    openjph
    ptex
    robin-map
  ]
  ++ lib.optional enablePython python3Packages.pybind11;

  propagatedBuildInputs = [
    fmt
  ];

  cmakeFlags = [
    (lib.cmakeBool "USE_PYTHON" enablePython)
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
