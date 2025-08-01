{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gcc,
  gcc-unwrapped,
}:

stdenv.mkDerivation rec {
  version = "5.0";
  pname = "messer-slim";

  src = fetchFromGitHub {
    owner = "MesserLab";
    repo = "SLiM";
    rev = "v${version}";
    hash = "sha256-fouZI5Uc8pY7eXD9Tm1C66j3reu7kijTEGA402bOJwc=";
  };

  nativeBuildInputs = [
    cmake
    gcc
    gcc-unwrapped
  ];

  cmakeFlags = [
    "-DCMAKE_AR=${gcc-unwrapped}/bin/gcc-ar"
    "-DCMAKE_RANLIB=${gcc-unwrapped}/bin/gcc-ranlib"
  ];

  meta = {
    description = "Evolutionary simulation framework";
    homepage = "https://messerlab.org/slim/";
    license = with lib.licenses; [ gpl3 ];
    maintainers = with lib.maintainers; [ bzizou ];
    platforms = lib.platforms.all;
  };
}
