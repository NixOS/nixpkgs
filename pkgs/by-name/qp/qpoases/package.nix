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
    repo = finalAttrs.pname;
    rev = "releases/${finalAttrs.version}";
    sha256 = "sha256-NWKwKYdXJD8lGorhTFWJmYeIhSCO00GHiYx+zHEJk0M=";
  };

  patches = [
    (fetchpatch {
      name = "shared-libs.patch";
      url = "https://github.com/coin-or/qpOASES/pull/109/commits/cb49b52c17e0b638c88ff92f4c59e347cd82a332.patch";
      sha256 = "sha256-6IoJHCFVCZpf3+Im1f64VwV5vj+bbbwCSF0vqpdd5Os=";
    })
  ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
  ];

  meta = with lib; {
    description = "Open-source C++ implementation of the recently proposed online active set strategy";
    homepage = "https://github.com/coin-or/qpOASES";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ nim65s ];
  };
})
