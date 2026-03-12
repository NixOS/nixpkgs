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

stdenv.mkDerivation (finalAttrs: {
  pname = "osi";
  version = "0.108.12";

  src = fetchFromGitHub {
    owner = "coin-or";
    repo = "Osi";
    rev = "releases/${finalAttrs.version}";
    hash = "sha256-58wG0S3tkDfFUKTVcDQg4Ft2gGmnZHNoHXaWVoWdR0Y=";
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

  env = {
    # Compile errors
    NIX_CFLAGS_COMPILE = "-Wno-cast-qual";
  }
  // lib.optionalAttrs withCplex {
    NIX_LDFLAGS = "-L${cplex}/cplex/bin/${cplex.libArch}";
  };

  hardeningDisable = [ "format" ];

  enableParallelBuilding = true;

  passthru = { inherit withGurobi withCplex; };

  meta = {
    description = "Abstract base class to a generic linear programming (LP) solver";
    homepage = "https://github.com/coin-or/Osi";
    license = lib.licenses.epl20;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})
