{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libnoise";
  version = "0-unstable-2024-09-01";

  src = fetchFromGitHub {
    owner = "qknight";
    repo = "libnoise";
    rev = "9ce0737b55812f7de907e86dc633724524e3a8e8";
    hash = "sha256-coazd4yedH69b+TOSTFV1CEzN0ezjoGyOaYR9QBhp2E=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" true)
  ];

  meta = {
    description = "Portable, open-source, coherent noise-generating library for C++";
    homepage = "https://github.com/qknight/libnoise";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ liberodark ];
  };
})
