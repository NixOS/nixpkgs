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
  version = "0-unstable-2025-02-03";

  src = fetchFromGitHub {
    owner = "keeganryan";
    repo = "flatter";
    rev = "96993e47874c302395721d76d06f7ab4fee09839";
    hash = "sha256-eMZZsgLeTzMAHohmvR13KQERtYQpB2nj/v5MCKtGFaI=";
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

  meta = with lib; {
    description = "(F)ast (lat)tice (r)eduction of integer lattice bases";
    homepage = "https://github.com/keeganryan/flatter";
    license = licenses.lgpl3Only;
    mainProgram = "flatter";
    platforms = platforms.all;
    maintainers = with maintainers; [ josephsurin ];
  };
}
