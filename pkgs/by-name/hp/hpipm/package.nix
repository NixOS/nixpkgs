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
  version = "0-unstable-2024-07-30";

  src = fetchFromGitHub {
    owner = "giaf";
    repo = "hpipm";
    rev = "3ab7d6059d9d7da31ec9ff6a8ca84fd8ec5ab5e2";
    hash = "sha256-TRNHjW2/YDfGJHTG9sy2nmHyk6+HlBGIabPm87TETE8=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    blas
    blasfeo
  ];

  cmakeFlags = [
    "-DHPIPM_FIND_BLASFEO=ON"
    "-DBUILD_SHARED_LIBS=ON"
  ] ++ lib.optionals (!stdenv.hostPlatform.isx86_64) [ "-DTARGET=GENERIC" ];

  meta = {
    description = "High-performance interior-point-method QP and QCQP solvers";
    homepage = "https://github.com/giaf/hpipm";
    changelog = "https://github.com/giaf/hpipm/blob/${finalAttrs.src.rev}/Changelog.txt";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ nim65s ];
  };
})
