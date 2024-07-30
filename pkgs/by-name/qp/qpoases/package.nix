{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qpoases";
  version = "3.2.1";

  src = fetchFromGitHub {
    owner = "coin-or";
    repo = "qpOASES";
    rev = "releases/${finalAttrs.version}";
    hash = "sha256-NWKwKYdXJD8lGorhTFWJmYeIhSCO00GHiYx+zHEJk0M=";
  };

  patches = [
    # Allow building as shared library.
    # This was merged upstream, and can be removed on next version
    (fetchpatch {
      name = "shared-libs.patch";
      url = "https://github.com/coin-or/qpOASES/pull/109/commits/cb49b52c17e0b638c88ff92f4c59e347cd82a332.patch";
      hash = "sha256-6IoJHCFVCZpf3+Im1f64VwV5vj+bbbwCSF0vqpdd5Os=";
    })
  ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
  ];

  meta = with lib; {
    description = "Open-source C++ implementation of the recently proposed online active set strategy";
    homepage = "https://github.com/coin-or/qpOASES";
    changelog = "https://github.com/coin-or/qpOASES/blob/${finalAttrs.src.rev}/VERSIONS.txt";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ nim65s ];
  };
})
