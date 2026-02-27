{
  stdenv,
  fetchFromGitHub,
  lib,
  cmake,
  mpi,
  blas,
  lapack,
  scalapack,
  gfortran,
}:

assert !blas.isILP64;
assert !lapack.isILP64;

stdenv.mkDerivation (finalAttrs: {
  pname = "libMBD";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "libmbd";
    repo = "libMBD";
    rev = finalAttrs.version;
    hash = "sha256-mSKD/pNluumKP3SCubD68uak2Vya/1tyIh42UxRgSXY=";
  };

  preConfigure = ''
    cat > cmake/libMBDVersionTag.cmake << EOF
      set(VERSION_TAG "${finalAttrs.version}")
    EOF
  '';

  nativeBuildInputs = [
    cmake
    gfortran
  ];

  buildInputs = [
    blas
    lapack
    scalapack
  ];

  propagatedBuildInputs = [ mpi ];

  meta = {
    description = "Many-body dispersion library";
    homepage = "https://github.com/libmbd/libmbd";
    license = lib.licenses.mpl20;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.sheepforce ];
  };
})
