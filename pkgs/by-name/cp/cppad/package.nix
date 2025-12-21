{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cppad";
  version = "20250000.3";

  src = fetchFromGitHub {
    owner = "coin-or";
    repo = "CppAD";
    tag = finalAttrs.version;
    hash = "sha256-nxndrOAgmEbMSVLz66E3X/r35NSgiOvNJnF9BY/IOd0=";
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
