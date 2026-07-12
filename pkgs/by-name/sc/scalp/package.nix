{
  lib,
  stdenv,
  fetchgit,
  cmake,
  withGurobi ? false,
  gurobi,
  withCplex ? false,
  cplex,
  withLpsolve ? true,
  lp_solve,
  unstableGitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "scalp";
  version = "0-unstable-2026-06-29";

  src = fetchgit {
    url = "https://digidev.digi.e-technik.uni-kassel.de/git/scalp.git";
    # mirrored at https://git.sr.ht/~weijia/scalp
    rev = "91b4e52db746b0d25f6866143ee7a4a0defdeec5";
    hash = "sha256-0VKBdz/XU2Pd9fsKBga/2KBexCqs/DyUpih1Qx2JLeA=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required (VERSION 3.3.2)" "cmake_minimum_required (VERSION 3.5)" \
      --replace-fail "\''$ORIGIN" "\''${CMAKE_INSTALL_PREFIX}/lib" \
      --replace-fail "-m64" ""
    substituteInPlace src/tests/CMakeLists.txt \
      --replace-fail "src/tests/" ""
  ''
  + lib.optionalString withGurobi ''
    substituteInPlace CMakeExtensions/FindGurobi.cmake \
      --replace-fail "\''${GUROBI_VERSION}" '"${lib.versions.major gurobi.version}${lib.versions.minor gurobi.version}"'
  '';

  nativeBuildInputs = [
    cmake
  ];

  buildInputs =
    lib.optionals withGurobi [
      gurobi
    ]
    ++ lib.optionals withCplex [
      cplex
    ]
    ++ lib.optionals withLpsolve [
      lp_solve
    ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_TESTS" doCheck)
  ]
  ++ lib.optionals withGurobi [
    (lib.cmakeFeature "GUROBI_ROOT_DIR" "${gurobi}")
  ]
  ++ lib.optionals withCplex [
    (lib.cmakeFeature "CPLEX_ROOT_DIR" "${cplex}")
  ]
  ++ lib.optionals withLpsolve [
    (lib.cmakeFeature "LPSOLVE_ROOT_DIR" "${lp_solve}")
  ];

  doCheck = true;

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Scalable Linear Programming Library";
    mainProgram = "scalp";
    homepage = "https://digidev.digi.e-technik.uni-kassel.de/scalp/";
    license = lib.licenses.lgpl3Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ wegank ];
  };
}
