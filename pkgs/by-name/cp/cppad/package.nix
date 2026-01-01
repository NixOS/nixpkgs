{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cppad";
<<<<<<< HEAD
  version = "20250000.3";
=======
  version = "20250000.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "coin-or";
    repo = "CppAD";
    tag = finalAttrs.version;
<<<<<<< HEAD
    hash = "sha256-nxndrOAgmEbMSVLz66E3X/r35NSgiOvNJnF9BY/IOd0=";
=======
    hash = "sha256-rAKD/PAjepDchvrJp7iLYw5doNq8Af1oVh61gfMcNYI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  meta = {
    description = "C++ Algorithmic Differentiation Package";
    homepage = "https://github.com/coin-or/CppAD";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      athas
    ];
  };
})
