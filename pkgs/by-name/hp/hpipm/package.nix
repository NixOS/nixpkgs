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
  version = "0.1.3-unstable-2025-09-25";

  src = fetchFromGitHub {
    owner = "giaf";
    repo = "hpipm";
    rev = "8f3a2d00f6d1bd7101fb651391fba79377915288";
    hash = "sha256-XtnUs1RiB7zJOv7zdRzB31hnxDYaiH+Q4SLyE6/kuEg=";
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
