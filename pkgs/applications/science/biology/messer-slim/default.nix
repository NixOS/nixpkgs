{ lib, stdenv, fetchFromGitHub, cmake, gcc, gcc-unwrapped }:

stdenv.mkDerivation rec {
  version = "4.0";
  pname = "messer-slim";

  src = fetchFromGitHub {
    owner = "MesserLab";
    repo = "SLiM";
    rev = "v${version}";
    sha256 = "sha256-2iEflSDknlQtCLz2MvEZExOT+MQlEYOMY2JI0XE6mw0=";
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
