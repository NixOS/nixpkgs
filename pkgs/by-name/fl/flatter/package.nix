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
  version = "0-unstable-2024-03-04";

  src = fetchFromGitHub {
    owner = "keeganryan";
    repo = "flatter";
    rev = "c2ed0ee94b6d281df7bcbce31ca275197ef9a562";
    hash = "sha256-1Pjn0lANXaMOqlwwdOx6X/7jtAvfa2ZWa0nDfS3T5XU=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
  ];

  buildInputs =
    [
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
    description = "(F)ast (lat)tice (r)eduction of integer lattice bases";
    homepage = "https://github.com/keeganryan/flatter";
    license = lib.licenses.lgpl3Only;
    mainProgram = "flatter";
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ josephsurin ];
  };
}
