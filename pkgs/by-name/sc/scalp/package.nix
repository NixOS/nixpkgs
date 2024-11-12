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
}:

stdenv.mkDerivation rec {
  pname = "scalp";
  version = "unstable-2022-03-15";

  src = fetchgit {
    url = "https://digidev.digi.e-technik.uni-kassel.de/git/scalp.git";
    # mirrored at https://git.sr.ht/~weijia/scalp
    rev = "185b84e4ff967f42cf2de5db4db4e6fa0cc18fb8";
    hash = "sha256-NyMZdJwdD3FR6uweYCclJjfcf3Y24Bns1ViwsmJ5izg=";
  };

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

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace CMakeLists.txt \
      --replace "\''$ORIGIN" "\''${CMAKE_INSTALL_PREFIX}/lib"
  '';

  cmakeFlags =
    [
      "-DBUILD_TESTS=${lib.boolToString doCheck}"
    ]
    ++ lib.optionals withGurobi [
      "-DGUROBI_DIR=${gurobi}"
    ]
    ++ lib.optionals withCplex [
      "-DCPLEX_DIR=${cplex}"
    ];

  doCheck = true;

  meta = with lib; {
    description = "Scalable Linear Programming Library";
    mainProgram = "scalp";
    homepage = "https://digidev.digi.e-technik.uni-kassel.de/scalp/";
    license = licenses.lgpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ wegank ];
  };
}
