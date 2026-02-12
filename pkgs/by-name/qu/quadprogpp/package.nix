{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation {
  pname = "quadprogpp";
  version = "1.2.2-unstable-2025-12-03";

  src = fetchFromGitHub {
    owner = "liuq";
    repo = "QuadProgpp";
    rev = "0c25447365c980876fdc395f55d60300a5e5793c";
    hash = "sha256-yXKctOTBbUNiSM2j7hKfSvd1i7FH7kcgP990DXVkrRY=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    description = "C++ library for Quadratic Programming";
    longDescription = ''
      QuadProg++ is a C++ library for Quadratic Programming which implements
      the Goldfarb-Idnani active-set dual method.
    '';
    homepage = "https://github.com/liuq/QuadProgpp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wegank ];
    platforms = lib.platforms.all;
  };
}
