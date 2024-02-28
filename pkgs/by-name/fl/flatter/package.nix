{ lib
, stdenv
, fetchFromGitHub
, unstableGitUpdater
, cmake
, blas
, gmp
, mpfr
, fplll
, eigen
, llvmPackages
}:

stdenv.mkDerivation {
  pname = "flatter";
  version = "0-unstable-2023-08-10";

  src = fetchFromGitHub {
    owner = "keeganryan";
    repo = "flatter";
    rev = "500e31df6b7308e8101b2a4a9cc816bf8f483417";
    hash = "sha256-STYx7cXvkcF+KqrG32pN16HWfEScc0zxkmOmfv43zIw=";
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
  ] ++ lib.optionals stdenv.isDarwin [
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
