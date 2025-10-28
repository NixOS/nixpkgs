{
  blas,
  blasfeo,
  cmake,
  fetchFromGitHub,
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hpipm";
  #version = "0.1.3";  not building, use master instead
  version = "0.1.3-unstable-2025-07-25";

  src = fetchFromGitHub {
    owner = "giaf";
    repo = "hpipm";
    rev = "00c2a084e059e2e1b79877f668e282d0c4282110";
    hash = "sha256-Lg7po7xTs9jc8FiYFMbNFJooTjOpzBFiyd5f+TPMWQA=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    blas
    blasfeo
  ];

  cmakeFlags = [
    "-DHPIPM_FIND_BLASFEO=ON"
    "-DBUILD_SHARED_LIBS=ON"
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isx86_64) [ "-DTARGET=GENERIC" ];

  meta = {
    description = "High-performance interior-point-method QP and QCQP solvers";
    homepage = "https://github.com/giaf/hpipm";
    changelog = "https://github.com/giaf/hpipm/blob/${finalAttrs.src.rev}/Changelog.txt";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ nim65s ];
  };
})
