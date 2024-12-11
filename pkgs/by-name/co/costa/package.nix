{ stdenv
, lib
, fetchFromGitHub
, cmake
, mpi
, scalapack
, llvmPackages
}:

stdenv.mkDerivation rec {
  pname = "COSTA";
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "eth-cscs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-jiAyZXC7wiuEnOLsQFFLxhN3AsGXN09q/gHC2Hrb2gg=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ scalapack ] ++ lib.optional stdenv.hostPlatform.isDarwin llvmPackages.openmp;

  propagatedBuildInputs = [ mpi ];

  cmakeFlags = [
    "-DCOSTA_SCALAPACK=CUSTOM"
    "-DSCALAPACK_ROOT=${scalapack}"
  ];


  meta = with lib; {
    description = "Distributed Communication-Optimal Shuffle and Transpose Algorithm";
    homepage = "https://github.com/eth-cscs/COSTA";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = [ maintainers.sheepforce ];
  };
}
