{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gcc,
  gcc-unwrapped,
}:

stdenv.mkDerivation rec {
  version = "5.1";
  pname = "messer-slim";

  src = fetchFromGitHub {
    owner = "MesserLab";
    repo = "SLiM";
    rev = "v${version}";
    hash = "sha256-E1GxHdzY/5bxy8+ur3+/dheDOrmWaOrNcYDNSaY9cMU=";
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
