{
  blas,
  gnumake,
  fetchFromGitHub,
  gfortran,
  lapack,
  lib,
  stdenv,
}:

stdenv.mkDerivation {
  pname = "primme";
  version = "3.3-pre";

  src = fetchFromGitHub {
    owner = "primme";
    repo = "primme";
    rev = "5dd94e36cfaaccf524d02d495f72b992609e59fb";
    hash = "sha256-4LJr6TmrA0ZYKzHQigNd0mF5ZucPDF0KjEt9HUkwxmc=";
  };

  strictDeps = true;

  preConfigure =
    ''
      export PREFIX=$out
    ''
    + lib.optionalString blas.isILP64 ''
      export CFLAGS="$CFLAGS -DPRIMME_BLASINT_SIZE=64"
    '';

  nativeBuildInputs = [
    gnumake
    gfortran
  ];
  buildInputs = [
    blas
    lapack
  ];

  enableParallelBuilding = true;
  doCheck = stdenv.hostPlatform == stdenv.buildPlatform;

  meta = with lib; {
    description = "PReconditioned Iterative MultiMethod Eigensolver for solving symmetric/Hermitian eigenvalue problems and singular value problems";
    homepage = "https://www.cs.wm.edu/~andreas/software/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ twesterhout ];
  };
}
