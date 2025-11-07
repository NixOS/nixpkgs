{
  stdenv,
  lib,
  fetchFromGitHub,
  gfortran,
  pkg-config,
  blas,
  zlib,
  bzip2,
  coin-utils,
  withGurobi ? false,
  gurobi,
  withCplex ? false,
  cplex,
}:

stdenv.mkDerivation rec {
  pname = "osi";
  version = "0.108.11";

  src = fetchFromGitHub {
    owner = "coin-or";
    repo = "Osi";
    rev = "releases/${version}";
    hash = "sha256-3aTO7JGEOP/RCOZ1X9b68rrtv6T78euf1TYGTjyXSRE=";
  };

  buildInputs = [
    blas
    zlib
    bzip2
    coin-utils
  ]
  ++ lib.optional withGurobi gurobi
  ++ lib.optional withCplex cplex;
  nativeBuildInputs = [
    gfortran
    pkg-config
  ];
  configureFlags =
    lib.optionals withGurobi [
      "--with-gurobi-incdir=${gurobi}/include"
      "--with-gurobi-lib=-lgurobi${gurobi.libSuffix}"
    ]
    ++ lib.optionals withCplex [
      "--with-cplex-incdir=${cplex}/cplex/include/ilcplex"
      "--with-cplex-lib=-lcplex${cplex.libSuffix}"
    ];

  NIX_LDFLAGS = lib.optionalString withCplex "-L${cplex}/cplex/bin/${cplex.libArch}";

  # Compile errors
  env.NIX_CFLAGS_COMPILE = "-Wno-cast-qual";
  hardeningDisable = [ "format" ];

  enableParallelBuilding = true;

  passthru = { inherit withGurobi withCplex; };

  meta = with lib; {
    description = "Abstract base class to a generic linear programming (LP) solver";
    homepage = "https://github.com/coin-or/Osi";
    license = licenses.epl20;
    platforms = platforms.unix;
    maintainers = [ ];
  };
}
