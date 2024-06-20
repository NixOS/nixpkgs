{ lib, stdenv, fetchFromGitHub, cmake, gcc, gcc-unwrapped }:

stdenv.mkDerivation rec {
  version = "4.2.2";
  pname = "messer-slim";

  src = fetchFromGitHub {
    owner = "MesserLab";
    repo = "SLiM";
    rev = "v${version}";
    sha256 = "sha256-TlB7Hj4pVN4p4VanACWjQBeTxP9/DvRvdCdgelrXx60=";
  };

  nativeBuildInputs = [ cmake gcc gcc-unwrapped ];

  cmakeFlags = [ "-DCMAKE_AR=${gcc-unwrapped}/bin/gcc-ar"
                 "-DCMAKE_RANLIB=${gcc-unwrapped}/bin/gcc-ranlib" ];

  meta = {
     description = "Evolutionary simulation framework";
     homepage = "https://messerlab.org/slim/";
     license = with lib.licenses; [ gpl3 ];
     maintainers = with lib.maintainers; [ bzizou ];
     platforms = lib.platforms.all;
  };
}
