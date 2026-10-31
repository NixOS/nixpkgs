{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
  dcmtk,
  ffmpeg,
  fmt,
  freetype,
  giflib,
  libheif,
  libjpeg_turbo,
  libpng,
  libraw,
  libtiff,
  libwebp,
  onetbb,
  opencolorio,
  opencv,
  openexr,
  openjpeg,
  openvdb,
  ptex,
  robin-map,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openimageio";
  version = "2.5.19.1";

  src = fetchFromGitHub {
    owner = "AcademySoftwareFoundation";
    repo = "OpenImageIO";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+KreH4JoyX64Z3LMfTiyf96YL1msXpiELvcpiCziGNs=";
  };

  outputs = [
    "bin"
    "out"
    "dev"
    "doc"
  ];

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    boost
    dcmtk
    ffmpeg
    freetype
    giflib
    libheif
    libjpeg_turbo
    libpng
    libraw
    libtiff
    libwebp
    onetbb
    opencolorio
    opencv
    openexr
    openjpeg
    openvdb
    ptex
    robin-map
    zlib
  ];

  propagatedBuildInputs = [
    fmt
  ];

  cmakeFlags = [
    (lib.cmakeBool "USE_PYTHON" false)
    (lib.cmakeBool "USE_QT" false)
    (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib") # needs relative path for pkg-config
    (lib.cmakeBool "INTERNALIZE_FMT" false) # Do not install a copy of fmt header files
  ];

  postFixup = ''
    substituteInPlace $dev/lib/cmake/OpenImageIO/OpenImageIOTargets-*.cmake \
      --replace "\''${_IMPORT_PREFIX}/lib/lib" "$out/lib/lib"
  '';

  meta = {
    description = "Library and tools for reading and writing images";
    homepage = "https://openimageio.org";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      wishstudio
    ];
    platforms = lib.platforms.unix;
  };
})
