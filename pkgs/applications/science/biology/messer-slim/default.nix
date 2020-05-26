{ stdenv, fetchurl, cmake, gcc, gcc-unwrapped }:

stdenv.mkDerivation rec {
  version = "3.2.1"; 
  pname = "messer-slim";

  src = fetchurl {
    url = "https://github.com/MesserLab/SLiM/archive/v${version}.tar.gz";
    sha256 = "1j3ssjvxpsc21mmzj59kwimglz8pdazi5w6wplmx11x744k77wa1";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ cmake gcc gcc-unwrapped ];

  cmakeFlags = [ "-DCMAKE_AR=${gcc-unwrapped}/bin/gcc-ar" 
                 "-DCMAKE_RANLIB=${gcc-unwrapped}/bin/gcc-ranlib" ];

  meta = {
     description = "An evolutionary simulation framework";
     homepage = "https://messerlab.org/slim/";
     license = with stdenv.lib.licenses; [ gpl3 ];
     maintainers = with stdenv.lib.maintainers; [ bzizou ];
     platforms = stdenv.lib.platforms.all;
  };
}

