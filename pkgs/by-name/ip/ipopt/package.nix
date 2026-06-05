{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  blas,
  lapack,
  gfortran,
  enableAMPL ? true,
  libamplsolver,
  enableMUMPS ? true,
  mumps,
  enableSPRAL ? true,
  spral,
}:

assert (!blas.isILP64) && (!lapack.isILP64);
assert !mumps.mpiSupport;

stdenv.mkDerivation (finalAttrs: {
  pname = "ipopt";
  version = "3.14.19";

  src = fetchFromGitHub {
    owner = "coin-or";
    repo = "Ipopt";
    rev = "releases/${finalAttrs.version}";
    sha256 = "sha256-85fUBMwQtG+RWQYk9YzdZYK3CYcDKgWroo4blhVWBzE=";
  };

  outputs =
    # The solver executables for AMPL modeling environment are only installed
    # when AMPL is available.
    lib.optional enableAMPL "bin" ++ [
      "out"
      "dev"
      "doc"
    ];

  nativeBuildInputs = [
    pkg-config
    gfortran
  ];

  buildInputs = [
    blas
    lapack
  ]
  ++ lib.optional enableMUMPS mumps
  ++ lib.optional enableSPRAL spral
  ++ lib.optional enableAMPL libamplsolver;

  configureFlags =
    lib.optionals enableMUMPS [
      "--with-mumps-cflags=-I${lib.getDev mumps}/include/mumps_seq"
      "--with-mumps-lflags=-ldmumps"
    ]
    ++ lib.optional enableSPRAL "--with-spral-lflags=-lspral"
    ++ lib.optional enableAMPL "--with-asl-lflags=-lamplsolver";

  enableParallelBuilding = true;

  meta = {
    description = "Software package for large-scale nonlinear optimization";
    homepage = "https://projects.coin-or.org/Ipopt";
    license = lib.licenses.epl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      nim65s
      qbisi
    ];
  };
})
