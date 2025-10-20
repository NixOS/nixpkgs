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

stdenv.mkDerivation rec {
  pname = "ipopt";
  version = "3.14.19";

  src = fetchFromGitHub {
    owner = "coin-or";
    repo = "Ipopt";
    rev = "releases/${version}";
    sha256 = "sha256-85fUBMwQtG+RWQYk9YzdZYK3CYcDKgWroo4blhVWBzE=";
  };

  configureFlags =
    lib.optionals enableAMPL [
      "--with-asl-lflags=-lamplsolver"
    ]
    ++ lib.optionals enableMUMPS [
      "--with-mumps-cflags=-I${lib.getDev mumps}/include/mumps_seq"
      "--with-mumps-lflags=-ldmumps"
    ]
    ++ lib.optionals enableSPRAL [
      "--with-spral-lflags=-lspral"
    ];

  nativeBuildInputs = [
    pkg-config
    gfortran
  ];
  buildInputs = [
    blas
    lapack
  ]
  ++ lib.optionals enableAMPL [ libamplsolver ]
  ++ lib.optionals enableMUMPS [ mumps ]
  ++ lib.optionals enableSPRAL [ spral ];

  enableParallelBuilding = true;

  meta = {
    description = "Software package for large-scale nonlinear optimization";
    homepage = "https://projects.coin-or.org/Ipopt";
    license = lib.licenses.epl10;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      nim65s
      qbisi
    ];
  };
}
