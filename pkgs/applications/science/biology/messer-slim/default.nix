{ lib, stdenv, fetchurl, cmake, gcc, gcc-unwrapped }:

stdenv.mkDerivation rec {
  version = "3.6";
  pname = "messer-slim";

  src = fetchurl {
    url = "https://github.com/MesserLab/SLiM/archive/v${version}.tar.gz";
    sha256 = "sha256-djWUKB+NW2a/6oaAMcH0Ul/R/XPHvGDbwlfeFmkbMOY=";
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
