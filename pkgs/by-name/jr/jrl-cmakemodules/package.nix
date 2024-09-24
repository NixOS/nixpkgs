{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation {
  pname = "jrl-cmakemodules";
  version = "0-unstable-2024-09-17";

  src = fetchFromGitHub {
    owner = "jrl-umi3218";
    repo = "jrl-cmakemodules";
    rev = "31e46019beda968ba9e516ad645a951c64256eed";
    hash = "sha256-pe21tE0ngUYGhEuGSI71TMdwyqTmZhc53hPKHngkTGQ=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "CMake utility toolbox";
    homepage = "https://github.com/jrl-umi3218/jrl-cmakemodules";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.all;
  };
}
