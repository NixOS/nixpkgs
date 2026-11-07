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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openvdb";
  version = "13.2.0";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "AcademySoftwareFoundation";
    repo = "openvdb";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4rB4Vl8DYJCIJggezXFZAYaEW5ci4PkAqnyQ8o1g0cY=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    boost
    onetbb
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

  meta = {
    description = "Open framework for voxel";
    mainProgram = "vdb_print";
    homepage = "https://www.openvdb.org";
    maintainers = [ lib.maintainers.guibou ];
    platforms = lib.platforms.unix;
    license = lib.licenses.asl20;
  };
})
