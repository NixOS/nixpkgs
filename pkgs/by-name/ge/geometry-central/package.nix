{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  eigen,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "geometry-central";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "nmwsharp";
    repo = "geometry-central";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ipQoLqieAp1KImfCMnUxaqq+7R1//HuNeNlhRkbDt9U=";
    fetchSubmodules = true;
  };

  __structuredAttrs = true;

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    ninja
  ];

  propagatedBuildInputs = [
    eigen
  ];

  cmakeFlags = [
    (lib.cmakeOptionType "path" "GC_EIGEN_LOCATION" "${lib.getDev eigen}/include/eigen3")
    (lib.cmakeBool "SUITESPARSE" false)
  ];

  meta = {
    description = "Geometry-central is a modern C++ library of data structures and algorithms for geometry processing, with a particular focus on surface meshes.";
    longDescription = ''
      Geometry-central is a modern C++ library of data structures and algorithms for geometry processing, with a particular focus on surface meshes.

      Features include:

      - A polished surface mesh class, with efficient support for mesh modification, and a system of containers for associating data with mesh elements.
      - Implementations of canonical geometric quantities on surfaces, ranging from normals and curvatures to tangent vector bases to operators from discrete differential geometry.
      - A suite of powerful algorithms, including computing distances on surface, generating direction fields, and manipulating intrinsic Delaunay triangulations.
      - A coherent set of sparse linear algebra tools, based on Eigen and augmented to automatically utilize better solvers if available on your system.
    '';
    homepage = "https://geometry-central.net";
    changelog = "https://github.com/nmwsharp/geometry-central/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      nmwsharp
      liamnwhite1
    ];
    platforms = lib.platforms.unix;
  };
})
