{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation {
  pname = "jrl-cmakemodules";
  version = "0-unstable-2024-11-20";

  src = fetchFromGitHub {
    owner = "jrl-umi3218";
    repo = "jrl-cmakemodules";
    rev = "29c0eb4e659304f44d55a0389e2749812d858659";
    hash = "sha256-a23x0IIvIXJAsi8Z2/ku63hrHuSEC45FqzhxCy/T5tw=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "CMake utility toolbox";
    homepage = "https://github.com/jrl-umi3218/jrl-cmakemodules";
    license = licenses.lgpl3Plus;
    maintainers = [ maintainers.nim65s ];
    platforms = platforms.all;
  };
}
