{
  lib,
  stdenv,
  fetchFromGitHub,
  unstableGitUpdater,
  cmake,
  blas,
  gmp,
  mpfr,
  fplll,
  eigen,
  llvmPackages,
}:

stdenv.mkDerivation {
  pname = "flatter";
  version = "0-unstable-2025-08-12";

  src = fetchFromGitHub {
    owner = "keeganryan";
    repo = "flatter";
    rev = "7757f6c1166ce5feda1cb829736976b8d20741fc";
    hash = "sha256-n/JtSdX8kZIEXcxj344APRo7fuRIR8+ZeUnk7QX8f3Q=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    blas
    gmp
    mpfr
    fplll
    eigen
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    llvmPackages.openmp
  ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Fast lattice reduction of integer lattice bases";
    homepage = "https://github.com/keeganryan/flatter";
    license = lib.licenses.lgpl3Only;
    mainProgram = "flatter";
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ josephsurin ];
  };
}
