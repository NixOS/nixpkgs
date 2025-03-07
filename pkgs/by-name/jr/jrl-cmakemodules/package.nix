{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation {
  pname = "jrl-cmakemodules";
  version = "0-unstable-2024-05-22";

  src = fetchFromGitHub {
    owner = "jrl-umi3218";
    repo = "jrl-cmakemodules";
    rev = "dd3e4127f2b223496859fe05be02726e9d1a071b";
    hash = "sha256-ySMfops0Py1U+50LEGwgIwlzPUq/miusTxK7TIpQQXs=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "CMake utility toolbox";
    homepage = "https://github.com/jrl-umi3218/jrl-cmakemodules";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ lib.maintainers.nim65s ];
  };
}
