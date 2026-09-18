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
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "giaf";
    repo = "hpipm";
    tag = finalAttrs.version;
    hash = "sha256-URsO+QZwD+f5DgwWvknBNQGjDrhP0hUYJwynPQrg/BE=";
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

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    description = "High-performance interior-point-method QP and QCQP solvers";
    homepage = "https://github.com/giaf/hpipm";
    changelog = "https://github.com/giaf/hpipm/blob/${finalAttrs.src.rev}/Changelog.txt";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ nim65s ];
  };
})
