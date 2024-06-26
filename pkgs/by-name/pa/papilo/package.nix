{ blas
, boost
, cmake
, fetchFromGitHub
, gfortran12
, lib
, stdenv
, tbb
, zlib
}:

stdenv.mkDerivation rec {
  pname = "papilo";
  version = "2.1.4";

  src = fetchFromGitHub {
    owner = "scipopt";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ALQYCdE4AN/Jpo8TP1UFbJi70Zxm+skcc3oTjMSZ9+Q=";
  };

  buildInputs = [
    blas
    boost
    cmake
    gfortran12
    zlib
  ];

  propagatedBuildInputs = [ tbb ];

  doCheck = true;

  meta = with lib; {
    description = "Parallel Presolve for Integer and Linear Optimization";
    homepage = "https://scipopt.org/";
    license = with licenses; [ lgpl3 ];
    maintainers = with maintainers; [ david-r-cox ];
    mainProgram = "papilo";
  };
}
