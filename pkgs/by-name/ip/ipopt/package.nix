{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  blas,
  lapack,
  gfortran,
  mumps,
  spral,
  libamplsolver,
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

  outputs = [
    "bin"
    "dev"
    "out"
    "doc"
  ];

  nativeBuildInputs = [
    pkg-config
    gfortran
  ];

  buildInputs = [
    blas
    lapack
    mumps
    spral
    libamplsolver
  ];

  configureFlags = [
    "--with-mumps-cflags=-I${lib.getDev mumps}/include/mumps_seq"
    "--with-mumps-lflags=-ldmumps"
    "--with-spral-lflags=-lspral"
    "--with-asl-lflags=-lamplsolver"
  ];

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
}
