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
  version = "0-unstable-2025-03-28";

  src = fetchFromGitHub {
    owner = "keeganryan";
    repo = "flatter";
    rev = "13c4ef0f0abe7ad5db88b19a9196c00aa5cf067c";
    hash = "sha256-k0FcIJARaXi602eqMSum+q1IaCs30Xi0hB/ZNNkXruw=";
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

  meta = with lib; {
    description = "(F)ast (lat)tice (r)eduction of integer lattice bases";
    homepage = "https://github.com/keeganryan/flatter";
    license = licenses.lgpl3Only;
    mainProgram = "flatter";
    platforms = platforms.all;
    maintainers = with maintainers; [ josephsurin ];
  };
}
