{
  lib,
  stdenv,
  fetchFromGitHub,
  gfortran,
  suitesparse,
  blas,
  lapack,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "cholmod-extra";
  version = "1.2.0";

  src = fetchFromGitHub {
    repo = "cholmod-extra";
    owner = "jluttine";
    tag = finalAttrs.version;
    hash = "sha256-b9Z9+PeGuZFz+bfVGci1qHl4xrjvg90A3VmpD66j4UM=";
  };

  patches = [ ./cholmod-internal-suitesparse7.patch ];

  postPatch = ''
    substituteInPlace Include/cholmod_extra.h \
      --replace-fail "#include <cholmod_config.h>" "" \
      --replace-fail "#include <cholmod_core.h>" "#include <cholmod.h>" \
      --replace-fail "#include <cholmod_partition.h>" "" \
      --replace-fail "#include <cholmod_supernodal.h>" ""
    substituteInPlace Source/cholmod_spinv.c \
      --replace-fail "#include <cholmod_cholesky.h>" ""
  '';

  nativeBuildInputs = [ gfortran ];
  buildInputs = [
    suitesparse
    blas
    lapack
  ];

  makeFlags = [
    "BLAS=-lcblas"
  ];

  installFlags = [
    "INSTALL_LIB=$(out)/lib"
    "INSTALL_INCLUDE=$(out)/include"
  ];

  doCheck = true;

  meta = {
    homepage = "https://github.com/jluttine/cholmod-extra";
    description = "Set of additional routines for SuiteSparse CHOLMOD Module";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ jluttine ];
    platforms = with lib.platforms; unix;
  };

})
