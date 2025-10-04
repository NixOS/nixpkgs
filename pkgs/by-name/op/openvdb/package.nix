{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
  jemalloc,
  c-blosc,
  onetbb,
  zlib,
  python3Packages,
}:

stdenv.mkDerivation rec {
  pname = "openvdb";
  version = "12.1.0";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "AcademySoftwareFoundation";
    repo = "openvdb";
    tag = "v${version}";
    hash = "sha256-28vrIlruPl1tvw2JhjIAARtord45hqCqnA9UNnu4Z70=";
  };

  nativeBuildInputs = [
    cmake
    python3Packages.nanobind
  ];

  buildInputs = [
    boost
    onetbb
    jemalloc
    c-blosc
    zlib
  ];

  cmakeFlags = [
    "-DOPENVDB_BUILD_PYTHON_MODULE=ON"
    "-DUSE_NUMPY=ON"
    "-DOPENVDB_PYTHON_WRAP_ALL_GRID_TYPES=ON"
    "-DOPENVDB_CORE_STATIC=OFF"
    "-DOPENVDB_BUILD_NANOVDB=ON"
    "-Dnanobind_DIR=${python3Packages.nanobind}/${python3Packages.python.sitePackages}/nanobind/cmake"
  ];

  postFixup = ''
    substituteInPlace $dev/lib/cmake/OpenVDB/FindOpenVDB.cmake \
      --replace-fail \''${OPENVDB_LIBRARYDIR} $out/lib \
      --replace-fail \''${OPENVDB_INCLUDEDIR} $dev/include
  '';

  meta = with lib; {
    description = "Open framework for voxel";
    mainProgram = "vdb_print";
    homepage = "https://www.openvdb.org";
    maintainers = [ maintainers.guibou ];
    platforms = platforms.unix;
    license = licenses.asl20;
  };
}
