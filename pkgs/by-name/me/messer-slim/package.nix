{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gcc,
  gcc-unwrapped,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "5.2";
  pname = "messer-slim";

  src = fetchFromGitHub {
    owner = "MesserLab";
    repo = "SLiM";
    rev = "v${finalAttrs.version}";
    hash = "sha256-gZd++3puztnjFjnc0GlkpZWG2oZlzY4I+8fOW5G8vWY=";
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
})
