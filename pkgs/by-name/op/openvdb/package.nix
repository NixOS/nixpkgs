{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
  jemalloc,
  c-blosc,
  tbb,
  zlib,
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

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    boost
    tbb
    jemalloc
    c-blosc
    zlib
  ];

  cmakeFlags = [
    "-DOPENVDB_CORE_STATIC=OFF"
    "-DOPENVDB_BUILD_NANOVDB=ON"
  ];

  postFixup = ''
    substituteInPlace $dev/lib/cmake/OpenVDB/FindOpenVDB.cmake \
      --replace \''${OPENVDB_LIBRARYDIR} $out/lib \
      --replace \''${OPENVDB_INCLUDEDIR} $dev/include
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
