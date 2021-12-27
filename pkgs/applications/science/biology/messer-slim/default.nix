{ lib, stdenv, fetchFromGitHub, cmake, gcc, gcc-unwrapped }:

stdenv.mkDerivation rec {
  version = "3.6";
  pname = "messer-slim";

  src = fetchFromGitHub {
    owner = "MesserLab";
    repo = "SLiM";
    rev = "v${version}";
    sha256 = "sha256-TSbGUfr8YzTRYTkbMfM2+K04Z3h5W4jakw+V4axOKm8=";
  };

  nativeBuildInputs = [ cmake gcc gcc-unwrapped ];

  cmakeFlags = [ "-DCMAKE_AR=${gcc-unwrapped}/bin/gcc-ar"
                 "-DCMAKE_RANLIB=${gcc-unwrapped}/bin/gcc-ranlib" ];

  meta = {
     description = "An evolutionary simulation framework";
     homepage = "https://messerlab.org/slim/";
     license = with lib.licenses; [ gpl3 ];
     maintainers = with lib.maintainers; [ bzizou ];
     platforms = lib.platforms.all;
  };
}
