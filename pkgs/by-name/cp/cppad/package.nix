{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cppad";
  version = "20260000.0";

  src = fetchFromGitHub {
    owner = "coin-or";
    repo = "CppAD";
    tag = finalAttrs.version;
    hash = "sha256-P8FUcW0AjMTqG7TVtdM6/v+ctyNQXJsImC26bpxz/i8=";
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
