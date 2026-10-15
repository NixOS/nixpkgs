{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  mpi,
  scalapack,
  llvmPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "COSTA";
  version = "2.3.3";

  src = fetchFromGitHub {
    owner = "eth-cscs";
    repo = "COSTA";
    rev = "v${finalAttrs.version}";
    hash = "sha256-6U0L5Bthcspv0McMEUWvb68+W+/oaAx2wvE5lVgqlKQ=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ scalapack ] ++ lib.optional stdenv.hostPlatform.isDarwin llvmPackages.openmp;

  propagatedBuildInputs = [ mpi ];

  cmakeFlags = [
    "-DCOSTA_SCALAPACK=CUSTOM"
    "-DSCALAPACK_ROOT=${scalapack}"
  ];

  meta = {
    description = "Distributed Communication-Optimal Shuffle and Transpose Algorithm";
    homepage = "https://github.com/eth-cscs/COSTA";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.sheepforce ];
  };
})
